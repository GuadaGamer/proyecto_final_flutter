import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/Service/upload_document.dart';
import 'package:firebase_app_web/Service/upload_image.dart';
import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:firebase_app_web/responsive.dart';
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
  ValueNotifier<bool> documentUpload = ValueNotifier<bool>(false);
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  EmpresasFirebase _firebase = EmpresasFirebase();
  bool nuevo = false;
  File? archivo;
  var linkDoc;

  final txtNameFact = TextEditingController();
  final txtDescFact = TextEditingController();
  final txtLocacionFact = TextEditingController();
  final txtRFCFact = TextEditingController();
  final txtTelFact = TextEditingController();
  final txtRubroFact = TextEditingController();
  final txtUrlFact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget textItem(String labeltext, TextEditingController controller, int max,
        double ancho) {
      return Container(
        width: ancho,
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
              return 'Campo requerido';
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
      appBar: AppBar(title: Text('Mi perfil'), actions: [
        IconButton(
            onPressed: () => edit.value = !edit.value, icon: Icon(Icons.edit)),
      ]),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Responsive(
                desktop: Text(''),
                mobile: Column(
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
                                            ? CachedNetworkImage(
                                                imageUrl: FirebaseAuth.instance
                                                    .currentUser!.photoURL!,
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
                          button(MediaQuery.of(context).size.width / 2),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder(
                            stream: _firebase.getOneEmpresa(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? ValueListenableBuilder(
                                      valueListenable: edit,
                                      builder: (context, value, child) {
                                        if (value) {
                                          txtNameFact.text = snapshot
                                              .data!.docs[0]
                                              .get('nombre');
                                          txtDescFact.text = snapshot
                                              .data!.docs[0]
                                              .get('descripción');
                                          txtLocacionFact.text = snapshot
                                              .data!.docs[0]
                                              .get('pais');
                                          txtRFCFact.text =
                                              snapshot.data!.docs[0].get('rfc');
                                          txtTelFact.text = snapshot
                                              .data!.docs[0]
                                              .get('telefono')
                                              .toString();
                                          txtRubroFact.text = snapshot
                                              .data!.docs[0]
                                              .get('tipo_empresa');
                                          txtUrlFact.text =
                                              snapshot.data!.docs[0].get('url');
                                          return Column(
                                            children: [
                                              textItem(
                                                  'Nombre',
                                                  txtNameFact,
                                                  1,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              textItem(
                                                  'Descripción',
                                                  txtDescFact,
                                                  5,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              textItem(
                                                  'Pais',
                                                  txtLocacionFact,
                                                  1,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              textItem(
                                                  'RFC',
                                                  txtRFCFact,
                                                  1,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
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
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Numero de telefono',
                                                    labelStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
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
                                                  'Tipo de empresa',
                                                  txtRubroFact,
                                                  2,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              textItem(
                                                  'URL',
                                                  txtUrlFact,
                                                  3,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70),
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
                                                    snapshot.data!.docs[0].get(
                                                            'descripción') ??
                                                        'Sin desc',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                        snapshot.data!.docs[0]
                                                                .get('pais') ??
                                                            'Sin pais',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            _launchEmail(snapshot
                                                                .data!.docs[0]
                                                                .get('correo')),
                                                        child: Text(
                                                            snapshot
                                                                .data!.docs[0]
                                                                .get('correo'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SelectableText(
                                                        snapshot.data!.docs[0]
                                                            .get('rfc'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            _launchCaller(snapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .get(
                                                                        'telefono') ??
                                                                'Sin nombre'),
                                                        child: Text(
                                                            snapshot.data!
                                                                    .docs[0]
                                                                    .get(
                                                                        'telefono') ??
                                                                'Sin telefono',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SelectableText(
                                                        snapshot.data!.docs[0].get(
                                                                'tipo_empresa') ??
                                                            'Sin tipo',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            _launchInBrowser(
                                                                Uri.parse(snapshot
                                                                        .data!
                                                                        .docs[0]
                                                                        .get(
                                                                            'url') ??
                                                                    'Sin url')),
                                                        child: Text(
                                                            snapshot.data!
                                                                    .docs[0]
                                                                    .get(
                                                                        'url') ??
                                                                'Sin url',
                                                            style: TextStyle(
                                                                color: Colors.white))),
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
                                                textItem(
                                                    'Nombre',
                                                    txtNameFact,
                                                    1,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                textItem(
                                                    'Descripción',
                                                    txtDescFact,
                                                    5,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                textItem(
                                                    'Pais',
                                                    txtLocacionFact,
                                                    1,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                textItem(
                                                    'RFC',
                                                    txtRFCFact,
                                                    1,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
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
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Numero de telefono',
                                                      labelStyle: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide: BorderSide(
                                                          width: 1.5,
                                                          color: Colors.amber,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
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
                                                    'Tipo de empresa',
                                                    txtRubroFact,
                                                    2,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                textItem(
                                                    'URL',
                                                    txtUrlFact,
                                                    3,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        70),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ValueListenableBuilder(
                                                  valueListenable:
                                                      documentUpload,
                                                  builder:
                                                      (context, value, child) {
                                                    if (value) {
                                                      linkDoc =
                                                          archivo!.path;
                                                      return Text(
                                                        'Archivo subido: ${linkDoc.split('/').last}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      );
                                                    } else {
                                                      return Column(
                                                        children: [
                                                          Text(
                                                              'Sube tu constancia de situación fiscal',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              FilePickerResult?
                                                                  result =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                type: FileType
                                                                    .custom,
                                                                allowedExtensions: [
                                                                  'pdf',
                                                                ],
                                                              );
                                                              if (result !=
                                                                  null) {
                                                                archivo = File(
                                                                    result
                                                                        .files
                                                                        .single
                                                                        .path!);

                                                                await uploadDocument(
                                                                        File(archivo!
                                                                            .path),
                                                                        txtRFCFact
                                                                            .text)
                                                                    .then(
                                                                        (value) {
                                                                  if (value!
                                                                      .isNotEmpty) {
                                                                    documentUpload
                                                                            .value =
                                                                        true;
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Archivo subido correctamente')));
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Error al subir el archivo')));
                                                                  }
                                                                });
                                                                // Llamar a la función para subir el archivo aquí
                                                              }
                                                            },
                                                            child: Text(
                                                                'Seleccionar archivo'),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        }
                                      })
                                  : Column(
                                      children: [
                                        textItem(
                                            'nombre',
                                            txtNameFact,
                                            1,
                                            MediaQuery.of(context).size.width -
                                                70),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem(
                                            'descripcion',
                                            txtDescFact,
                                            5,
                                            MediaQuery.of(context).size.width -
                                                70),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            textItem(
                                                'Pais',
                                                txtLocacionFact,
                                                1,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70),
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
                                                    FirebaseAuth.instance
                                                        .currentUser!.email!),
                                                child: Text(
                                                    FirebaseAuth.instance
                                                        .currentUser!.email!,
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
                                            textItem(
                                                'RFC',
                                                txtRFCFact,
                                                1,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70),
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
                                            textItem(
                                                'Telefono',
                                                txtTelFact,
                                                1,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70),
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
                                                'Tipo de empresa',
                                                txtRubroFact,
                                                2,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70),
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
                                            textItem(
                                                'Url',
                                                txtUrlFact,
                                                2,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70),
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
                        ],
                      ),
                    ]),
                tablet:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
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
                                            ? CachedNetworkImage(
                                                imageUrl: FirebaseAuth.instance
                                                    .currentUser!.photoURL!,
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
                          button(MediaQuery.of(context).size.width / 3),
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
                    ],
                  ),
                  SizedBox(
                    width: 30,
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
                                  txtDescFact.text =
                                      snapshot.data!.docs[0].get('descripción');
                                  txtLocacionFact.text =
                                      snapshot.data!.docs[0].get('pais');
                                  txtRFCFact.text =
                                      snapshot.data!.docs[0].get('rfc');
                                  txtTelFact.text = snapshot.data!.docs[0]
                                      .get('telefono')
                                      .toString();
                                  txtRubroFact.text = snapshot.data!.docs[0]
                                      .get('tipo_empresa');
                                  txtUrlFact.text =
                                      snapshot.data!.docs[0].get('url');
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      textItem(
                                          'Nombre',
                                          txtNameFact,
                                          1,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textItem(
                                          'Descripción',
                                          txtDescFact,
                                          5,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textItem(
                                          'Pais',
                                          txtLocacionFact,
                                          1,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textItem(
                                          'RFC',
                                          txtRFCFact,
                                          1,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
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
                                          'Tipo de empresa',
                                          txtRubroFact,
                                          2,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      textItem(
                                          'URL',
                                          txtUrlFact,
                                          3,
                                          MediaQuery.of(context).size.width /
                                              2),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                } else {
                                  if (snapshot.data!.size > 0) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                onPressed: () => _launchCaller(
                                                    snapshot.data!.docs[0]
                                                            .get('telefono') ??
                                                        'Sin nombre'),
                                                child: Text(
                                                    snapshot.data!.docs[0]
                                                            .get('telefono') ??
                                                        'Sin telefono',
                                                    style: TextStyle(
                                                        color: Colors.white))),
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
                                                snapshot.data!.docs[0]
                                                        .get('tipo_empresa') ??
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
                                                    _launchInBrowser(Uri.parse(
                                                        snapshot.data!.docs[0]
                                                                .get('url') ??
                                                            'Sin url')),
                                                child: Text(
                                                    snapshot.data!.docs[0]
                                                            .get('url') ??
                                                        'Sin url',
                                                    style: TextStyle(
                                                        color: Colors.white))),
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
                                        textItem(
                                            'Nombre',
                                            txtNameFact,
                                            1,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem(
                                            'Descripción',
                                            txtDescFact,
                                            5,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem(
                                            'Pais',
                                            txtLocacionFact,
                                            1,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem(
                                            'RFC',
                                            txtRFCFact,
                                            1,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
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
                                            'Tipo de empresa',
                                            txtRubroFact,
                                            2,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        textItem(
                                            'URL',
                                            txtUrlFact,
                                            3,
                                            MediaQuery.of(context).size.width /
                                                2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: documentUpload,
                                          builder: (context, value, child) {
                                            if (value) {
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 60,
                                                  child: Text(
                                                      'Archivo subido: ${archivo!.path.split('/').last}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center));
                                            } else {
                                              return Column(
                                                children: [
                                                  Text(
                                                      'Sube tu constancia de situación fiscal',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf',
                                                        ],
                                                      );
                                                      if (result != null) {
                                                        archivo = File(result
                                                            .files
                                                            .single
                                                            .path!);
                                                        await uploadDocument(
                                                                File(archivo!
                                                                    .path),
                                                                txtRFCFact.text)
                                                            .then((value) {
                                                          if (value!
                                                              .isNotEmpty) {
                                                            documentUpload
                                                                .value = true;
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Archivo subido correctamente')));
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Error al subir el archivo')));
                                                          }
                                                        });
                                                        // Llamar a la función para subir el archivo aquí
                                                      }
                                                    },
                                                    child: Text(
                                                        'Seleccionar archivo'),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  }
                                }
                              })
                          : Column(
                              children: [
                                textItem('nombre', txtNameFact, 1,
                                    MediaQuery.of(context).size.width / 2),
                                SizedBox(
                                  height: 10,
                                ),
                                textItem('descripcion', txtDescFact, 5,
                                    MediaQuery.of(context).size.width / 2),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    textItem('Pais', txtLocacionFact, 1,
                                        MediaQuery.of(context).size.width / 2),
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
                                            FirebaseAuth
                                                .instance.currentUser!.email!),
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
                                    textItem('RFC', txtRFCFact, 1,
                                        MediaQuery.of(context).size.width / 2),
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
                                    textItem('Telefono', txtTelFact, 1,
                                        MediaQuery.of(context).size.width / 2),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    textItem('Tipo de empresa', txtRubroFact, 2,
                                        MediaQuery.of(context).size.width / 2),
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
                                    textItem('Url', txtUrlFact, 2,
                                        MediaQuery.of(context).size.width / 2),
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
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.grey[700],
          onPressed: () async {
            if (nuevo) {
              if (_formKey.currentState!.validate() && documentUpload.value) {
                if (image.value != null) {
                  final uploaded = await uploadImage(File(image.value!.path));
                  await FirebaseAuth.instance.currentUser
                      ?.updateDisplayName(txtNameFact.text);
                  _firebase.insEmpresa({
                    'correo': FirebaseAuth.instance.currentUser!.email,
                    'nombre': txtNameFact.text,
                    'descripción': txtDescFact.text,
                    'pais': txtLocacionFact.text,
                    'rfc': txtRFCFact.text,
                    'telefono': txtTelFact.text,
                    'tipo_empresa': txtRubroFact.text,
                    'url': txtUrlFact.text,
                    'urlpdf': linkDoc.path,
                  });
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
                  _firebase.insEmpresa({
                    'correo': FirebaseAuth.instance.currentUser!.email,
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
            } else {
              if (image.value != null) {
                final uploaded = await uploadImage(File(image.value!.path));
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(txtNameFact.text);
                _firebase.updEmpresa({
                  'nombre': txtNameFact.text,
                  'descripción': txtDescFact.text,
                  'pais': txtLocacionFact.text,
                  'rfc': txtRFCFact.text,
                  'telefono': txtTelFact.text,
                  'tipo_empresa': txtRubroFact.text,
                  'url': txtUrlFact.text,
                });
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

  Widget button(double ancho) {
    return InkWell(
      onTap: () async {
        image.value = await _picker.pickImage(source: ImageSource.gallery);
      },
      child: Container(
        height: 40,
        width: ancho,
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
