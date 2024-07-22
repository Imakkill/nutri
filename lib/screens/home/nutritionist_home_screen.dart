import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutriplus/screens/nutritionist/add_patient_screen.dart';
// Ajuste o caminho conforme necessário
import 'package:nutriplus/screens/nutritionist/add_food_screen.dart'; // Certifique-se de que este caminho está correto
import 'package:nutriplus/screens/nutritionist/edit_patient_sceen.dart'; // Certifique-se de que este caminho está correto

class NutritionistHomeScreen extends StatefulWidget {
  const NutritionistHomeScreen({super.key});

  @override
  NutritionistHomeScreenState createState() => NutritionistHomeScreenState();
}

class NutritionistHomeScreenState extends State<NutritionistHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPatientScreen(),
                ),
              );
            },
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('isNutritionist', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhum paciente encontrado.'));
            }

            final patients = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      patient['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Email: ${patient['email']}\nAltura: ${patient['height']} cm',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPatientScreen(
                            patientId: patient.id,
                            patientName: patient['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Adicione a navegação para a home screen se necessário
              },
            ),
            IconButton(
              icon: const Icon(Icons.food_bank),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddFoodScreen(patientId: 'examplePatientId'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
