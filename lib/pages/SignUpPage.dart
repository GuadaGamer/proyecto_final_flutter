import 'package:firebase_app_web/Service/Auth_Service.dart';
import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:firebase_app_web/pages/SignInPage.dart';
import 'package:firebase_app_web/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  AuthClass authClass = AuthClass();
  ValueNotifier<bool> circular = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registrar cuenta",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                textItem("Correo", _emailController, false, MediaQuery.of(context).size.width - 70),
                SizedBox(
                  height: 15,
                ),
                textItem("Contraseña", _pwdController, true, MediaQuery.of(context).size.width - 70),
                SizedBox(
                  height: 40,
                ),
                colorButton(MediaQuery.of(context).size.width - 100),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Ó",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 18,
                ),
                buttonItem("assets/google.svg", "Continuar con Google", 25,
                    () async {
                  await authClass.googleSignIn(context);
                }, MediaQuery.of(context).size.width - 60),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes una cuenta? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignInPage()),
                            (route) => false);
                      },
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        desktop: Text(''),
        tablet: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Registrar cuenta",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    textItem("Correo", _emailController, false, MediaQuery.of(context).size.width / 2),
                    SizedBox(
                      height: 15,
                    ),
                    textItem("Contraseña", _pwdController, true, MediaQuery.of(context).size.width / 2),
                    SizedBox(
                      height: 40,
                    ),
                    colorButton( MediaQuery.of(context).size.width /2),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ó",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonItem("assets/google.svg", "Continuar con Google", 25,
                        () async {
                      await authClass.googleSignIn(context);
                    }, MediaQuery.of(context).size.width / 3),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Ya tienes una cuenta? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => SignInPage()),
                                (route) => false);
                          },
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton(double ancho) {
    return InkWell(
      onTap: () async {
        circular.value = true;
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text, password: _pwdController.text);
          print(userCredential.user!.email);
          userCredential.user!.sendEmailVerification();
          circular.value = false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          circular.value = false;
        }
      },
      child: Container(
        width: ancho,
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
          child: ValueListenableBuilder(
              valueListenable: circular,
              builder: (context, value, child) {
                if (value) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, Function() onTap, double ancho) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: ancho,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText, double ancho) {
    return Container(
      width: ancho,
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
}
