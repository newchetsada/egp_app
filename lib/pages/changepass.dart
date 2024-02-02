import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:egp_app/config.dart';

class changepass extends StatefulWidget {
  @override
  _changepassState createState() => _changepassState();

  final int? id;
  changepass({
    required this.id,
  });
}

class _changepassState extends State<changepass> {
  final _formKey = GlobalKey<FormState>();
  var old = TextEditingController();
  var newpass = TextEditingController();
  var newagain = TextEditingController();

  changePass() async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/changePass'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'techId': widget.id,
        'passOld': old.text,
        'passNew': newagain.text,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  void loading() {
    showDialog(
        barrierDismissible: false,
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
                  child: Lottie.asset('assets/logoloading.json', height: 80)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight:
            (defaultTargetPlatform == TargetPlatform.android) ? 70 : 50,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top:
                    (defaultTargetPlatform == TargetPlatform.android) ? 20 : 0),
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
                Text('เปลี่ยนรหัสผ่าน',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // height: 30,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 30, left: 30, right: 30),
                child: SizedBox(
                  height: 50,
                  // width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loading();
                        changePass().then((res) {
                          Navigator.pop(context);
                          if (res['status'] == true) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(res['message']),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffAED76E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2A302C)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  ' กรอกรหัสผ่านเดิม',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9DC75B),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onTapOutside: (b) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: old,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกข้อมูล';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder(),
                    errorBorder: myinputborder(),
                    focusedErrorBorder: myinputborder(),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  ' กรอกรหัสผ่านใหม่',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9DC75B),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onTapOutside: (b) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: newpass,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกข้อมูล';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder(),
                    errorBorder: myinputborder(),
                    focusedErrorBorder: myinputborder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' กรอกรหัสผ่านใหม่อีกครั้ง',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9DC75B),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onTapOutside: (b) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: newagain,
                  validator: (value) {
                    if (value != newpass.text) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder(),
                    errorBorder: myinputborder(),
                    focusedErrorBorder: myinputborder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color(0xffD6EFB4),
          width: 0.5,
        ));
  }
}
