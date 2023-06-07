import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NuevaPantalla extends StatelessWidget {
  NuevaPantalla({super.key});

  final EmpresasFirebase _firebaseEmpresa = EmpresasFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi constancia'),
      ),
      body: StreamBuilder(
        stream: _firebaseEmpresa.getOneEmpresa(), 
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return  SfPdfViewer.network(
                snapshot.data!.docs.first.get('urlpdf'));
          }else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }else{
            return CircularProgressIndicator();
          }
        },),
    );
  }
}