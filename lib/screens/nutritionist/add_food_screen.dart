import 'package:flutter/material.dart';
import 'package:nutriplus/services/fatsecret_service.dart';

class AddFoodScreen extends StatefulWidget {
  final String patientId;
  const AddFoodScreen({super.key, required this.patientId});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _queryController = TextEditingController();
  final FatSecretService _fatSecretService = FatSecretService();
  List<dynamic> _searchResults = [];

  Future<void> _searchFoods() async {
    final query = _queryController.text;

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um termo de busca')),
      );
      return;
    }

    final results = await _fatSecretService.searchFoods(query);
    setState(() {
      _searchResults = results;
    });
  }

  Future<void> _addFoodToPatient(String foodName, int calories) async {
    // Implemente a lógica para adicionar o alimento ao paciente, por exemplo, salvando no Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Alimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(labelText: 'Buscar Alimento'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchFoods,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final food = _searchResults[index];
                  return ListTile(
                    title: Text(food['food_name']),
                    subtitle: Text('Calorias: ${food['food_description']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addFoodToPatient(food['food_name'],
                            int.parse(food['food_description'].split(' ')[1]));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
