import 'package:firebase_app_web/providers/push_notificatios_proiveder.dart';
import 'package:firebase_app_web/providers/theme_provider.dart';
import 'package:firebase_app_web/routes.dart';
import 'package:firebase_app_web/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/islogin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationProvider.initNotifications();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final idThema = sharedPreferences.getInt('id_tema') ?? 2;
  runApp(MyApp(idtema: idThema));
}

class MyApp extends StatefulWidget {
  final int idtema;
  const MyApp({super.key, required this.idtema});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    PushNotificationProvider.messagesStream.listen((message) {
      _navigatorKey.currentState?.pushNamed('/item',arguments: message);
      //print(message);
     });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(widget.idtema, context)),
        ChangeNotifierProvider(create: (_) => FlagsProvider()),
      ],
      child: Inicio(navigatorKey: _navigatorKey),);
  }

}

class Inicio extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  Inicio({super.key, required this.navigatorKey});
  
  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: getApplicationRoutes(),
      theme: theme.getthemeData(),
      home: OnboardingScreen(),
    );
  }
}