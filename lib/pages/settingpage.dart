import 'dart:convert';

import 'package:egp_app/login.dart';
import 'package:egp_app/pages/changepass.dart';
import 'package:egp_app/pages/editprofile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  var messaging = FirebaseMessaging.instance;
  bool isLoading = true;
  String userName = "Loading...";
  int? iduser;
  String tech_fullname = '';
  String tech_position = '';
  String tech_company = '';
  String tech_tel = '';
  String tech_line = '';
  String tech_email = '';

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    if (prefs.getString('user') != null) {
      setState(() {
        userName = prefs.getString('user')!;
        iduser = prefs.getInt('id')!;
      });
    }
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.clear();
  }

  signOut(id, user, token) async {
    var response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/mobileLogout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'techId': id,
        'userName': user,
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == true) {
        Navigator.pop(context);
        logOut().then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => login()),
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

  Future getUserDetail(userId) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/master/getTechnicianLs'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'techId': userId,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        setState(() {
          tech_fullname = jsonResponse[0]['tech_fullname'];
          tech_position = jsonResponse[0]['tech_position'];
          tech_company = jsonResponse[0]['tech_company'];
          tech_tel = jsonResponse[0]['tech_tel'];
          tech_line = jsonResponse[0]['tech_line'];
          tech_email = jsonResponse[0]['tech_email'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser().then((value) {
      getUserDetail(iduser).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff149C32),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'ตั้งค่า',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xff149C32),
          leading: IconButton(
              splashRadius: 15,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff149C32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editprofile(
                                    id: iduser,
                                    fullname: tech_fullname,
                                    companame: tech_company,
                                    email: tech_email,
                                    line: tech_line,
                                    position: tech_position,
                                    tel: tech_tel,
                                  )),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff101F57).withOpacity(0.2),
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: (isLoading == true)
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.person_alt_circle,
                                              size: 70,
                                              color: Color(0xff149C32)
                                                  .withOpacity(0.5),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 15,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 20,
                                        color: Color(0xff149C32),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.person_alt_circle,
                                          size: 70,
                                          color: Color(0xff149C32)
                                              .withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tech_fullname,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff003175)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'แก้ไขโปรไฟล์',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff003175)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                      color: Color(0xff149C32),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   tech_fullname,
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   'ตำแหน่ง : $tech_position',
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white),
                    // ),
                    // Text(
                    //   'บริษัท : $tech_company',
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white),
                    // ),
                    // Text(
                    //   'email : $tech_email',
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'ตั้งค่า',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff003175)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => changepass(id: iduser)),
                            );
                          },
                          child: Container(
                            height: 40,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.padlock,
                                      color: Color(0xff464646),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'รหัสผ่าน',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff464646)),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xff149C32),
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('ok');
                          },
                          child: Container(
                            height: 40,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.phone,
                                      color: Color(0xff464646),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ช่วยเหลือ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff464646)),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xff149C32),
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
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

                            messaging.getToken().then((value) {
                              signOut(iduser, userName, value);
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'ออกจากระบบ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff149C32)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
// IconButton(
//             onPressed: () {
//               messaging.getToken().then((value) {
//                 print(value);
//                 Clipboard.setData(ClipboardData(text: value));
//               });
//             },
//             icon: Icon(Icons.copy)),


 