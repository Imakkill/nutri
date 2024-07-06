import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../widgets/login_form.dart';
import '../auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  void _showErrorDialog(String errorCode) {
    String message;
    switch (errorCode) {
      case 'user-not-found':
        message = 'Nenhum usuário encontrado para este email.';
        break;
      case 'wrong-password':
        message = 'Senha incorreta fornecida.';
        break;
      case 'invalid-email':
        message = 'O email fornecido é inválido.';
        break;
      default:
        message = 'Ocorreu um erro desconhecido. Tente novamente.';
        break;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _signIn(String email, String password, bool stayLoggedIn) async {
    try {
      await FirebaseAuth.instance.setPersistence(
        stayLoggedIn ? Persistence.LOCAL : Persistence.SESSION,
      );

      UserCredential userCredential =
          await _authService.signIn(email, password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      bool isNutritionist = userDoc['isNutritionist'];

      if (!mounted) return; // Verifique se o widget ainda está montado

      // Navegação para a tela apropriada após login bem-sucedido
      Navigator.pushReplacementNamed(
        context,
        isNutritionist ? '/nutritionistHome' : '/patientHome',
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) _showErrorDialog(e.code);
    } catch (e) {
      if (mounted) _showErrorDialog('unknown-error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Cadastro'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset('assets/images/logo_bg.png'),
                ),
                const SizedBox(height: 20),
                LoginForm(
                  onSubmit: (email, password, stayLoggedIn) =>
                      _signIn(email, password, stayLoggedIn),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
