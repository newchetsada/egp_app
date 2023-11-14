import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:egp_app/audit/acaudit.dart';
import 'package:egp_app/audit/addinverter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class addaudit extends StatefulWidget {
  @override
  _addauditState createState() => _addauditState();

  final int jidx;
  final int typeId;
  final String typeName;
  final int status;
  final int? choice;
  final int? sid;

  addaudit(
      {required this.jidx,
      required this.typeId,
      required this.typeName,
      required this.status,
      required this.choice,
      required this.sid});
}

class _addauditState extends State<addaudit> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  var groupSub = <SubLs>[];
  String pathPic = 'https://backoffice.energygreenplus.co.th/';
  var remark = TextEditingController();
  List deleteLs = [];
  int? pass;

  String userName = "Loading...";
  int? iduser;
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

  // deletePic(id) async {
  //   var response = await http.post(
  //     Uri.parse(
  //         'https://backoffice.energygreenplus.co.th/api/mobile/deleteImageChecklist'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
  //     },
  //     body: jsonEncode(<dynamic, dynamic>{
  //       'jidx': widget.jidx,
  //       'jImgCheckId': id,
  //       'typeId': widget.typeId,
  //       'userName': userName,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     print(jsonResponse);
  //     return jsonResponse;
  //   }
  // }

  // deleteGroup(groupNo) async {
  //   var response = await http.post(
  //     Uri.parse(
  //         'https://backoffice.energygreenplus.co.th/api/mobile/deleteJobGroupImageAudit'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
  //     },
  //     body: jsonEncode(<dynamic, dynamic>{
  //       'jidx': widget.jidx,
  //       'groupNo': groupNo,
  //       'typeId': widget.typeId,
  //       'userName': userName,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     print(jsonResponse);
  //     return jsonResponse;
  //   }
  // }

  // addgroup() async {
  //   var response = await http.post(
  //     Uri.parse(
  //         'https://backoffice.energygreenplus.co.th/api/mobile/addGroupAudit'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
  //     },
  //     body: jsonEncode(<dynamic, dynamic>{
  //       'jidx': widget.jidx,
  //       'typeId': widget.typeId,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     print(jsonResponse);
  //     return jsonResponse;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getUser();
    print(widget.typeId);
    API.getSubLs(widget.sid, widget.jidx, widget.typeId).then((response) {
      setState(() {
        List list = json.decode(response.body);
        print(list);
        groupSub = list.map((m) => SubLs.fromJson(m)).toList();
        // contactloading = false;
      });
    });
  }

  // Widget addcard() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
  //     child: GestureDetector(
  //       onTap: () {
  //         loading();
  //         addgroup().then((value) {
  //           Navigator.pop(context);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => (widget.typeId == 31)
  //                       ? acaudit(
  //                           jidx: widget.jidx,
  //                           typeId: widget.typeId,
  //                           typeName: widget.typeName,
  //                           status: widget.status,
  //                           group: value['newGroupNo'])
  //                       : addinverter(
  //                           jidx: widget.jidx,
  //                           typeId: widget.typeId,
  //                           typeName: widget.typeName,
  //                           status: widget.status,
  //                           group: value['newGroupNo']))).then((value) {
  //             API
  //                 .getSubLs(widget.sid, widget.jidx, widget.typeId)
  //                 .then((response) {
  //               setState(() {
  //                 List list = json.decode(response.body);
  //                 print(list);
  //                 groupSub = list.map((m) => SubLs.fromJson(m)).toList();
  //                 // contactloading = false;
  //               });
  //             });
  //           });
  //         });
  //       },
  //       child: Container(
  //         height: 60,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               Color(0xffE1F5DC),
  //               Color(0xffD6EFB4),
  //             ],
  //           ),
  //           borderRadius: BorderRadius.circular(15),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color(0xff149C32).withOpacity(0.1),
  //               blurRadius: 10,
  //               spreadRadius: 0,
  //               offset: Offset(0, 0), // Shadow position
  //             ),
  //           ],
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(widget.typeName,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 17,
  //                       color: Color(0xff2A302C))),
  //               Icon(
  //                 EvaIcons.plusCircle,
  //                 color: Colors.white,
  //                 size: 30,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: (widget.status == 3)
            ? null
            : Container(
                // height: 30,
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
                            bottom: 30, left: 30, right: 30),
                        child: SizedBox(
                          height: 50,
                          // width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                    ),
                  ],
                ),
              ),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight:
              (defaultTargetPlatform == TargetPlatform.android) ? 90 : 70,
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
                        Expanded(
                          child: Text(widget.typeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xff2A302C))),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      // (widget.status == 3)
                      //     ?
                      Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            //
                          )),
                      // : Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(25),
                      //           topRight: Radius.circular(25)),
                      //       //
                      //     ),
                      //     child: addcard(),
                      //   ),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,

                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.white,
                          //     blurRadius: 5,
                          //     spreadRadius: 5,
                          //     offset: Offset(0, 10), // Shadow position
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: groupSub.length,
                  padding: EdgeInsets.only(bottom: 20),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child:
                              //  (widget.status == 3)
                              //     ?
                              GestureDetector(
                                  onTap: () {
                                    // loading();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => (widget
                                                        .typeId ==
                                                    32)
                                                ? addinverter(
                                                    jidx: widget.jidx,
                                                    typeId: widget.typeId,
                                                    typeName: widget.typeName,
                                                    status: widget.status,
                                                    group: 0,
                                                    no: index + 1,
                                                    sn: groupSub[index].sn,
                                                    sin:
                                                        groupSub[index].sins_id,
                                                    model:
                                                        groupSub[index].model,
                                                  )
                                                : acaudit(
                                                    jidx: widget.jidx,
                                                    typeId: widget.typeId,
                                                    typeName: widget.typeName,
                                                    status: widget.status,
                                                    group: 0,
                                                    sin:
                                                        groupSub[index].sins_id,
                                                    sn: groupSub[index].sn,
                                                    model:
                                                        groupSub[index].model,
                                                  ))).then((value) {
                                      API
                                          .getSubLs(widget.sid, widget.jidx,
                                              widget.typeId)
                                          .then((response) {
                                        setState(() {
                                          List list =
                                              json.decode(response.body);
                                          print(list);
                                          groupSub = list
                                              .map((m) => SubLs.fromJson(m))
                                              .toList();
                                          // contactloading = false;
                                        });
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color(0xff9DC75B), width: 0.5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (widget.typeId == 32)
                                                      ? 'Inverter ${index + 1}'
                                                      : (widget.typeId == 30)
                                                          ? 'ตู้แผงไฟฟ้า AC ${index + 1}'
                                                          : (widget.typeId ==
                                                                  37)
                                                              ? 'ตู้แผงไฟฟ้า DC ${index + 1}'
                                                              : '${widget.typeName} ${index + 1}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0xff9DC75B),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                                (widget.typeId == 32 ||
                                                        widget.typeId == 37 ||
                                                        widget.typeId == 29 ||
                                                        widget.typeId == 31 ||
                                                        widget.typeId == 30 ||
                                                        widget.typeId == 40)
                                                    ? (groupSub[index]
                                                            .model
                                                            .isNotEmpty)
                                                        ? Text(
                                                            groupSub[index]
                                                                .model,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff57A946),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          )
                                                        : Container()
                                                    : Container(),
                                                (widget.typeId == 32 ||
                                                        widget.typeId == 37 ||
                                                        widget.typeId == 29 ||
                                                        widget.typeId == 31 ||
                                                        widget.typeId == 30 ||
                                                        widget.typeId == 40)
                                                    ? (groupSub[index]
                                                            .sn
                                                            .isNotEmpty)
                                                        ? Text(
                                                            groupSub[index].sn,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff57A946),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          )
                                                        : Container()
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            EvaIcons.checkmarkCircle2,
                                            size: 30,
                                            color: (groupSub[index]
                                                        .amount_true ==
                                                    groupSub[index].amount_all)
                                                ? Color(0xffABD06F)
                                                : Color.fromARGB(
                                                    255, 211, 211, 211),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                          // : Slidable(
                          //     endActionPane: ActionPane(
                          //       extentRatio: 0.2,
                          //       motion: BehindMotion(),
                          //       children: [
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         SlidableAction(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(15)),
                          //           onPressed: ((context) {
                          //             // print(group);
                          //             showDialog(
                          //                 barrierDismissible: false,
                          //                 context: context,
                          //                 builder: (context) {
                          //                   return (defaultTargetPlatform ==
                          //                           TargetPlatform.android)
                          //                       ? AlertDialog(
                          //                           actionsPadding:
                          //                               EdgeInsets.all(5),
                          //                           // title: Text(
                          //                           //     'ต้องการลบข้อมูลหรือไม่'),
                          //                           contentPadding:
                          //                               EdgeInsets.only(
                          //                                   top: 30,
                          //                                   bottom: 20),
                          //                           content: Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .center,
                          //                             children: [
                          //                               Text(
                          //                                   'ต้องการลบข้อมูลหรือไม่'),
                          //                             ],
                          //                           ),
                          //                           actions: <Widget>[
                          //                             TextButton(
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context); //close Dialog
                          //                               },
                          //                               child: Text('ยกเลิก'),
                          //                             ),
                          //                             TextButton(
                          //                                 style: TextButton
                          //                                     .styleFrom(
                          //                                   primary: Colors
                          //                                       .red, // Text Color
                          //                                 ),
                          //                                 onPressed: () {
                          //                                   deleteGroup(groupSub[
                          //                                               index]
                          //                                           .group_no)
                          //                                       .then((val) {
                          //                                     Navigator.pop(
                          //                                         context);
                          //                                   });
                          //                                 },
                          //                                 child: Text('ลบ')),
                          //                           ],
                          //                         )
                          //                       : CupertinoAlertDialog(
                          //                           content: Text(
                          //                               'ต้องการลบข้อมูลหรือไม่'),
                          //                           actions: <Widget>[
                          //                             TextButton(
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context); //close Dialog
                          //                               },
                          //                               child: Text('ยกเลิก'),
                          //                             ),
                          //                             TextButton(
                          //                                 style: TextButton
                          //                                     .styleFrom(
                          //                                   primary: Colors
                          //                                       .red, // Text Color
                          //                                 ),
                          //                                 onPressed: () {
                          //                                   deleteGroup(groupSub[
                          //                                               index]
                          //                                           .group_no)
                          //                                       .then((val) {
                          //                                     Navigator.pop(
                          //                                         context);
                          //                                   });
                          //                                 },
                          //                                 child: Text('ลบ')),
                          //                           ],
                          //                         );
                          //                 }).then((value) {
                          //               API
                          //                   .getSubLs(widget.sid, widget.jidx,
                          //                       widget.typeId)
                          //                   .then((response) {
                          //                 setState(() {
                          //                   List list =
                          //                       json.decode(response.body);
                          //                   print(list);
                          //                   groupSub = list
                          //                       .map((m) => SubLs.fromJson(m))
                          //                       .toList();
                          //                   // contactloading = false;
                          //                 });
                          //               });
                          //             });
                          //           }),
                          //           backgroundColor: Colors.red,
                          //           foregroundColor: Colors.white,
                          //           icon: Icons.delete,
                          //           label: 'ลบ',
                          //         ),
                          //       ],
                          //     ),
                          //     child: GestureDetector(
                          //         onTap: () {
                          //           // loading();
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => (widget
                          //                               .typeId ==
                          //                           31)
                          //                       ? acaudit(
                          //                           jidx: widget.jidx,
                          //                           typeId: widget.typeId,
                          //                           typeName: widget.typeName,
                          //                           status: widget.status,
                          //                           group: groupSub[index]
                          //                               .group_no)
                          //                       : addinverter(
                          //                           jidx: widget.jidx,
                          //                           typeId: widget.typeId,
                          //                           typeName: widget.typeName,
                          //                           status: widget.status,
                          //                           group: groupSub[index]
                          //                               .group_no))).then(
                          //               (value) {
                          //             API
                          //                 .getSubLs(widget.sid, widget.jidx,
                          //                     widget.typeId)
                          //                 .then((response) {
                          //               setState(() {
                          //                 List list =
                          //                     json.decode(response.body);
                          //                 print(list);
                          //                 groupSub = list
                          //                     .map((m) => SubLs.fromJson(m))
                          //                     .toList();
                          //                 // contactloading = false;
                          //               });
                          //             });
                          //           });
                          //         },
                          //         child: Container(
                          //           height: 60,
                          //           width: double.infinity,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(15),
                          //             border: Border.all(
                          //                 color: Color(0xff9DC75B),
                          //                 width: 0.5),
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 20),
                          //             child: Row(
                          //               children: [
                          //                 Expanded(
                          //                   child: Text(
                          //                     '${widget.typeName} ${index + 1}',
                          //                     overflow: TextOverflow.ellipsis,
                          //                     style: TextStyle(
                          //                         color: Color(0xff9DC75B),
                          //                         fontWeight: FontWeight.w600,
                          //                         fontSize: 15),
                          //                   ),
                          //                 ),
                          //                 Icon(
                          //                   EvaIcons.checkmarkCircle2,
                          //                   size: 30,
                          //                   color: (groupSub[index].type_id ==
                          //                           32)
                          //                       ? (groupSub[index]
                          //                                   .status_sub80 ==
                          //                               true)
                          //                           ? Color(0xffABD06F)
                          //                           : Color.fromARGB(
                          //                               255, 211, 211, 211)
                          //                       : (groupSub[index]
                          //                                   .amount_true ==
                          //                               groupSub[index]
                          //                                   .amount_all)
                          //                           ? Color(0xffABD06F)
                          //                           : Color.fromARGB(
                          //                               255, 211, 211, 211),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         )),
                          //   ),
                          ),
                    );
                  })),
            ),
          ],
        ));
  }
}

//api
class API {
  static Future getSubLs(idd, jidx, typeId) async {
    final response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getAccessoriesAudit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(
          <dynamic, dynamic>{'sid': idd, 'jidx': jidx, 'typeId': typeId}),
    );
    return response;
  }
}

class SubLs {
  final int sins_id;
  final int sid;
  final String brand;
  final String model;
  final double? size;
  final String sn;
  final int acc_type;
  final String acc_type_name;
  final int? amount;
  final String eletric_type;
  final int? amount_string;
  final int? amount_true;
  final int? amount_all;

  const SubLs(
      {required this.sins_id,
      required this.sid,
      required this.brand,
      required this.model,
      required this.size,
      required this.sn,
      required this.acc_type,
      required this.acc_type_name,
      required this.amount,
      required this.eletric_type,
      required this.amount_string,
      required this.amount_true,
      required this.amount_all});

  factory SubLs.fromJson(Map<String, dynamic> json) {
    return SubLs(
      sins_id: json['sins_id'],
      sid: json['sid'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      size: json['size'],
      sn: json['sn'] ?? '',
      acc_type: json['acc_type'],
      acc_type_name: json['acc_type_name'] ?? '',
      amount: json['amount'],
      eletric_type: json['eletric_type'] ?? '',
      amount_string: json['amount_string'],
      amount_true: json['amount_true'],
      amount_all: json['amount_all'],
    );
  }
}
