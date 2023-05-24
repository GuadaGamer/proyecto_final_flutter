import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static StreamController<String> _messageStreamController = new
      StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _bacgraundHandler(RemoteMessage message) async{
    //print('onbackgraund Handler ${ message.messageId}');

    String argumento = 'no-data';
    if (Platform.isAndroid){
      argumento = message.data['documento'];
    }

    _messageStreamController.add( argumento );
  }

  static Future _onMessageHandler(RemoteMessage message) async{
    //print('onMessage Handler ${ message.messageId}');

    //print( message.data );

    String argumento = 'no-data';
    if (Platform.isAndroid){
      argumento = message.data['documento'];
    }

    _messageStreamController.add( argumento );
  }

  static Future _onOpenMessageOpenApp(RemoteMessage message) async{
    // print('onOpenMessageOpenApp Handler ${ message.messageId}');

    String argumento = 'no-data';
    if (Platform.isAndroid){
      argumento = message.data['documento'];
    }

    _messageStreamController.add( argumento );
  }

  static Future initNotifications() async {
    await Firebase.initializeApp();
    token = await messaging.getToken();
    //print(token);
    //eTGGdHEcTg-SGqnG75ep-8:APA91bEl-NCxl2eiXFOcsQQeNEqSCd4A8xabT4Jy4O2Pm1qolrxG4IzhVqAv2F0R1ySuOPnazuZVjubtTXTasub_hzRtRucy0EW2YDS_XKfnTr_jR_-GaPJLFPPbWJi7tW100GV2t1et

    //handlers
    FirebaseMessaging.onBackgroundMessage( _bacgraundHandler );
    FirebaseMessaging.onMessage.listen( _onMessageHandler );
    FirebaseMessaging.onMessageOpenedApp.listen( _onOpenMessageOpenApp );
    
  }

  closeStrings() {
    _messageStreamController.close();
  }
}
