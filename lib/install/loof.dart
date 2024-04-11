import 'dart:convert';

import 'package:egp_app/config.dart';
import 'package:egp_app/install/loofup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class roof extends StatefulWidget {
  @override
  _roofState createState() => _roofState();
  final int jidx;
  final int status;
  final String userName;
  roof({required this.status, required this.userName, required this.jidx});
}

class _roofState extends State<roof> {
  bool isLoading = true;
  bool problem = false;
  List problemLs = [];

  getRoofDetail(id) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/getRoofDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': id,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoofDetail(widget.jidx).then((val) {
      print(val);
      setState(() {
        problem = val['j_roof_install_problem'];
        problemLs = val['roof_problem'];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Lottie.asset('assets/logoloading.json', height: 90),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              toolbarHeight:
                  (defaultTargetPlatform == TargetPlatform.android) ? 120 : 100,
              backgroundColor: Color(0xffF8FFF6),
              automaticallyImplyLeading: false,
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
                            Text('ดำเนินงาน',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff2A302C))),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                                //
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'สำรวจและส่งมอบหลังคา',
                                      style: TextStyle(
                                          color: Color(0xff9DC75B),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )),
                          Container(
                            height: 15,
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
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              children: [
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          problem = false;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              (problem == false)
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: Color(0xff9DC75B),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'ไม่ต้องแก้ไข',
                                style: TextStyle(
                                    color: Color(0xff2A302C),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          problem = true;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              (problem == true)
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: Color(0xff9DC75B),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'ต้องแก้ไข',
                                style: TextStyle(
                                    color: Color(0xff2A302C),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
                (problem == true)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        roofup(status: widget.status)));
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 0.5, color: Color(0xff9DC75B))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('เพิ่มปัญหา',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xff2A302C))),
                                    Icon(
                                      Icons.add,
                                      color: Color(0xff9DC75B),
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                (problem == true)
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: 3,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: ((context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[200]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 0.5,
                                          color: Color(0xff9DC75B))),
                                ),
                              ));
                        }))
                    : Container()
              ],
            ),
          );
  }
}
