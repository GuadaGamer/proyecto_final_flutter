import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_web/Service/Auth_Service.dart';
import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_app_web/main.dart';
import 'package:firebase_app_web/providers/islogin_provider.dart';
import 'package:firebase_app_web/screens/list_proyectos.dart';
import 'package:firebase_app_web/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

ValueNotifier<bool> imageChange = ValueNotifier<bool>(false);

class _HomePageState extends State<HomePage> {
  bool isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModeEnabled();
  }

  Future<void> _loadDarkModeEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeEnabled = prefs.getBool('is_dark') ?? false;
  }

  AuthClass authClass = AuthClass();
  File? imagen;

  @override
  Widget build(BuildContext context) {
    FlagsProvider flag = Provider.of<FlagsProvider>(context);
    EmpresasFirebase _firebaseEmpresa = EmpresasFirebase();

    flag.getflagListPost();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authClass.signOut(context: context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => MyApp(idtema: 2)),
                    (route) => false);
              }),
        ],
      ),
      body: ListProyectos(),
      drawer: Drawer(
          child: ListView(
        children: [
          ValueListenableBuilder(
              valueListenable: imageChange,
              builder: (context, value, child) {
                return UserAccountsDrawerHeader(
                    currentAccountPicture: ClipRRect(
                      child: FirebaseAuth.instance.currentUser!.photoURL == null
                          ? Image.asset('assets/profile.png')
                          : FirebaseAuth.instance.currentUser!.photoURL!
                                      .contains('firebasestorage') ==
                                  true
                              ? CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  placeholder: ((context, url) =>
                                      Image.asset('assets/loading.gif')),
                                  imageUrl: FirebaseAuth
                                      .instance.currentUser!.photoURL!,
                                )
                              : Image.asset('assets/profile.png'),
                    ),
                    accountName: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(FirebaseAuth.instance.currentUser!.email!),
                          Icon(
                            Icons.mail_outline_outlined,
                            color: Colors.white,
                          )
                        ]),
                    accountEmail: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(FirebaseAuth.instance.currentUser!.displayName ??
                              'Sin nombre'),
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          )
                        ]));
              }),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          id: FirebaseAuth.instance.currentUser!.email!)));
            },
            iconColor: Colors.grey,
            textColor: Colors.grey,
            title: const Text('Perfil empresarial'),
            subtitle: const Text('Revisa tu perfil aqui'),
            leading: const Icon(Icons.account_box),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/publish');
            },
            iconColor: Colors.grey,
            textColor: Colors.grey,
            title: const Text('Mis proyectos'),
            subtitle: const Text('Ve aqui tus proyectos'),
            leading: const Icon(Icons.my_library_books),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/favorit');
            },
            iconColor: Colors.grey,
            textColor: Colors.grey,
            title: const Text('Mis favoritos'),
            subtitle: const Text('Ve aqui tus favoritos'),
            leading: const Icon(Icons.favorite),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/investment');
            },
            iconColor: Colors.grey,
            textColor: Colors.grey,
            title: const Text('Mis inversiones'),
            subtitle: const Text('Ve aqui mis inversiones'),
            leading: const Icon(Icons.auto_graph),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
            iconColor: Colors.grey,
            textColor: Colors.grey,
            title: const Text('Configuracion'),
            subtitle: const Text('Configura el color de tema'),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool documentoExiste = await _firebaseEmpresa.existeDocumento();
          if (documentoExiste) {
            Navigator.pushNamed(context, '/add').then((value) {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Aun no creas tu empresa, accede a tu perfil')));
          }
        },
        backgroundColor: Colors.green[800],
        label: const Text('Añadir proyecto'),
        icon: const Icon(Icons.note_add),
      ),
    );
  }
}
