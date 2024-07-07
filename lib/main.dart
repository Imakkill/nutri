import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutriplus/screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/patient_home_screen.dart'; // Corrigido o caminho
import 'screens/profile/patient_profile_screen.dart'; // Corrigido o caminho

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri Plus',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/patientHome': (context) => const PatientHomeScreen(),
        '/patientProfile': (context) => const PatientProfileScreen(),
      },
    );
  }
}
