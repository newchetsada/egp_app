import 'dart:convert';

import 'package:egp_app/pages/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:egp_app/config.dart';

class login extends StatefulWidget {
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  var messaging = FirebaseMessaging.instance;

  var user = TextEditingController();
  var pass = TextEditingController();

  bool _obscureText = true;

  addSession(use, id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', use);
    print(use);
    prefs.setInt('id', id);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo_egp_green.png',
                  height: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Hello!',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff464646)),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: user,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Color(0xffAED76E)),
                      focusColor: Color(0xffAED76E),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAED76E)),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pass,
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xffAED76E)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffAED76E)),
                      ),
                      suffixIconColor: Colors.grey[300],
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: IconButton(
                            splashRadius: 15,
                            iconSize: 20,
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            }),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAED76E),
                        fixedSize: Size(90, 35),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          messaging.getToken().then((value) {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) {
                                  return Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Center(
                                          child: Lottie.asset(
                                              'assets/logoloading.json',
                                              height: 80)),
                                    ),
                                  );
                                });
                            signIn(user.text, pass.text, value);
                          });
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Color(0xff2A302C)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn(user, pass, token) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/mobileLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'userLogin': user,
        'pass': pass,
        'token': token,
        'tokenFlag': (defaultTargetPlatform == TargetPlatform.android) ? 0 : 1
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == true) {
        Navigator.pop(context);
        addSession(user, jsonResponse['id']).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePage()),
              (route) => false);
        });
      } else {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
