import 'dart:io';

import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/Service/upload_image.dart';
import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.id});
  final String id;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ValueNotifier<XFile?> image = ValueNotifier<XFile?>(null);
  ValueNotifier<bool> edit = ValueNotifier<bool>(false);
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  EmpresasFirebase _firebase = EmpresasFirebase();
  bool nuevo = false;

   final txtNameFact = TextEditingController();
    final txtDescFact = TextEditingController();
    final txtLocacionFact = TextEditingController();
    final txtRFCFact = TextEditingController();
    final txtTelFact = TextEditingController();
    final txtRubroFact = TextEditingController();
    final txtUrlFact = TextEditingController();

  @override
  Widget build(BuildContext context) {

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
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () => edit.value = !edit.value, icon: Icon(Icons.edit)),
      ]),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        child: ValueListenableBuilder(
                            valueListenable: image,
                            builder: (context, value, child) {
                              return FirebaseAuth
                                          .instance.currentUser!.photoURL !=
                                      null
                                  ? value?.path == null
                                      ? FirebaseAuth.instance.currentUser
                                                  ?.photoURL!
                                                  .contains(
                                                      'firebasestorage') ==
                                              true
                                          ? Image.network(
                                              FirebaseAuth.instance.currentUser!
                                                  .photoURL!,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset('assets/profile.png')
                                      : Image.file(
                                          File(value!.path),
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset('assets/profile.png');
                            })),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(),
                        IconButton(
                            onPressed: () async {
                              image.value = await _picker.pickImage(
                                  source: ImageSource.camera);
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.teal,
                              size: 30,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: _firebase.getOneEmpresa(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ValueListenableBuilder(
                                valueListenable: edit,
                                builder: (context, value, child) {
                                  if (value) {
                                    txtNameFact.text =
                                        snapshot.data!.docs[0].get('nombre');
                                    txtDescFact.text = snapshot.data!.docs[0]
                                        .get('descripción');
                                    txtLocacionFact.text =
                                        snapshot.data!.docs[0].get('pais');
                                    txtRFCFact.text =
                                        snapshot.data!.docs[0].get('rfc');
                                    txtTelFact.text =
                                        snapshot.data!.docs[0].get('telefono');
                                    txtRubroFact.text = snapshot.data!.docs[0]
                                        .get('tipo_empresa');
                                    txtUrlFact.text =
                                        snapshot.data!.docs[0].get('url');
                                    return Column(
                                      children: [
                                        textItem('Nombre', txtNameFact, 1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem('Descripción', txtDescFact, 5),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem('Pais', txtLocacionFact, 1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem('RFC', txtRFCFact, 1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70,
                                          height: 1 >= 2 ? 80 : 55,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Por favor llena este campo';
                                              }
                                              return null;
                                            },
                                            controller: txtTelFact,
                                            maxLines: 1,
                                            keyboardType: TextInputType.phone,
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Numero de telefono',
                                              labelStyle: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                        textItem(
                                            'Tipo de empresa', txtRubroFact, 2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem('URL', txtUrlFact, 3),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  } else {
                                    if (snapshot.data!.size > 0) {
                                      return Column(
                                        children: [
                                          Text(
                                              snapshot.data!.docs[0]
                                                      .get('nombre') ??
                                                  'Sin nombre',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              snapshot.data!.docs[0]
                                                      .get('descripción') ??
                                                  'Sin desc',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  snapshot.data!.docs[0]
                                                          .get('pais') ??
                                                      'Sin pais',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () => _launchEmail(
                                                      snapshot.data!.docs[0]
                                                          .get('correo')),
                                                  child: Text(
                                                      snapshot.data!.docs[0]
                                                          .get('correo'),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.mail_lock,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SelectableText(
                                                  snapshot.data!.docs[0]
                                                      .get('rfc'),
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.perm_identity,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () =>
                                                      _launchCaller(snapshot
                                                              .data!.docs[0]
                                                              .get(
                                                                  'telefono') ??
                                                          'Sin nombre'),
                                                  child: Text(
                                                      snapshot.data!.docs[0]
                                                              .get(
                                                                  'telefono') ??
                                                          'Sin telefono',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.phone_forwarded,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SelectableText(
                                                  snapshot.data!.docs[0].get(
                                                          'tipo_empresa') ??
                                                      'Sin tipo',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.factory,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () =>
                                                      _launchInBrowser(
                                                          Uri.parse(snapshot
                                                                  .data!.docs[0]
                                                                  .get('url') ??
                                                              'Sin url')),
                                                  child: Text(
                                                      snapshot.data!.docs[0]
                                                              .get('url') ??
                                                          'Sin url',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.dataset_linked,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      nuevo = true;
                                      return Column(
                                        children: [
                                          textItem('Nombre', txtNameFact, 1),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          textItem(
                                              'Descripción', txtDescFact, 5),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          textItem('Pais', txtLocacionFact, 1),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          textItem('RFC', txtRFCFact, 1),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            height: 1 >= 2 ? 80 : 55,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Por favor llena este campo';
                                                }
                                                return null;
                                              },
                                              controller: txtTelFact,
                                              maxLines: 1,
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                              decoration: InputDecoration(
                                                labelText: 'Numero de telefono',
                                                labelStyle: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                          textItem('Tipo de empresa',
                                              txtRubroFact, 2),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          textItem('URL', txtUrlFact, 3),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                })
                            : Column(
                                children: [
                                  textItem('nombre', txtNameFact, 1),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  textItem('descripcion', txtDescFact, 5),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textItem('Pais', txtLocacionFact, 1),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () => _launchEmail(
                                              FirebaseAuth.instance.currentUser!
                                                  .email!),
                                          child: Text(
                                              FirebaseAuth
                                                  .instance.currentUser!.email!,
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.mail_lock,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textItem('RFC', txtRFCFact, 1),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.perm_identity,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textItem('Telefono', txtTelFact, 1),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.phone_forwarded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      textItem(
                                          'Tipo de empresa', txtRubroFact, 2),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.factory,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textItem('Url', txtUrlFact, 2),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.dataset_linked,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ],
                              );
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.grey[700],
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (image.value != null) {
                final uploaded = await uploadImage(File(image.value!.path));
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(txtNameFact.text);
                nuevo ?
                 _firebase.insEmpresa({
                  'correo': FirebaseAuth.instance.currentUser!.email,
                  'nombre': txtNameFact.text,
                  'descripción': txtDescFact.text,
                  'pais': txtLocacionFact.text,
                  'rfc': txtRFCFact.text,
                  'telefono': txtTelFact.text,
                  'tipo_empresa': txtRubroFact.text,
                  'url': txtUrlFact.text,
                }):
                _firebase.updEmpresa({
                  'nombre': txtNameFact.text,
                  'descripción': txtDescFact.text,
                  'pais': txtLocacionFact.text,
                  'rfc': txtRFCFact.text,
                  'telefono': txtTelFact.text,
                  'tipo_empresa': txtRubroFact.text,
                  'url': txtUrlFact.text,
                }) ;
                if (uploaded) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Imagen subida correctamente')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Error al subir la imagen')));
                }
              } else {
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(txtNameFact.text);
                nuevo ?
                _firebase.insEmpresa({
                  'correo': FirebaseAuth.instance.currentUser!.email,
                  'nombre': txtNameFact.text,
                  'descripción': txtDescFact.text,
                  'pais': txtLocacionFact.text,
                  'rfc': txtRFCFact.text,
                  'telefono': txtTelFact.text,
                  'tipo_empresa': txtRubroFact.text,
                  'url': txtUrlFact.text,
                }):
                _firebase.updEmpresa({
                  'nombre': txtNameFact.text,
                  'descripción': txtDescFact.text,
                  'pais': txtLocacionFact.text,
                  'rfc': txtRFCFact.text,
                  'telefono': txtTelFact.text,
                  'tipo_empresa': txtRubroFact.text,
                  'url': txtUrlFact.text,
                });
              }
              imageChange.value = !imageChange.value;
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.save),
          label: Text('Guardar')),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        image.value = await _picker.pickImage(source: ImageSource.gallery);
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ])),
        child: Center(
          child: Text(
            "Subir foto",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
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

  Future<void> _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
