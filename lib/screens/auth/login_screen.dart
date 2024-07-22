import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../home/patient_home_screen.dart';
import '../home/nutritionist_home_screen.dart'; // Certifique-se de ter essa tela
import 'register_screen.dart'; // Certifique-se de ter essa tela

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      // Verifica se o usuário é nutricionista ou paciente
      User? user = userCredential.user;
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!mounted) return;

      bool isNutritionist = userData['isNutritionist'];

      if (isNutritionist) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const NutritionistHomeScreen()), // Certifique-se de ter essa tela
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 18, 0, 68),
              Color.fromRGBO(33, 150, 243, 1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/logo_bg.png', // Certifique-se de que o caminho do arquivo esteja correto
                height: 200, // Ajuste o tamanho conforme necessário
              ),
              const SizedBox(height: 20),
              const Text(
                'Nutri+',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Lembrar-me',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
