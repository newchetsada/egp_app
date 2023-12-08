import 'package:egp_app/clean/cleansolar.dart';
import 'package:egp_app/home.dart';
import 'package:egp_app/login.dart';
import 'package:egp_app/pages/homepage.dart';
import 'package:egp_app/up.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

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

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    // cache refresh time
    fetchTimeout: const Duration(seconds: 1),
    // a fetch will wait up to 10 seconds before timing out
    minimumFetchInterval: const Duration(seconds: 10),
  ));
  await remoteConfig.fetchAndActivate();
  print(remoteConfig.getInt('android'));
  print(remoteConfig.getInt('ios'));
  bool up = false;
  if (defaultTargetPlatform == TargetPlatform.android) {
    if (remoteConfig.getInt('android') > 100) {
      print('ver android update');
      up = true;
    }
  } else {
    if (remoteConfig.getInt('ios') > 100) {
      print('ver ios update');
      up = true;
    }
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogin = prefs.getString('user');

  runApp(MyApp(
    isLogin: isLogin,
    isUp: up,
  ));
}

class MyApp extends StatelessWidget {
  final isLogin;
  final isUp;
  MyApp({super.key, required this.isLogin, required this.isUp});

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
          fontFamily: 'Noto Sans Thai',
          primarySwatch: Colors.blue,
        ),
        home: (isUp == true)
            ? updatePage()
            : (isLogin != null)
                ? homePage()
                : login(),
        // homePage(),
      ),
    );
  }
}
