import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  var messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Center(
        child: IconButton(
            onPressed: () {
              messaging.getToken().then((value) {
                print(value);
                Clipboard.setData(ClipboardData(text: value));
              });
            },
            icon: Icon(Icons.copy)),
      ),
    );
  }
}
