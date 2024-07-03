import 'package:flutter/material.dart';

class NutritionistHomeScreen extends StatelessWidget {
  const NutritionistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed dos Pacientes'),
      ),
      body: Center(
        child: const Text(
            'Aqui será exibido o feed com as postagens dos pacientes.'),
      ),
    );
  }
}
