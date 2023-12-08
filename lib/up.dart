import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class updatePage extends StatefulWidget {
  _updatePageState createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/logo_egp_green.png',
              height: 150,
            ),
            // Icon(
            //   CupertinoIcons.wifi_exclamationmark,
            //   size: 150,
            //   color: Color(0xff818181),
            // ),
            SizedBox(
              height: 30,
            ),
            Text(
              'อัพเดทเวอร์ชั่น',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff9DC75B),
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'กรุณาอัพเดทเวอร์ชั่น EGP+ ของท่าน\nเพื่อเพิ่มประสิทธิภาพการใช้งาน',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xff818181),
                  fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xff9DC75B)),
                child: ElevatedButton(
                  onPressed: () async {
                    var url = 'https://energygreenplus.co.th/';

                    final remoteConfig = FirebaseRemoteConfig.instance;
                    await remoteConfig.setConfigSettings(RemoteConfigSettings(
                      // cache refresh time
                      fetchTimeout: const Duration(seconds: 1),
                      // a fetch will wait up to 10 seconds before timing out
                      minimumFetchInterval: const Duration(seconds: 10),
                    ));
                    await remoteConfig.fetchAndActivate();
                    if (defaultTargetPlatform == TargetPlatform.android) {
                      url = remoteConfig.getString('playstore');
                    } else {
                      url = remoteConfig.getString('appstore');
                    }
                    launch(url);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'อัพเดท',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
