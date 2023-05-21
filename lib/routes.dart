import 'package:firebase_app_web/main.dart';
import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:firebase_app_web/screens/add_proyecto_screen.dart';
import 'package:firebase_app_web/screens/empresaproyect.dart';
import 'package:firebase_app_web/screens/inversiones_screen.dart';
import 'package:firebase_app_web/screens/proyect_screen.dart';
import 'package:firebase_app_web/screens/themeSelectror_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
      '/home':(BuildContext context) => HomePage(),
      '/add': (BuildContext context) => AddProyectScreen(),
      '/publish': (BuildContext context) => ListProyectosEmpresa(),
      '/investment': (BuildContext context) => InversionesScreen(),
      '/theme': (BuildContext context) => const ThemeSelectorScreen(),
      '/item': (BuildContext context) => ProyectScreen(),
  };
}