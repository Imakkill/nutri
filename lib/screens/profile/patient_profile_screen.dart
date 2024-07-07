import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  PatientProfileScreenState createState() => PatientProfileScreenState();
}

class PatientProfileScreenState extends State<PatientProfileScreen> {
  User? user;
  DocumentSnapshot? userDoc;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userDoc == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Map<String, dynamic> userData = userDoc!.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Número de Identificação: ${userData['patientId']}'),
            const SizedBox(height: 20),
            Text('Email: ${userData['email']}'),
            const SizedBox(height: 20),
            Text('Altura: ${userData['height'] ?? 'Não definido'}'),
            const SizedBox(height: 20),
            const Text('Histórico de Peso:'),
            Expanded(
              child: ListView.builder(
                itemCount: userData['weightHistory'].length,
                itemBuilder: (context, index) {
                  var entry = userData['weightHistory'][index];
                  return ListTile(
                    title: Text('Peso: ${entry['weight']} kg'),
                    subtitle: Text('Data: ${entry['date']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
