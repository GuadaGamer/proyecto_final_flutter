import 'package:firebase_app_web/Service/publicaciones_firebasa.dart';
import 'package:firebase_app_web/providers/islogin_provider.dart';
import 'package:firebase_app_web/screens/proyect_screen.dart';
import 'package:firebase_app_web/widgets/item_publicacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProyectos extends StatefulWidget {
  const ListProyectos({super.key});

  @override
  State<ListProyectos> createState() => _ListProyectosState();
}

class _ListProyectosState extends State<ListProyectos> {
  ProyectosFirebase _firebase = ProyectosFirebase();

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);

    flag.getflagListPost();

    return Scaffold(
      body: StreamBuilder(
        stream: _firebase.getAllProyecto(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10), 
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProyectScreen(id: snapshot.data!.docs[index].id)));
                  },
                  child: ItemProyectos(
                    nombre: snapshot.data!.docs[index].get('nombre'),
                    url: snapshot.data!.docs[index].get('imagen'),
                    totalAcumulado: snapshot.data!.docs[index].get('total_recaudado'),
                    totalRequerido: snapshot.data!.docs[index].get('total_requerido')),
                );
              });
          }else if( snapshot.hasError){
            return const Center(
              child: const Text('Ocurrio un error'),
            );
          }else{
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}