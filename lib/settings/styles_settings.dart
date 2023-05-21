import 'package:flutter/material.dart';

class StylesSettings {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255,0, 191, 165)));
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255, 0, 96, 100))
            );
  }

  static ThemeData personalTheme(BuildContext context){
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(primary: Color.fromARGB(255,0, 77, 64)),
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[800]),
      fontFamily: 'Manope'
    );
  }
}