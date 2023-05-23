import 'package:concentric_transition/concentric_transition.dart';
import 'package:firebase_app_web/Service/Auth_Service.dart';
import 'package:firebase_app_web/pages/HomePage.dart';
import 'package:firebase_app_web/pages/SignUpPage.dart';
import 'package:firebase_app_web/screens/presentacion_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final AuthClass authClass = AuthClass();

  final ValueNotifier<Widget> currentPage = ValueNotifier<Widget>(SignUpPage());
  final data = [
    CardData(
        title: "Juntemos Mundos",
        subtitle: "Aplicación para unir a empresas de todo el mundo",
        backgraundColor: const Color.fromARGB(255, 28, 28, 28),
        titleColor: Colors.pink,
        subtitleColor: Colors.white,
        icono: const Icon(Icons.next_plan, size: 80, color: Colors.pink,),
        backgraund: Lottie.asset('assets/espacio.json')),
    CardData(
        title: "¿Como utilizarla?",
        subtitle:
            "Esta app te ayudara a buscar empresas y proyectos para poder invertir en ellos.",
        backgraundColor: const Color.fromARGB(255, 21, 21, 58),
        titleColor: Colors.green,
        subtitleColor: Colors.white,
        icono: const Icon(Icons.next_plan, size: 80, color: Colors.green,),
        backgraund: Lottie.asset('assets/tierra.json')),
    CardData(
        title: "Inversiones",
        subtitle:
            "Has seguimiento de todas tus inversiones.",
        backgraundColor: const Color.fromARGB(255, 28, 28, 28),
        titleColor: Colors.white,
        subtitleColor: Colors.blue,
        icono: const Icon(Icons.next_plan, size: 80, color: Colors.white,),
        backgraund: Lottie.asset('assets/espacio.json')),
    CardData(
        title: "!Tip!",
        subtitle:
            "Inicia sesión con google y manten tu sesión abierta.",
        backgraundColor: const Color.fromARGB(255, 21, 21, 58),
        titleColor: Colors.cyan,
        subtitleColor: Colors.blue,
        icono: const Icon(Icons.input, size: 80,
              color: Colors.cyan),
        backgraund: Lottie.asset('assets/tierra.json')),
  ];

  @override
  Widget build(BuildContext context) {
    checkLogin();
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgraundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return CardApi(data: data[index]);
        },
        onFinish: () {Navigator.push(context, MaterialPageRoute(builder: (context) => 
          ValueListenableBuilder(
            valueListenable: currentPage,
            builder: (context, value, child) {
              return  value;
            },
          )));
        },
      ),
    );
    
  }

  checkLogin() async {
    String? tokne = await authClass.getToken();
    print(tokne);
    if (tokne != null){
        currentPage.value = HomePage();
    }
  }
}
