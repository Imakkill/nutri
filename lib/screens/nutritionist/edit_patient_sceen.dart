import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPatientScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const EditPatientScreen(
      {super.key, required this.patientId, required this.patientName});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedMeal;
  String? _selectedFood;
  final _quantityController = TextEditingController();

  final List<String> _meals = ['Café da Manhã', 'Almoço', 'Jantar'];
  List<String> _foods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<String> getAccessToken() async {
    const String clientId = '8e4b8af6ed0c496ea9bb8a86f80a6948';
    const clientSecret = 'f9e52eba9b0245ac825d5bcce4ddf9b5';
    const String authUrl = 'https://oauth.fatsecret.com/connect/token';

    final response = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
        'scope': 'basic',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  Future<void> _fetchFoods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await getAccessToken();
      const String url = 'https://platform.fatsecret.com/rest/server.api';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'method': 'foods.search',
          'search_expression':
              'apple', // Exemplo de pesquisa, ajuste conforme necessário
          'format': 'json',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _foods = data['foods']['food']
              .map<String>((food) => food['food_name'] as String)
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePatientInfo() async {
    final height = _heightController.text;
    final weight = _weightController.text;

    if (height.isEmpty || weight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientId)
        .update({
      'height': height,
      'weight': weight,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso')),
      );
    }
  }

  Future<void> _addMealPlan() async {
    final quantity = _quantityController.text;

    if (_selectedMeal == null || _selectedFood == null || quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientId)
        .collection('mealPlans')
        .add({
      'meal': _selectedMeal,
      'food': _selectedFood,
      'quantity': quantity,
    });

    _quantityController.clear();
    setState(() {
      _selectedMeal = null;
      _selectedFood = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plano alimentar adicionado com sucesso')),
      );
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.patientName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePatientInfo,
                child: const Text('Atualizar Informações'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedMeal,
                decoration: const InputDecoration(labelText: 'Refeição'),
                items: _meals.map((String meal) {
                  return DropdownMenuItem<String>(
                    value: meal,
                    child: Text(meal),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMeal = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _selectedFood,
                      decoration: const InputDecoration(labelText: 'Alimento'),
                      items: _foods.map((String food) {
                        return DropdownMenuItem<String>(
                          value: food,
                          child: Text(food),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFood = newValue;
                        });
                      },
                    ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                    labelText: 'Quantidade (Ex: 2 conchas)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMealPlan,
                child: const Text('Adicionar Plano Alimentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
