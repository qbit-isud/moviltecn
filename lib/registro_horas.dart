import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroHorasScreen extends StatefulWidget {
  @override
  _RegistroHorasScreenState createState() => _RegistroHorasScreenState();
}

class _RegistroHorasScreenState extends State<RegistroHorasScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void registrarHora(String tipo) {
    _firestore.collection('registros').add({
      'email': loggedInUser.email,
      'hora': Timestamp.now(),
      'tipo': tipo,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Hora'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                registrarHora('ingreso');
              },
              child: Text('Registrar Hora de Ingreso'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                registrarHora('salida');
              },
              child: Text('Registrar Hora de Salida'),
            ),
          ],
        ),
      ),
    );
  }
}
