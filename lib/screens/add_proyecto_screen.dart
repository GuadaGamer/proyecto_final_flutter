import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/providers/islogin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class AddProyectScreen extends StatelessWidget {
  AddProyectScreen({super.key, this.id});
  final String? id;

  final ProyectosFirebase _firebase = ProyectosFirebase();
  final EmpresasFirebase _empresasFirebase = EmpresasFirebase();
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();

  final txtDescProyect = TextEditingController();
  final txtNombreProyect = TextEditingController();
  final totalProyect = TextEditingController();
  final imageProyect = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);

    Widget textItem(
        String labeltext, TextEditingController controller, int max) {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: max >= 2 ? 80 : 55,
        child: TextFormField(
          controller: controller,
          maxLines: max,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Por favor llena este campo';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: labeltext,
            labelStyle: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.amber,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              height: 500,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Añadir proyecto',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  textItem('Nombre del proyecto', txtNombreProyect, 1),
                  SizedBox(
                    height: 10,
                  ),
                  textItem('Descripcion', txtDescProyect, 8),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    height: 80,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor llena este campo';
                        } else {
                          return null;
                        }
                      },
                      controller: imageProyect,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Link de la imagen',
                        labelStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.amber,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    height: 1 >= 2 ? 80 : 55,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor llena este campo';
                        } else {
                          return null;
                        }
                      },
                      controller: totalProyect,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Total requerido',
                        labelStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.amber,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (await launchURL(imageProyect.text)) {
                            _firebase.insProyecto({
                              'descripcion': txtDescProyect.text,
                              'nombre': txtNombreProyect.text,
                              'imagen': imageProyect.text,
                              'total_requerido': int.parse(totalProyect.text),
                              'fecha': DateTime.now(),
                              'total_recaudado': 0,
                            }).whenComplete(() async {
                              //sendNotificationToTopic();
                              String idDocument =
                                  await _firebase.getLastProyecto();
                              await _empresasFirebase
                                  .updEmpresaCorreo(idDocument);
                              var snackBar =
                                  SnackBar(content: Text('Registro insertado'));
                              flag.setflagListPost();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pop(context);
                            });
                          } else {
                            var snackBar = SnackBar(
                                content:
                                    Text('El link de la imagen no es valido'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: const Text('Añadir proyecto'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendNotificationToTopic() async {
    // final String serverToken = '<eTGGdHEcTg-SGqnG75ep-8:APA91bEl-NCxl2eiXFOcsQQeNEqSCd4A8xabT4Jy4O2Pm1qolrxG4IzhVqAv2F0R1ySuOPnazuZVjubtTXTasub_hzRtRucy0EW2YDS_XKfnTr_jR_-GaPJLFPPbWJi7tW100GV2t1et>';
    // final response = await dio.post(
    //   'https://fcm.googleapis.com/fcm/send',
    //   options: Options(
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'key=$serverToken',
    //     },
    //   ),
    //   data: {
    //     'notification': {'body': 'Nuevo proyecto disponible', 'title': 'Ve el nuevo proyecto disponible'},
    //     'priority': 'high',
    //     'data': {
    //       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //       'id': '1',
    //       'status': 'done'
    //     },
    //     'to': '/topics/proyecto',
    //   },
    // );
  }

  Future<bool> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print('si');
      return true;
    } else {
      print('no');
      return false;
    }
  }
}
