import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();

  final int? id;
  final String fullname;
  final String email;
  final String tel;
  final String line;
  final String position;
  final String companame;
  final String userName;
  editprofile(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.tel,
      required this.line,
      required this.position,
      required this.companame,
      required this.userName});
}

class _editprofileState extends State<editprofile> {
  var fullname = TextEditingController();
  var email = TextEditingController();
  var tel = TextEditingController();
  var line = TextEditingController();
  var position = TextEditingController();
  var companame = TextEditingController();

  updateProfile() async {
    List _body = [
      {
        'techId': widget.id,
        'userName': widget.userName,
        'fullName': fullname.text,
        'email': email.text,
        'tel': tel.text,
        'line': line.text,
        'position': position.text,
        'company': companame.text,
        'activeFlag': 0
      }
    ];

    var response = await http.post(
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/master/updateTechnician'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: json.encode(_body));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fullname.text = widget.fullname;
      email.text = widget.email;
      tel.text = widget.tel;
      line.text = widget.line;
      position.text = widget.position;
      companame.text = widget.companame;
    });
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
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Padding(
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
                      size: 20,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text('แก้ไขโปรไฟล์',
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
                      loading();
                      updateProfile().then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // elevation: 0,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.person_alt_circle,
                    size: 130,
                    color: Color(0xff57A946).withOpacity(0.5),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                ' ชื่อ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: fullname,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' นามสกุล',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: fullname,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Phone number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: tel,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Line ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: line,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' ตำแหน่ง',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: position,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' ชื่อบริษัท',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: companame,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: Color(0xffD6EFB4),
          width: 0.5,
        ));
  }
}
