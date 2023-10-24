import 'dart:convert';

import 'package:egp_app/login.dart';
import 'package:egp_app/pages/changepass.dart';
import 'package:egp_app/pages/editprofile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  String tech_fname = '';
  String tech_lname = '';
  String tech_position = '';
  String tech_company = '';
  String tech_tel = '';
  String tech_line = '';
  String tech_email = '';
  String pic = '';

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
        print(jsonResponse);
        setState(() {
          tech_fname = jsonResponse[0]['tech_fname'] ?? '';
          tech_lname = jsonResponse[0]['tech_lname'] ?? '';

          tech_position = jsonResponse[0]['tech_position'];
          tech_company = jsonResponse[0]['tech_company'];
          tech_tel = jsonResponse[0]['tech_tel'];
          tech_line = jsonResponse[0]['tech_line'];
          tech_email = jsonResponse[0]['tech_email'];
          pic = jsonResponse[0]['tech_profile'];
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight:
              (defaultTargetPlatform == TargetPlatform.android) ? 230 : 210,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffF8FFF6),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xffF8FFF6),
              image: DecorationImage(
                image: AssetImage("assets/head.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.only(
                  top: (defaultTargetPlatform == TargetPlatform.android)
                      ? 20
                      : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xff57A946),
                              size: 25,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text('ตั้งค่า',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xff2A302C))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'โปรไฟล์',
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff57A946)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        (isLoading == true)
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[200]!,
                                highlightColor: Colors.grey[50]!,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            EvaIcons.peopleOutline,
                                            size: 70,
                                            color: Color(0xff57A946)
                                                .withOpacity(0.5),
                                          ),
                                          SizedBox(
                                            width: 20,
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
                                                    height: 20,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Color(0xffE1F5DC),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xff149C32)
                                                    .withOpacity(0.15),
                                                blurRadius: 10)
                                          ]),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: (pic.isEmpty)
                                            ? Icon(
                                                EvaIcons.peopleOutline,
                                                size: 70,
                                                color: Color(0xff57A946)
                                                    .withOpacity(0.5),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    'https://backoffice.energygreenplus.co.th/$pic'),
                                              ),
                                      ),
                                      // Icon(
                                      //   CupertinoEvaIcons.peopleOutline_alt_circle,
                                      //   size: 70,
                                      //   color: Color(0xff57A946).withOpacity(0.5),
                                      // ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$tech_fname $tech_lname',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff57A946)),
                                          ),
                                          Text(
                                            'แก้ไขโปรไฟล์',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff2A302C)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => editprofile(
                                                  id: iduser,
                                                  fname: tech_fname,
                                                  lname: tech_lname,
                                                  companame: tech_company,
                                                  email: tech_email,
                                                  line: tech_line,
                                                  position: tech_position,
                                                  tel: tech_tel,
                                                  userName: userName,
                                                  pic: pic,
                                                )),
                                      ).then((value) {
                                        setState(() {
                                          getUserDetail(iduser);
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Color(0xffE1F5DC),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xff149C32)
                                                    .withOpacity(0.15),
                                                blurRadius: 10)
                                          ]),
                                      child: Center(
                                        child: Icon(
                                          EvaIcons.edit,
                                          color: Color(0xff9DC75B),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                        ),
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(0, -3), // Shadow position
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 30, left: 30, right: 30),
                  child: SizedBox(
                    height: 50,
                    // width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return (defaultTargetPlatform ==
                                      TargetPlatform.android)
                                  ? AlertDialog(
                                      actionsPadding: EdgeInsets.all(5),
                                      // title: Text(
                                      //     'ต้องการลบข้อมูลหรือไม่'),
                                      contentPadding:
                                          EdgeInsets.only(top: 30, bottom: 20),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('ต้องการออกจากระบบหรือไม่'),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //close Dialog
                                          },
                                          child: Text('ยกเลิก'),
                                        ),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.red, // Text Color
                                            ),
                                            onPressed: () {
                                              messaging
                                                  .getToken()
                                                  .then((value) {
                                                signOut(
                                                    iduser, userName, value);
                                              });
                                            },
                                            child: Text('ออกจากระบบ')),
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      content: Text('ต้องการออกจากระบบหรือไม่'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //close Dialog
                                          },
                                          child: Text('ยกเลิก'),
                                        ),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.red, // Text Color
                                            ),
                                            onPressed: () {
                                              messaging
                                                  .getToken()
                                                  .then((value) {
                                                signOut(
                                                    iduser, userName, value);
                                              });
                                            },
                                            child: Text('ออกจากระบบ')),
                                      ],
                                    );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Color(0xff9DC75B)),
                        elevation: 0,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff9DC75B)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            children: [
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
                    children: [
                      Icon(
                        EvaIcons.edit2,
                        color: Color(0xff9DC75B),
                        size: 25,
                      ),
                      // Image.asset('assets/edit-2.svg'),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'รหัสผ่าน',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff464646)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color(0xffD6EFB4),
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
                    children: [
                      Icon(
                        EvaIcons.pricetags,
                        color: Color(0xff9DC75B),
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'ช่วยเหลือ',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff464646)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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


 