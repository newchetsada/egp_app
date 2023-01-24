import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class recentPage extends StatefulWidget {
  @override
  _recentPageState createState() => _recentPageState();
}

class _recentPageState extends State<recentPage> {
  // bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink,
      body: Center(
        child: Lottie.asset('assets/logoloading.json'),
      ),
    );
  }
}
