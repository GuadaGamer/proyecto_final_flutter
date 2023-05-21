import 'package:firebase_app_web/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un tema'),
      ),
      body: Stack(
        children: [
          buildMobileLayout(theme, context),
        ],
      ),
    );
  }

  Widget buildMobileLayout(ThemeProvider theme, BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Seleccione un tema',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                theme.setthemeData(0, context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromRGBO(17, 117, 51, 1),
                foregroundColor: const Color.fromRGBO(17, 117, 51, 1), shape: const StadiumBorder(),
                side: const BorderSide(width: 2, color: Color.fromRGBO(17, 117, 51, 1)),
              ),
              child: const Text(
                'Tema claro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                theme.setthemeData(2, context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromRGBO(27, 57, 106, 1),
                foregroundColor: const Color.fromRGBO(27, 57, 106, 1), shape: const StadiumBorder(),
                side: const BorderSide(width: 2, color: Color.fromRGBO(27, 57, 106, 1)),
              ),
              child: const Text(
                'Tema personalizado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                theme.setthemeData(1, context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                foregroundColor: const Color.fromRGBO(0, 0, 0, 1), shape: const StadiumBorder(),
                side: const BorderSide(width: 2, color: Colors.white),
              ),
              child: const Text('Tema oscuro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(17, 117, 51, 1), shape: const StadiumBorder(),
                      side: const BorderSide(width: 2, color: Color.fromRGBO(17, 117, 51, 1)),
                      backgroundColor: const Color.fromRGBO(17, 117, 51, 1),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      theme.setthemeData(0, context);
                      Navigator.pushNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 0, 0), shape: const StadiumBorder(),
                      side: const BorderSide(width: 2, color: Color.fromARGB(255, 255, 0, 0)),
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    ),
                    child: const Text('Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}