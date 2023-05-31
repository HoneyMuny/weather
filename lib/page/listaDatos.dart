import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Lectura de esp8266'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('variablesTH').snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic>  data = document.data()! as Map<String, dynamic>;  //en nuevo paquete
                  return ListTile(
                    title: Text("Humedad: "+data['Humedad'].toString()),
                    subtitle: Text("Temperatura: "+data['Temperatura'].toString()),
                   /* leading: Image(
                      image: NetworkImage(data['foto']),
                      fit: BoxFit.fitHeight,
                      width: 50,
                    ),*/
                  );
                }).toList(),
              );
            }
        )
    );
  }
}