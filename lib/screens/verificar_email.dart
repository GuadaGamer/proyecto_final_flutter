import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  User? user;
  Timer? _timer;
  int _start = 30;
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void resendEmailVerification() {
    user?.sendEmailVerification();
    setState(() {
      _start = 30;
      _isEmailSent = true;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificación de Correo Electrónico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Por favor, verifica tu correo electrónico!',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            _isEmailSent
                ? Text(
                    'Se ha enviado un correo de verificación a ${user!.email}.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                : Container(),
            SizedBox(height: 10),
            Text(
              'Vuelve a enviar en $_start segundos',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 10),
            FirebaseAuth.instance.currentUser!.emailVerified ?
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                    Color(0xfffd746c),
                    )),
              child: Text('Entrar'),
              onPressed:() => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => HomePage()),
                      (route) => false),
            ):
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                    Color(0xfffd746c),
                    )),
              child: Text('Reenviar Correo de Verificación'),
              onPressed: _start == 0 ? resendEmailVerification : null,
            ),
          ],
        ),
      ),
    );
  }
}
