import 'dart:convert';

import 'package:egp_app/config.dart';
import 'package:egp_app/install/loofup.dart';
import 'package:egp_app/install/signatureroof.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String sign_name_1 = '';
  String path_sign1 = '';
  String sign_name_2 = '';
  String path_sign2 = '';
  String sign_name_3 = '';
  String path_sign3 = '';

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

  void loading() {
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
                  child: Lottie.asset('assets/logoloading.json', height: 80)),
            ),
          );
        });
  }

  // getRoofDetailById(id, pro, imgType) async {
  //   var response = await http.post(
  //     Uri.parse('$api/api/mobile/getRoofDetailById'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
  //     },
  //     body: jsonEncode(
  //         <dynamic, dynamic>{'jidx': id, 'problem': pro, 'imgType': imgType}),
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     print(jsonResponse);
  //     return jsonResponse;
  //   }
  // }

  chooseProblem(id, pro) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/chooseProblem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': id,
        'problem': pro,
        'userName': widget.userName
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
      setState(() {
        problem = val['j_roof_install_problem'];
        problemLs = val['roof_problem'];
        if (val['signature_roof_controller'].isNotEmpty) {
          sign_name_1 = val['signature_roof_controller'][0]['sign_name'];
          path_sign1 =
              val['signature_roof_controller'][0]['j_img_roof_install_image'];
        }
        if (val['signature_roof_tech'].isNotEmpty) {
          sign_name_2 = val['signature_roof_tech'][0]['sign_name'];
          path_sign2 =
              val['signature_roof_tech'][0]['j_img_roof_install_image'];
        }
        if (val['signature_roof_coordinator'].isNotEmpty) {
          sign_name_3 = val['signature_roof_coordinator'][0]['sign_name'];
          path_sign3 =
              val['signature_roof_coordinator'][0]['j_img_roof_install_image'];
        }
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
                      onTap: (widget.status == 3)
                          ? null
                          : () {
                              loading();
                              chooseProblem(widget.jidx, false).then((v) {
                                getRoofDetail(widget.jidx).then((val) {
                                  setState(() {
                                    problem = val['j_roof_install_problem'];
                                    problemLs = val['roof_problem'];
                                    if (val['signature_roof_controller']
                                        .isNotEmpty) {
                                      sign_name_1 =
                                          val['signature_roof_controller'][0]
                                              ['sign_name'];
                                      path_sign1 =
                                          val['signature_roof_controller'][0]
                                              ['j_img_roof_install_image'];
                                    }
                                    if (val['signature_roof_tech'].isNotEmpty) {
                                      sign_name_2 = val['signature_roof_tech']
                                          [0]['sign_name'];
                                      path_sign2 = val['signature_roof_tech'][0]
                                          ['j_img_roof_install_image'];
                                    }
                                    if (val['signature_roof_coordinator']
                                        .isNotEmpty) {
                                      sign_name_3 =
                                          val['signature_roof_coordinator'][0]
                                              ['sign_name'];
                                      path_sign3 =
                                          val['signature_roof_coordinator'][0]
                                              ['j_img_roof_install_image'];
                                    }
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                });
                              });
                              // setState(() {
                              //   problem = false;
                              // });
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
                      onTap: (widget.status == 3)
                          ? null
                          : () {
                              loading();
                              chooseProblem(widget.jidx, true).then((v) {
                                getRoofDetail(widget.jidx).then((val) {
                                  setState(() {
                                    problem = val['j_roof_install_problem'];
                                    problemLs = val['roof_problem'];
                                    if (val['signature_roof_controller']
                                        .isNotEmpty) {
                                      sign_name_1 =
                                          val['signature_roof_controller'][0]
                                              ['sign_name'];
                                      path_sign1 =
                                          val['signature_roof_controller'][0]
                                              ['j_img_roof_install_image'];
                                    }
                                    if (val['signature_roof_tech'].isNotEmpty) {
                                      sign_name_2 = val['signature_roof_tech']
                                          [0]['sign_name'];
                                      path_sign2 = val['signature_roof_tech'][0]
                                          ['j_img_roof_install_image'];
                                    }
                                    if (val['signature_roof_coordinator']
                                        .isNotEmpty) {
                                      sign_name_3 =
                                          val['signature_roof_coordinator'][0]
                                              ['sign_name'];
                                      path_sign3 =
                                          val['signature_roof_coordinator'][0]
                                              ['j_img_roof_install_image'];
                                    }
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                });
                              });
                              // setState(() {
                              //   problem = true;
                              // });
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
                    ? (widget.status == 3)
                        ? SizedBox(
                            height: 20,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => roofup(
                                              status: widget.status,
                                              problemId: null,
                                              jidx: widget.jidx,
                                              userName: widget.userName,
                                            ))).then((value) {
                                  getRoofDetail(widget.jidx).then((val) {
                                    setState(() {
                                      problem = val['j_roof_install_problem'];
                                      problemLs = val['roof_problem'];
                                      if (val['signature_roof_controller']
                                          .isNotEmpty) {
                                        sign_name_1 =
                                            val['signature_roof_controller'][0]
                                                ['sign_name'];
                                        path_sign1 =
                                            val['signature_roof_controller'][0]
                                                ['j_img_roof_install_image'];
                                      }
                                      if (val['signature_roof_tech']
                                          .isNotEmpty) {
                                        sign_name_2 = val['signature_roof_tech']
                                            [0]['sign_name'];
                                        path_sign2 = val['signature_roof_tech']
                                            [0]['j_img_roof_install_image'];
                                      }
                                      if (val['signature_roof_coordinator']
                                          .isNotEmpty) {
                                        sign_name_3 =
                                            val['signature_roof_coordinator'][0]
                                                ['sign_name'];
                                        path_sign3 =
                                            val['signature_roof_coordinator'][0]
                                                ['j_img_roof_install_image'];
                                      }
                                      isLoading = false;
                                    });
                                  });
                                });
                              },
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 0.5, color: Color(0xff9DC75B))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
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
                    ? (isLoading == false)
                        ? ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: problemLs.length,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: ((context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => roofup(
                                                    status: widget.status,
                                                    problemId: problemLs[index][
                                                        'j_img_roof_install_problem'],
                                                    jidx: widget.jidx,
                                                    userName: widget.userName,
                                                  ))).then((value) {
                                        getRoofDetail(widget.jidx).then((val) {
                                          setState(() {
                                            problem =
                                                val['j_roof_install_problem'];
                                            problemLs = val['roof_problem'];
                                            if (val['signature_roof_controller']
                                                .isNotEmpty) {
                                              sign_name_1 =
                                                  val['signature_roof_controller']
                                                      [0]['sign_name'];
                                              path_sign1 = val[
                                                      'signature_roof_controller']
                                                  [
                                                  0]['j_img_roof_install_image'];
                                            }
                                            if (val['signature_roof_tech']
                                                .isNotEmpty) {
                                              sign_name_2 =
                                                  val['signature_roof_tech'][0]
                                                      ['sign_name'];
                                              path_sign2 = val[
                                                      'signature_roof_tech'][0]
                                                  ['j_img_roof_install_image'];
                                            }
                                            if (val['signature_roof_coordinator']
                                                .isNotEmpty) {
                                              sign_name_3 =
                                                  val['signature_roof_coordinator']
                                                      [0]['sign_name'];
                                              path_sign3 = val[
                                                      'signature_roof_coordinator']
                                                  [
                                                  0]['j_img_roof_install_image'];
                                            }
                                            isLoading = false;
                                          });
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 70,
                                      decoration: (problemLs[index][
                                                  'j_img_roof_install_problem_status'] ==
                                              true)
                                          ? BoxDecoration(
                                              color: Color(0xff9DC75B),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            )
                                          : BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Color(0xff9DC75B))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${problemLs[index]['j_img_roof_install_problem']}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: (problemLs[index][
                                                                'j_img_roof_install_problem_status'] ==
                                                            true)
                                                        ? Colors.white
                                                        : Color(0xff9DC75B))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            }))
                        : ListView.builder(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Color(0xff9DC75B))),
                                    ),
                                  ));
                            }))
                    : SizedBox(
                        height: 20,
                      ),
                //
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Text('ลายเซ็นต์',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xff2A302C))),
                ),
                GestureDetector(
                    onTap: () async {
                      (sign_name_1.isNotEmpty)
                          ? popsign(path_sign1)
                          : (widget.status == 3)
                              ? null
                              : sheet('วิศวกรคุมงาน', 3);
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (sign_name_1.isNotEmpty)
                            ? Color(0xff9DC75B)
                            : Color(0xffEEF5E2),
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Color(0xffE0ECDE)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: (sign_name_1.isNotEmpty)
                                    ? Colors.white
                                    : Color(0xff9CC75B),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(EvaIcons.peopleOutline,
                                    size: 20,
                                    color: (sign_name_1.isNotEmpty)
                                        ? Color(0xff9CC75B)
                                        : Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'วิศวกรคุมงาน',
                                  style: TextStyle(
                                      color: (sign_name_1.isNotEmpty)
                                          ? Colors.white
                                          : Color(0xffAED76E),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                (sign_name_1.isNotEmpty)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          sign_name_1,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () async {
                      // loading();
                      // await getsign1(widget.jid, date);
                      // await getsign2(widget.jid, date);
                      // await getsign3(widget.jid, date);
                      // await getOGsign1(widget.jid);
                      // await getOGsign2(widget.jid);

                      // Navigator.pop(context);

                      (sign_name_2.isNotEmpty)
                          ? popsign(path_sign2)
                          : (widget.status == 3)
                              ? null
                              : sheet('หัวหน้าช่าง', 2);
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (sign_name_2.isNotEmpty)
                            ? Color(0xff9DC75B)
                            : Color(0xffEEF5E2),
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Color(0xffE0ECDE)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: (sign_name_2.isNotEmpty)
                                    ? Colors.white
                                    : Color(0xff9CC75B),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(EvaIcons.peopleOutline,
                                    size: 20,
                                    color: (sign_name_2.isNotEmpty)
                                        ? Color(0xff9CC75B)
                                        : Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'หัวหน้าช่าง',
                                  style: TextStyle(
                                      color: (sign_name_2.isNotEmpty)
                                          ? Colors.white
                                          : Color(0xffAED76E),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                (sign_name_2.isNotEmpty)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          sign_name_2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () async {
                      // loading();
                      // await getsign1(widget.jid, date);
                      // await getsign2(widget.jid, date);
                      // await getsign3(widget.jid, date);
                      // await getOGsign1(widget.jid);
                      // await getOGsign2(widget.jid);

                      // Navigator.pop(context);

                      (sign_name_3.isNotEmpty)
                          ? popsign(path_sign3)
                          : (widget.status == 3)
                              ? null
                              : sheet('ผู้ประสานงาน', 4);
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (sign_name_3.isNotEmpty)
                            ? Color(0xff9DC75B)
                            : Color(0xffEEF5E2),
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: Color(0xffE0ECDE)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: (sign_name_3.isNotEmpty)
                                    ? Colors.white
                                    : Color(0xff9CC75B),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(EvaIcons.peopleOutline,
                                    size: 20,
                                    color: (sign_name_3.isNotEmpty)
                                        ? Color(0xff9CC75B)
                                        : Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ผู้ประสานงาน',
                                  style: TextStyle(
                                      color: (sign_name_3.isNotEmpty)
                                          ? Colors.white
                                          : Color(0xffAED76E),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                (sign_name_3.isNotEmpty)
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          sign_name_3,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
  }

  void sheet(title, type) {
    var putname = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 10),
                        child: Row(
                          children: [
                            Text(title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Color(0xffAED76E))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffAED76E)),
                        ),
                        child: TextField(
                          onTapOutside: (b) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: putname,
                          // textInputAction: TextInputAction.done,

                          decoration: InputDecoration(
                            hintText: 'ชื่อ-นามสกุล',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (putname.text.isEmpty) {
                                pop('กรุณากรอกชื่อ-นามสกุล');
                              } else {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signatureroof(
                                            jidx: widget.jidx,
                                            imgType: type,
                                            signName: putname.text,
                                            user: widget.userName,
                                          )),
                                ).then((value) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                  ]);
                                  getRoofDetail(widget.jidx).then((val) {
                                    setState(() {
                                      problem = val['j_roof_install_problem'];
                                      problemLs = val['roof_problem'];
                                      if (val['signature_roof_controller']
                                          .isNotEmpty) {
                                        sign_name_1 =
                                            val['signature_roof_controller'][0]
                                                ['sign_name'];
                                        path_sign1 =
                                            val['signature_roof_controller'][0]
                                                ['j_img_roof_install_image'];
                                      }
                                      if (val['signature_roof_tech']
                                          .isNotEmpty) {
                                        sign_name_2 = val['signature_roof_tech']
                                            [0]['sign_name'];
                                        path_sign2 = val['signature_roof_tech']
                                            [0]['j_img_roof_install_image'];
                                      }
                                      if (val['signature_roof_coordinator']
                                          .isNotEmpty) {
                                        sign_name_3 =
                                            val['signature_roof_coordinator'][0]
                                                ['sign_name'];
                                        path_sign3 =
                                            val['signature_roof_coordinator'][0]
                                                ['j_img_roof_install_image'];
                                      }
                                      isLoading = false;
                                    });
                                  });
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.white,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  pop(title) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return (defaultTargetPlatform == TargetPlatform.android)
              ? AlertDialog(
                  actionsPadding: EdgeInsets.all(5),
                  // title: Text(
                  //     'ต้องการลบข้อมูลหรือไม่'),
                  contentPadding: EdgeInsets.only(top: 30, bottom: 20),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); //close Dialog
                      },
                      child: Text('ตกลง'),
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  content: Text(title),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); //close Dialog
                      },
                      child: Text('ตกลง'),
                    ),
                  ],
                );
        });
  }

  void popsign(path) {
    showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
              child: Center(
            child: Image.network('$api/${path}'),
          )),
        );
      },
    );
  }
}
