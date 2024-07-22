import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/patient_home_screen.dart';
import 'screens/profile/patient_profile_screen.dart';
import 'screens/home/nutritionist_home_screen.dart';
import 'package:nutriplus/screens/nutritionist/patient_posts_screen.dart.dart'; // Corrigido o caminho
import 'screens/nutritionist/add_patient_screen.dart'; // Adicionado
import 'screens/nutritionist/add_food_screen.dart'; // Adicionado
import 'screens//nutritionist/edit_patient_sceen.dart'; // Corrigido o nome do arquivo

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/patientHome': (context) => const PatientHomeScreen(),
        '/patientProfile': (context) => const PatientProfileScreen(),
        '/nutritionistHome': (context) => const NutritionistHomeScreen(),
        '/patientPosts': (context) => const PatientPostsScreen(
            patientName: 'Paciente'), // Ajuste conforme necessário
        '/addPatient': (context) => const AddPatientScreen(),
        '/addFood': (context) => const AddFoodScreen(
            patientId: 'examplePatientId'), // Ajuste conforme necessário
        '/editPatient': (context) => const EditPatientScreen(
            patientId: 'examplePatientId',
            patientName: 'Paciente'), // Ajuste conforme necessário
      },
    );
  }
}
