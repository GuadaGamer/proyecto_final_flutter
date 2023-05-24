import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/screens/proyect_screen.dart';
import 'package:firebase_app_web/widgets/firebaseBarChart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InversionesScreen extends StatelessWidget {
  InversionesScreen( { super.key});

  final ProyectosFirebase _firebase = ProyectosFirebase();
  final ValueNotifier<bool> showAvg = ValueNotifier<bool>(false);
  final List<ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis inversiones'),
      ),
      body: StreamBuilder(
        stream: _firebase.getAllDonations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!;
            double total = 0.0;
                  for (var element in documents) {
                    Timestamp timestamp =
                            element.get('cuando');
                        int milli = timestamp.millisecondsSinceEpoch;
                        DateTime trsData =
                            DateTime.fromMillisecondsSinceEpoch(milli);
                        String formattedDate =
                            DateFormat('y-dd-MM').format(trsData);
                    total = total + element.get('cuanto').toDouble();
                    if ( chartData.isEmpty){
                      chartData.add(new ChartData(formattedDate, element.get('cuanto').toDouble()));
                    }else{
                      bool nuevo = true;
                      for (var dato in chartData) {
                        if (dato.date == formattedDate){
                          dato.value = dato.value + element.get('cuanto').toDouble();
                          nuevo=false;
                        }
                      }
                      if (nuevo){
                          chartData.add(new ChartData(formattedDate, element.get('cuanto').toDouble()));
                      }
                    }
                  }
            return Column(
              children: [
                SizedBox(height: 10,),
                Text(
                    'Total invertido: $total',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Expanded(
                    child: FirebaseBarChart(
                    chartData: chartData),
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
                          onTap: () async {
                            String idPadre = await _firebase.obtenerIdPadreDesdeHijo(documents[index].id).whenComplete(() => null);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProyectScreen(id: idPadre)));
                          },
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
