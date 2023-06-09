import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/providers/islogin_provider.dart';
import 'package:firebase_app_web/responsive.dart';
import 'package:firebase_app_web/screens/proyect_screen_edit.dart';
import 'package:firebase_app_web/widgets/item_publicacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProyectosEmpresa extends StatefulWidget {
  const ListProyectosEmpresa({super.key});

  @override
  State<ListProyectosEmpresa> createState() => _ListProyectosEmpresaState();
}

class _ListProyectosEmpresaState extends State<ListProyectosEmpresa> {
  ProyectosFirebase _firebase = ProyectosFirebase();
  EmpresasFirebase _firebaseEmpresa = EmpresasFirebase();

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);

    flag.getflagListPost();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis proyectos'),
      ),
      body: FutureBuilder<List<String>>(
        future: _firebaseEmpresa.getDocumentReferences(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length <= 0) {
              return Center(
                  child: Text(
                'No hay proyectos en facoritos',
                style: TextStyle(color: Colors.white),
              ));
            }
            List<String> docIDs = snapshot.data!;
            return Responsive(
              desktop: Text(''),
              mobile: GridView.builder(
                padding: const EdgeInsets.all(7),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: _firebase.getOneProyecto(docIDs[index]),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          final querySnapshot = streamSnapshot.data!.docs[0];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProyectScreenEdit(
                                          id: docIDs[index])));
                            },
                            child: Stack(
                              children: [
                                ItemProyectos(
                                    nombre: querySnapshot['nombre'],
                                    url: querySnapshot['imagen'],
                                    totalAcumulado:
                                        querySnapshot['total_recaudado'],
                                    totalRequerido:
                                        querySnapshot['total_requerido']),
                                Positioned(
                                  top: 5,
                                  right: 10,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Confirmar borrado'),
                                              content: const Text(
                                                  'Deseas borrar el proyecto?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await _firebaseEmpresa
                                                          .updArrayEmpresa(
                                                              docIDs[index]);
                                                      _firebase.delProyecto(
                                                          docIDs[index]);
                                                      flag.setflagListPost();
                                                      Navigator.pushNamed(
                                                          context, '/publish');
                                                    },
                                                    child: const Text('Si')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No'))
                                              ]),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 50,
                                      )),
                                )
                              ],
                            ),
                          );
                        } else if (streamSnapshot.hasError) {
                          return const Center(
                            child: const Text('Ocurrio un error'),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                },
              ),
              tablet: GridView.builder(
                padding: const EdgeInsets.all(7),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: _firebase.getOneProyecto(docIDs[index]),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          final querySnapshot = streamSnapshot.data!.docs[0];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProyectScreenEdit(
                                          id: docIDs[index])));
                            },
                            child: Stack(
                              children: [
                                ItemProyectos(
                                    nombre: querySnapshot['nombre'],
                                    url: querySnapshot['imagen'],
                                    totalAcumulado:
                                        querySnapshot['total_recaudado'],
                                    totalRequerido:
                                        querySnapshot['total_requerido']),
                                Positioned(
                                  top: 5,
                                  right: 10,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Confirmar borrado'),
                                              content: const Text(
                                                  'Deseas borrar el proyecto?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await _firebaseEmpresa
                                                          .updArrayEmpresa(
                                                              docIDs[index]);
                                                      _firebase.delProyecto(
                                                          docIDs[index]);
                                                      flag.setflagListPost();
                                                      Navigator.pushNamed(
                                                          context, '/publish');
                                                    },
                                                    child: const Text('Si')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No'))
                                              ]),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 50,
                                      )),
                                )
                              ],
                            ),
                          );
                        } else if (streamSnapshot.hasError) {
                          return const Center(
                            child: const Text('Ocurrio un error'),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                },
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
    );
  }
}
