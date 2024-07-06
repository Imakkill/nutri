import 'package:flutter/material.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Dieta'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.greenAccent],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Text('Aqui será exibida a dieta do paciente.'),
            ),
            Positioned(
              bottom: 20.0, // Ajuste a distância do fundo
              right: 20.0, // Ajuste a distância da esquerda
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        color: Colors.green,
        shape:
            const CircularNotchedRectangle(), // Pode usar uma forma se quiser
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                // Navegar para o perfil do usuário
              },
              icon: const Icon(Icons.person),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                // Navegar para a home
              },
              icon: const Icon(Icons.home),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                // Navegar para o plano alimentar
              },
              icon: const Icon(Icons.restaurant_menu),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
