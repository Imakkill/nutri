import 'package:flutter/material.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Dieta'),
      ),
      body: const Center(
        child: Text('Aqui será exibida a dieta do paciente.'),
      ),
    );
  }
}
