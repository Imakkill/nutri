import 'package:flutter/material.dart';

class PatientDietPlanScreen extends StatefulWidget {
  const PatientDietPlanScreen({super.key});

  @override
  PatientDietPlanScreenState createState() => PatientDietPlanScreenState();
}

class PatientDietPlanScreenState extends State<PatientDietPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plano Alimentar'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromARGB(255, 45, 140, 230)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDietPlanCard(
                  'Café da Manhã', 'Detalhes do café da manhã...'),
              const SizedBox(height: 20),
              _buildDietPlanCard('Almoço', 'Detalhes do almoço...'),
              const SizedBox(height: 20),
              _buildDietPlanCard('Jantar', 'Detalhes do jantar...'),
              const SizedBox(height: 20),
              _buildDietPlanCard('Lanches', 'Detalhes dos lanches...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietPlanCard(String title, String details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 45, 140, 230),
          ),
        ),
        subtitle: Text(
          details,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward,
            color: Color.fromARGB(255, 45, 140, 230)),
        onTap: () {
          // Navegar para detalhes do plano alimentar
        },
      ),
    );
  }
}
