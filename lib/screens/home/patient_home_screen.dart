import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';
import '../profile/patient_profile_screen.dart'; // Certifique-se de ajustar o caminho conforme necessário

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  PatientHomeScreenState createState() => PatientHomeScreenState();
}

class PatientHomeScreenState extends State<PatientHomeScreen> {
  Future<void> _confirmLogout() async {
    bool? logoutConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Usuário deve tocar no botão para fechar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (logoutConfirmed == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        // Verifica se o estado ainda está montado antes de navegar
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Dieta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromARGB(255, 45, 140, 230)],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Text('Aqui será exibida a dieta do paciente.'),
            ),
            Positioned(
              bottom: 20.0, // Ajuste a distância do fundo
              right: 20.0, // Ajuste a distância da direita
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 181, 196, 238),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        color: const Color.fromARGB(
            255, 51, 104, 202), // Fundo em um verde mais claro
        shape:
            const CircularNotchedRectangle(), // Pode usar uma forma se quiser
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PatientProfileScreen()),
                );
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
