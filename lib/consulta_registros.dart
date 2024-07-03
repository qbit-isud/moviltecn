import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsultaRegistrosScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

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

  @override
  Widget build(BuildContext context) {
    getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Registros'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('registros')
            .where('email', isEqualTo: loggedInUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No hay registros disponibles'),
            );
          }

          final registros = snapshot.data!.docs;
          List<Widget> registrosWidgets = [];
          for (var registro in registros) {
            final hora = (registro['hora'] as Timestamp).toDate();
            final tipo = registro['tipo'];

            registrosWidgets.add(
              ListTile(
                title: Text('$tipo: ${hora.toString()}'),
              ),
            );
          }

          return ListView(
            children: registrosWidgets,
          );
        },
      ),
    );
  }
}
