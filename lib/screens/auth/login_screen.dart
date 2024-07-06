import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/login_form.dart';

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

  Future<void> _signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authService.signIn(email, password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      bool isNutritionist = userDoc['isNutritionist'];

      // Navegação para a tela apropriada após login bem-sucedido
      // Use o operador `async` para aguardar a navegação ser concluída
      await Future.microtask(() => Navigator.pushReplacementNamed(
            context,
            isNutritionist ? '/nutritionistHome' : '/patientHome',
          ));
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.code);
    } catch (e) {
      _showErrorDialog('unknown-error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(onSubmit: _signIn),
      ),
    );
  }
}