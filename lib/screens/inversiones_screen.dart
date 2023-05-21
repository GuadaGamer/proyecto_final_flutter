import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InversionesScreen extends StatelessWidget {
  InversionesScreen({super.key});

  final ProyectosFirebase _firebase = ProyectosFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _firebase.getAllDonations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!;
            double total = 0.0;
                  for (var element in documents) {
                    total = total + element.get('cuanto').toDouble();
                  }
            return Column(
              children: [
                SizedBox(height: 10,),
                Text(
                    'Total invertido: $total',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                Expanded(
                  child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Timestamp timestamp =
                            documents[index].get('cuando');
                        int milli = timestamp.millisecondsSinceEpoch;
                        DateTime trsData =
                            DateTime.fromMillisecondsSinceEpoch(milli);
                        String formattedDate =
                            DateFormat('kk:mm:ss EEE d MMM').format(trsData);
                        return ListTile(
                          title: Text(documents[index].get('cuanto').toString(), style: TextStyle(color: Colors.white),),
                          subtitle: Text(formattedDate, style: TextStyle(color: Colors.white),),
                        );
                      }),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(
              'Ocurrió un error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
