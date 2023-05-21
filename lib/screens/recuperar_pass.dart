import 'package:firebase_app_web/Service/Auth_Service.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthClass auth = AuthClass();

  @override
  Widget build(BuildContext context) {
    Widget textItem(
        String labeltext, TextEditingController controller, bool obscureText) {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
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
        title: Text('Recuperación de Contraseña'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese su correo electrónico para recibir instrucciones de restablecimiento de contraseña:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            textItem('Correo Electrónico', _emailController, false),
            SizedBox(height: 10),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Color(0xfffd746c),
                    Color(0xffff9068),
                    Color(0xfffd746c)
                  ]),
                ),
                child: Center(
                    child: Text(
                  "Enviar correo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )),
              ),
              onTap: () {
                String email = _emailController.text;
                auth.enviarCorreoRestablecimiento(email).then((value) =>
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value))));
              },
            ),
          ],
        ),
      ),
    );
  }
}
