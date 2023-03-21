import 'package:egp_app/clean/cleansolar.dart';
import 'package:egp_app/home.dart';
import 'package:egp_app/login.dart';
import 'package:egp_app/pages/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'General', // id
  'General', // title/ description
  importance: Importance.max,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //create noti chanel
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  messaging.getToken().then((value) {
    print('key is $value');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification!.body);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogin = prefs.getString('user');

  runApp(MyApp(
    isLogin: isLogin,
  ));
}

class MyApp extends StatelessWidget {
  final isLogin;
  MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'EGP',
        theme: ThemeData(
          fontFamily: 'BaiJamjuree',
          primarySwatch: Colors.blue,
        ),
        home: (isLogin != null) ? homePage() : login(),
        // homePage(),
      ),
    );
  }
}
