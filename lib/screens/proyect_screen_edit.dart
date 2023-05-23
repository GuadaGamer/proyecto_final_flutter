import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/providers/islogin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:intl/intl.dart';

class ProyectScreenEdit extends StatefulWidget {
  ProyectScreenEdit({super.key, required this.id});
  final String id;

  @override
  State<ProyectScreenEdit> createState() => _ProyectScreenEditState();
}

class _ProyectScreenEditState extends State<ProyectScreenEdit> {
  ProyectosFirebase _firebase = ProyectosFirebase();
  ValueNotifier<bool> editProyect = ValueNotifier<bool>(false);

  var txtDescProyect = TextEditingController();
  var txtNombreProyect = TextEditingController();
  var totalProyect = TextEditingController();
  var imageProyect = TextEditingController();

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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () { 
                editProyect.value = !editProyect.value;
                flag.setflagListPost();
                },
              icon: Icon(Icons.edit_document)),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: _firebase.getOneProyecto(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Timestamp timestamp = snapshot.data!.docs.first.get('fecha');
                    int milli = timestamp.millisecondsSinceEpoch;
                    DateTime trsData = DateTime.fromMillisecondsSinceEpoch(milli);
                    String formattedDate =
                        DateFormat('kk:mm:ss EEE d MMM').format(trsData);
                    return ValueListenableBuilder(
                        valueListenable: editProyect,
                        builder: (context, value, child) {
                          if (value) {
                            txtDescProyect.text = snapshot.data!.docs[0].get('descripcion');
                            txtNombreProyect.text = snapshot.data!.docs[0].get('nombre');
                            totalProyect.text = snapshot.data!.docs[0].get('total_requerido').toString();
                            imageProyect.text = snapshot.data!.docs[0].get('imagen');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Editar proyecto',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                textItem(
                                    'Nombre del proyecto', txtNombreProyect, 1),
                                SizedBox(
                                  height: 10,
                                ),
                                textItem('Descripcion', txtDescProyect, 8),
                                SizedBox(
                                  height: 10,
                                ),
                                textItem('Link de la imagen', imageProyect, 2),
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
                                      }
                                      return null;
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
                                    onPressed: () {
                                      _firebase.updProyecto({
                                        'descripcion': txtDescProyect.text,
                                        'nombre': txtNombreProyect.text,
                                        'imagen': imageProyect.text,
                                        'total_requerido':
                                            int.parse(totalProyect.text),
                                      }, snapshot.data!.docs[0].id).whenComplete(
                                          () {
                                        var snackBar = SnackBar(
                                            content:
                                                Text('Registro actualizado'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text('Actualizar proyecto'))
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Text(snapshot.data!.docs[0].get('nombre'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                SizedBox(
                                  height: 10,
                                ),
                                ClipRRect(
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    height: 225,
                                    placeholder:
                                        const AssetImage('assets/loading.gif'),
                                    //image: const AssetImage('assets/maincraft.webp')
                                    image: NetworkImage(
                                        snapshot.data!.docs[0].get('imagen'),
                                        scale: 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data!.docs[0].get('descripcion'),
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(formattedDate,
                                    style: TextStyle(color: Colors.white)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () => _launchEmail(FirebaseAuth
                                            .instance.currentUser!.email!),
                                        child: Text(
                                            FirebaseAuth
                                                .instance.currentUser!.email!,
                                            style:
                                                TextStyle(color: Colors.white))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.contact_mail,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new CircularPercentIndicator(
                                  radius: 120.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: (snapshot.data!.docs[0]
                                              .get('total_recaudado')
                                              .toDouble() *
                                          1) /
                                      snapshot.data!.docs[0]
                                          .get('total_requerido')
                                          .toDouble(),
                                  center: new Text(
                                    '${(snapshot.data!.docs[0].get('total_recaudado').toDouble() * 100) / snapshot.data!.docs[0].get('total_requerido').toDouble()} %',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white),
                                  ),
                                  footer: new Text(
                                    "Total racaudado",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                        color: Colors.white),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.purple,
                                ),
                              ],
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: const Text('Ocurrio un error'),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey[700],
        onPressed: () {},
        label: Text('Seguir proyecto'),
        icon: Icon(Icons.favorite),
      ),
    );
  }

  Future<void> _launchEmail(String mail) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: mail,
    );
    await launchUrl(launchUri);
  }
}
