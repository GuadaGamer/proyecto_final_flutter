import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:intl/intl.dart';

class ProyectScreen extends StatefulWidget {
  ProyectScreen({super.key, this.id});
  final String? id;

  @override
  State<ProyectScreen> createState() => _ProyectScreenState();
}

class _ProyectScreenState extends State<ProyectScreen> {
  ProyectosFirebase _firebase = ProyectosFirebase();
  final EmpresasFirebase _empresasFirebase = EmpresasFirebase();
  TextEditingController txtValor = TextEditingController();
  ValueNotifier<bool> inversion = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    String ids = widget.id == null ? arg.toString() : widget.id.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del proyecto'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                    stream: _firebase.getOneProyecto(ids),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Timestamp timestamp =
                            snapshot.data!.docs.first.get('fecha');
                        int milli = timestamp.millisecondsSinceEpoch;
                        DateTime trsData =
                            DateTime.fromMillisecondsSinceEpoch(milli);
                        String formattedDate =
                            DateFormat('kk:mm:ss EEE d MMM').format(trsData);
                        return Responsive(
                          desktop: Text(''),
                          mobile: Column(
                            children: [
                              Text(snapshot.data!.docs[0].get('nombre'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 225,
                                  placeholder: (context, url) =>
                                      Image.asset('assets/loading.gif'),
                                  imageUrl:
                                      snapshot.data!.docs[0].get('imagen'),
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
                                  FutureBuilder<String>(
                                            future: _firebase.obtenerCorreoPadreDesdeHijo(widget.id.toString()),
                                            builder: (context, snapshot) {
                                              return TextButton(
                                      onPressed: () => _launchEmail(snapshot.data.toString()),
                                      child: Text(
                                          snapshot.data.toString(),
                                          style:
                                              TextStyle(color: Colors.white)));
                                            },                                            
                                          ),
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
                              Stack(
                                alignment: Alignment.center,
                                children: [
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
                                      "Total racaudado: ${snapshot.data!.docs[0].get('total_recaudado')} de ${snapshot.data!.docs[0].get('total_requerido')}",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.white),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.purple,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: -10,
                                      child: InkWell(
                                        splashColor: Colors.blueGrey[700],
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Invertir un este proyecto',
                                                    textAlign:
                                                        TextAlign.center),
                                                content: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller: txtValor,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Cantidad a aportar',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                          'Cancelar')),
                                                  TextButton(
                                                      child: const Text(
                                                          'Invetir ahora'),
                                                      onPressed: () {
                                                        if (txtValor
                                                            .text.isEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Se requiere una cantidad'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                          return;
                                                        } else {
                                                          if (snapshot.data!
                                                                      .docs[0]
                                                                      .get(
                                                                          'total_recaudado') +
                                                                  int.parse(
                                                                      txtValor
                                                                          .text) <=
                                                              snapshot
                                                                  .data!.docs[0]
                                                                  .get(
                                                                      'total_requerido')) {
                                                            _firebase
                                                                .insertarDonacion(
                                                                    {
                                                                  'correo': FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email,
                                                                  'cuando':
                                                                      DateTime
                                                                          .now(),
                                                                  'cuanto': int
                                                                      .parse(txtValor
                                                                          .text),
                                                                },
                                                                    snapshot
                                                                        .data!
                                                                        .docs[0]
                                                                        .id);
                                                            _firebase.updProyecto(
                                                                {
                                                                  'total_recaudado': (snapshot
                                                                          .data!
                                                                          .docs[
                                                                              0]
                                                                          .get(
                                                                              'total_recaudado')
                                                                          .toInt() +
                                                                      int.parse(
                                                                          txtValor
                                                                              .text))
                                                                },
                                                                snapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .id).whenComplete(
                                                                () => txtValor
                                                                    .clear());
                                                            var snackBar = SnackBar(
                                                                content: Text(
                                                                    'Inversión realizado con exito'));
                                                            inversion.value =
                                                                !inversion
                                                                    .value;

                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('El valor de la inversión supera el limite requerido')));
                                                          }
                                                        }
                                                      })
                                                ]),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.shopping_bag,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Invertir',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ), // Texto
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                          tablet: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(snapshot.data!.docs[0].get('nombre'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(formattedDate,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FutureBuilder<String>(
                                            future: _firebase.obtenerCorreoPadreDesdeHijo(widget.id.toString()),
                                            builder: (context, snapshot) {
                                              return TextButton(
                                      onPressed: () => _launchEmail(snapshot.data.toString()),
                                      child: Text(
                                          snapshot.data.toString(),
                                          style:
                                              TextStyle(color: Colors.white)));
                                            },                                            
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.contact_mail,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: 225,
                                          placeholder: (context, url) =>
                                              Image.asset('assets/loading.gif'),
                                          imageUrl: snapshot.data!.docs[0]
                                              .get('imagen'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          snapshot.data!.docs[0]
                                              .get('descripcion'),
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                   
                                  Column(
                                children: [
                                  Stack(
                                alignment: Alignment.center,
                                children: [
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
                                      "Total racaudado: ${snapshot.data!.docs[0].get('total_recaudado')} de ${snapshot.data!.docs[0].get('total_requerido')}",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.white),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.purple,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: -10,
                                      child: InkWell(
                                        splashColor: Colors.blueGrey[700],
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Invertir un este proyecto',
                                                    textAlign:
                                                        TextAlign.center),
                                                content: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller: txtValor,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Cantidad a aportar',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                          'Cancelar')),
                                                  TextButton(
                                                      child: const Text(
                                                          'Invetir ahora'),
                                                      onPressed: () {
                                                        if (txtValor
                                                            .text.isEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Se requiere una cantidad'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                          return;
                                                        } else {
                                                          if (snapshot.data!
                                                                      .docs[0]
                                                                      .get(
                                                                          'total_recaudado') +
                                                                  int.parse(
                                                                      txtValor
                                                                          .text) <=
                                                              snapshot
                                                                  .data!.docs[0]
                                                                  .get(
                                                                      'total_requerido')) {
                                                            _firebase
                                                                .insertarDonacion(
                                                                    {
                                                                  'correo': FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email,
                                                                  'cuando':
                                                                      DateTime
                                                                          .now(),
                                                                  'cuanto': int
                                                                      .parse(txtValor
                                                                          .text),
                                                                },
                                                                    snapshot
                                                                        .data!
                                                                        .docs[0]
                                                                        .id);
                                                            _firebase.updProyecto(
                                                                {
                                                                  'total_recaudado': (snapshot
                                                                          .data!
                                                                          .docs[
                                                                              0]
                                                                          .get(
                                                                              'total_recaudado')
                                                                          .toInt() +
                                                                      int.parse(
                                                                          txtValor
                                                                              .text))
                                                                },
                                                                snapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .id).whenComplete(
                                                                () => txtValor
                                                                    .clear());
                                                            var snackBar = SnackBar(
                                                                content: Text(
                                                                    'Inversión realizado con exito'));
                                                            inversion.value =
                                                                !inversion
                                                                    .value;

                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('El valor de la inversión supera el limite requerido')));
                                                          }
                                                        }
                                                      })
                                                ]),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.shopping_bag,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Invertir',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ), // Texto
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                                ],
                              ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey[700],
        onPressed: () async {
          bool documentoExiste = await _empresasFirebase.existeDocumento();
          if (documentoExiste) {
            await FirebaseMessaging.instance
              .subscribeToTopic('proyecto')
              .whenComplete(() async => await _empresasFirebase.updEmpresaFavoritos( widget.id.toString() ).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nueva subscripcion activa'),
                      duration: Duration(seconds: 2),
                    ),
                  )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Aun no creas tu empresa, accede a tu perfil')));
          }
        },
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
