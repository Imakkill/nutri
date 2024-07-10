import 'package:flutter/material.dart';

class PatientMealsScreen extends StatelessWidget {
  const PatientMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Refeições'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromARGB(255, 45, 140, 230)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5, // Substitua isso com o número real de refeições
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  'Refeição ${index + 1}', // Substitua isso com o título da refeição real
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Detalhes da refeição ${index + 1}', // Substitua isso com os detalhes reais da refeição
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(Icons.more_vert),
                onTap: () {
                  // Adicione a lógica para navegar para os detalhes da refeição
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
