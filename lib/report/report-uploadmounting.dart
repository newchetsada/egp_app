import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:egp_app/config.dart';

class ReportuploadPicMounting extends StatefulWidget {
  @override
  _ReportuploadPicMountingState createState() =>
      _ReportuploadPicMountingState();

  final int jidx;
  final int type_id;
  final int sid;
  final int? ref_jidx_repair;
  final int cusId;
  final String username;
  ReportuploadPicMounting(
      {required this.jidx,
      required this.type_id,
      required this.sid,
      required this.ref_jidx_repair,
      required this.cusId,
      required this.username});
}

class _ReportuploadPicMountingState extends State<ReportuploadPicMounting> {
  final ImagePicker imgpicker = ImagePicker();
  String typeName = '';
  var groupLs = <Group>[];
  var desLs_before = <Descript>[];
  var desLs_after = <Descript>[];

  bool nothavedevice = false;
  bool nothavedevice_f = false;
  String detail = '';
  String hint = '';
  String? _selectedValue;
  String gg = '';
  var before_note = TextEditingController();
  var after_note = TextEditingController();

  List deleteLs = [];

  String userName = "Loading...";
  int? iduser;
  bool lsloading = true;
  List? brandls;
  int? ref;

  openCamera() async {
    try {
      var pickedfile = await imgpicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1080,
          maxWidth: 1080,
          imageQuality: 50);
      if (pickedfile != null) {
        return pickedfile;
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  openPhoto() async {
    try {
      var pickedfile = await imgpicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1080,
          maxWidth: 1080,
          imageQuality: 50);
      if (pickedfile != null) {
        return pickedfile;
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
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

  deletePic(id) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/deleteJobImage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jImgId': id,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  deleteGroup(idg) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/deleteJobGroupImage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': ref,
        'typeId': widget.type_id,
        'groupNo': idg,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  getBrandLs() async {
    var response = await http.post(
      Uri.parse('$api/api/master/getBrandLs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{}),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        brandls = jsonResponse;
      });
      print(jsonResponse);
      return jsonResponse;
    }
  }

  uploadPic(File image, imgType, img_des_id, group_no) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = ref.toString();
    request.fields['imgType'] = imgType.toString();
    request.fields['typeId'] = widget.type_id.toString();
    request.fields['subTypeId'] = '';
    request.fields['imgDesId'] = img_des_id.toString();
    request.fields['groupNo'] = group_no.toString();
    request.fields['remark'] = '';
    request.fields['accessories'] = '';
    request.fields['sign_name'] = '';
    request.fields['userName'] = userName;
    request.fields['filesName'] = image.path.split('/').last;

    request.files.add(http.MultipartFile.fromBytes(
        'files', image.readAsBytesSync(),
        filename: image.path.split('/').last));

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    // print(respStr);

    // response.stream.transform(utf8.decoder).listen((value) {
    //   // setState(() {
    //   //   gg = json.decode(value)['groupNo'].toString();
    //   //   // returned = value;
    //   // });
    //   // print(gg);
    // });
    return respStr;
    // return json.decode(response.stream); //response.stream.transform(utf8.decoder).first;
  }

  uploadnoPic(imgType, img_des_id, group_no) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = ref.toString();
    request.fields['imgType'] = imgType.toString();
    request.fields['typeId'] = widget.type_id.toString();
    request.fields['subTypeId'] = '';
    request.fields['imgDesId'] = img_des_id.toString();
    request.fields['groupNo'] = group_no.toString();
    request.fields['remark'] = '';
    request.fields['accessories'] = '1';
    request.fields['sign_name'] = '';
    request.fields['userName'] = userName;

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    // print(response.body);
    // return response.body;
  }

  loopdelete() async {
    for (var i = 0; i < deleteLs.length; i++) {
      print(deleteLs[i]);
      await deletePic(deleteLs[i]);
    }
  }

  loopupload(group_no) async {
    for (var i = 0; i < desLs_before.length; i++) {
      if (desLs_before[i].onApi == 0 && desLs_before[i].j_img_name.isNotEmpty) {
        // print(desLs_before[i].j_img_name);
        await uploadPic(File(desLs_before[i].j_img_name),
                desLs_before[i].j_img_type, desLs_before[i].img_des_id, gg)
            .then((value) {
          var jj = json.decode(value);
          setState(() {
            gg = jj['groupNo'].toString();
          });
        });
      }
    }
  }

  loopupload_after(group_no) async {
    for (var i = 0; i < desLs_after.length; i++) {
      if (nothavedevice == true && nothavedevice != nothavedevice_f) {
        await uploadnoPic(
            desLs_after[i].j_img_type, desLs_after[i].img_des_id, gg);
        break;
      } else if (desLs_after[i].onApi == 0 &&
          desLs_after[i].j_img_name.isNotEmpty) {
        print(desLs_after[i].j_img_name);
        await uploadPic(File(desLs_after[i].j_img_name),
            desLs_after[i].j_img_type, desLs_after[i].img_des_id, gg);
      }
    }
  }

  updateRemark(groupNo, imgType, note) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/updateJobDetailInGroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': ref,
        'groupNo': groupNo,
        'typeId': widget.type_id,
        'imgType': imgType,
        'accessories': (nothavedevice == true) ? 1 : null,
        'remark': note,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  addrepair() async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/addJobDraft'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'typeFlag': 1,
        'cusId': widget.cusId,
        'sid': widget.sid,
        'refJidx': widget.jidx,
        'userName': widget.username
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        ref = jsonResponse['id'];
      });
      print(jsonResponse);
      return jsonResponse;
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

  @override
  void initState() {
    super.initState();
    getUser();
    getBrandLs();
    setState(() {
      typeName = (widget.type_id == 1)
          ? 'PV (แผงโซล่าเซลล์)'
          : (widget.type_id == 2)
              ? 'Mounting'
              : (widget.type_id == 3)
                  ? 'Inverter'
                  : (widget.type_id == 4)
                      ? 'ตู้ DC'
                      : (widget.type_id == 5)
                          ? 'Fuse'
                          : (widget.type_id == 6)
                              ? 'Breaker'
                              : (widget.type_id == 7)
                                  ? 'Switch'
                                  : (widget.type_id == 8)
                                      ? 'Optimizer'
                                      : (widget.type_id == 9)
                                          ? 'สายไฟ'
                                          : 'อื่นๆ';
    });
    if (widget.ref_jidx_repair == null) {
      setState(() {
        lsloading = false;
      });
    } else {
      API.getGroup(widget.ref_jidx_repair, widget.type_id).then((value) {
        setState(() {
          ref = widget.ref_jidx_repair;

          List list = json.decode(value.body);
          groupLs = list.map((m) => Group.fromJson(m)).toList();
          lsloading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final slidable = Slidable.of(context)?.openEndActionPane();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight:
            (defaultTargetPlatform == TargetPlatform.android) ? 160 : 140,
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
                top:
                    (defaultTargetPlatform == TargetPlatform.android) ? 20 : 0),
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
                      Text(typeName,
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
                        child: addcard()),
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
      body: SafeArea(
          child: Column(
        children: [
          (lsloading == true)
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff003175),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff57A946).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                    ),
                  ))
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // primary: false,
                      itemCount: groupLs.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 30, right: 30),
                            child: Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.2,
                                  motion: BehindMotion(),
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SlidableAction(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      onPressed: ((context) {
                                        // print(group);
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return (defaultTargetPlatform ==
                                                      TargetPlatform.android)
                                                  ? AlertDialog(
                                                      actionsPadding:
                                                          EdgeInsets.all(5),
                                                      // title: Text(
                                                      //     'ต้องการลบข้อมูลหรือไม่'),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 30,
                                                              bottom: 20),
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'ต้องการลบข้อมูลหรือไม่'),
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
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary: Colors
                                                                  .red, // Text Color
                                                            ),
                                                            onPressed: () {
                                                              deleteGroup(groupLs[
                                                                          index]
                                                                      .group_no)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: Text('ลบ')),
                                                      ],
                                                    )
                                                  : CupertinoAlertDialog(
                                                      content: Text(
                                                          'ต้องการลบข้อมูลหรือไม่'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context); //close Dialog
                                                          },
                                                          child: Text('ยกเลิก'),
                                                        ),
                                                        TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary: Colors
                                                                  .red, // Text Color
                                                            ),
                                                            onPressed: () {
                                                              deleteGroup(groupLs[
                                                                          index]
                                                                      .group_no)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: Text('ลบ')),
                                                      ],
                                                    );
                                            }).then((value) {
                                          if (ref != null) {
                                            API
                                                .getGroup(ref, widget.type_id)
                                                .then((value) {
                                              setState(() {
                                                List list =
                                                    json.decode(value.body);
                                                groupLs = list
                                                    .map((m) =>
                                                        Group.fromJson(m))
                                                    .toList();
                                              });
                                            });
                                          }
                                        });
                                      }),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'ลบ',
                                    ),
                                  ],
                                ),
                                child: items(
                                    groupLs[index].group_no,
                                    groupLs[index].before,
                                    groupLs[index].after,
                                    groupLs[index].max_img,
                                    index)));
                      })),
                )
        ],
      )),
    );
  }

  Widget addcard() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: GestureDetector(
        onTap: () {
          // beforeSheet(null);
          loading();
          setState(() {
            _selectedValue = null;
            detail = '';
            before_note.text = '';
            after_note.text = '';
            nothavedevice = false;
            nothavedevice_f = false;
            hint = '';
            deleteLs.clear();
            gg = '';
          });
          API.getDescript(ref, widget.type_id, null, 0).then((value) {
            setState(() {
              List list1 = json.decode(value.body);
              desLs_before = list1.map((m) => Descript.fromJson(m)).toList();

              setState(() {
                hint = desLs_before[0].hint;
              });
              for (var i = 0; i < desLs_before.length; i++) {
                if (desLs_before[i].j_img_remark.isNotEmpty) {
                  var sprit = desLs_before[i].j_img_remark.split('||');
                  setState(() {
                    _selectedValue = sprit[0];
                    detail = sprit[1];
                    before_note.text = sprit[2];
                  });
                }

                if (desLs_before[i].j_img_name.isEmpty) {
                  desLs_before.removeAt(i);
                }
              }
              // print(desLs_before);
            });
            API.getDescript(ref, widget.type_id, null, 1).then((value_after) {
              setState(() {
                List list2 = json.decode(value_after.body);
                desLs_after = list2.map((m) => Descript.fromJson(m)).toList();

                // for (var i = 0; i < desLs_after.length; i++) {
                //   if (desLs_after[i].j_img_name.isEmpty) {
                //     desLs_after.removeAt(i);
                //   }
                // }

                Navigator.pop(context);
                beforeSheet('', 0);
              });
            });
          });
        },
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffE1F5DC),
                Color(0xffD6EFB4),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xff149C32).withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(typeName,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Color(0xff2A302C))),
                Icon(
                  EvaIcons.plusCircle,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget items(group, before, after, max, no) {
    return GestureDetector(
      onTap: () {
        loading();
        setState(() {
          _selectedValue = null;
          detail = '';
          before_note.text = '';
          after_note.text = '';
          hint = '';
          nothavedevice = false;
          nothavedevice_f = false;
          deleteLs.clear();
          gg = group.toString();
        });
        API.getDescript(ref, widget.type_id, group, 0).then((value) {
          setState(() {
            List list1 = json.decode(value.body);
            desLs_before = list1.map((m) => Descript.fromJson(m)).toList();
            setState(() {
              hint = desLs_before[0].hint;
            });
            for (var i = 0; i < desLs_before.length; i++) {
              if (desLs_before[i].j_img_remark.isNotEmpty) {
                var sprit = desLs_before[i].j_img_remark.split('||');
                setState(() {
                  _selectedValue = sprit[0];
                  detail = sprit[1];
                  before_note.text = sprit[2];
                });
              }

              if (desLs_before[i].j_img_name.isEmpty) {
                desLs_before.removeAt(i);
              }
            }
            // print(desLs_before);
          });
          API.getDescript(ref, widget.type_id, group, 1).then((value_after) {
            setState(() {
              List list2 = json.decode(value_after.body);
              desLs_after = list2.map((m) => Descript.fromJson(m)).toList();
              if (desLs_after[0].j_img_accessories == 1) {
                setState(() {
                  nothavedevice_f = true;
                  nothavedevice = true;
                });
              }
              for (var i = 0; i < desLs_after.length; i++) {
                if (desLs_after[i].j_img_remark.isNotEmpty) {
                  setState(() {
                    after_note.text = desLs_after[i].j_img_remark.toString();
                  });
                  // break;
                }

                // if (desLs_after[i].j_img_name.isEmpty) {
                //   desLs_after.removeAt(i);
                // }
              }

              Navigator.pop(context);
              beforeSheet(group, no + 1);
            });
          });
        });
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xffD6EFB4)),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color(0xff57A946).withOpacity(0.1),
          //     blurRadius: 10,
          //     spreadRadius: 0,
          //     offset: Offset(0, 0), // Shadow position
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' ชุดที่ ${no + 1} $typeName',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xff9DC75B))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cardsolar() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
  //     child: Container(
  //       height: 120,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Color(0xff57A946).withOpacity(0.1),
  //             blurRadius: 10,
  //             spreadRadius: 0,
  //             offset: Offset(0, 0), // Shadow position
  //           ),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'ชุดที่ 1 แผงโซล่าเซลล์',
  //                   style: TextStyle(
  //                       color: Color(0xff464646),
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //               ],
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 beforeSheet();
  //               },
  //               child: Container(
  //                 color: Colors.white,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Container(
  //                           height: 25,
  //                           width: 25,
  //                           decoration: BoxDecoration(
  //                             // border: Border.all(width: 3),
  //                             borderRadius: BorderRadius.all(
  //                               Radius.circular(200),
  //                             ),
  //                             color: Color(0xffB7B7B7),
  //                           ),
  //                           child: Center(
  //                             child: Text('0',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 13,
  //                                     color: Colors.white)),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 20,
  //                         ),
  //                         Text(
  //                           'รูปถ่ายก่อนซ่อม',
  //                           style: TextStyle(
  //                               color: Color(0xffB7B7B7),
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w600),
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       height: 25,
  //                       width: 25,
  //                       decoration: BoxDecoration(
  //                         // border: Border.all(width: 3),
  //                         borderRadius: BorderRadius.all(
  //                           Radius.circular(200),
  //                         ),
  //                         color: Color(0xffB7B7B7),
  //                       ),
  //                       child: Center(
  //                           child: Icon(
  //                         Icons.add,
  //                         color: Colors.white,
  //                       )),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       height: 25,
  //                       width: 25,
  //                       decoration: BoxDecoration(
  //                         // border: Border.all(width: 3),
  //                         borderRadius: BorderRadius.all(
  //                           Radius.circular(200),
  //                         ),
  //                         color: Color(0xffB7B7B7),
  //                       ),
  //                       child: Center(
  //                         child: Text('0',
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 13,
  //                                 color: Colors.white)),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Text(
  //                       'รูปถ่ายหลังซ่อม',
  //                       style: TextStyle(
  //                           color: Color(0xffB7B7B7),
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.w600),
  //                     ),
  //                   ],
  //                 ),
  //                 Container(
  //                   height: 25,
  //                   width: 25,
  //                   decoration: BoxDecoration(
  //                     // border: Border.all(width: 3),
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(200),
  //                     ),
  //                     color: Color(0xffB7B7B7),
  //                   ),
  //                   child: Center(
  //                       child: Icon(
  //                     Icons.add,
  //                     color: Colors.white,
  //                   )),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void beforeSheet(group, no) {
    showModalBottomSheet(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return SafeArea(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    reverse: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                                (group == '')
                                    ? 'เพิ่มชุด $typeName'
                                    : 'ชุดที่ $no $typeName',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff2A302C))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 1,
                        //       child: Row(
                        //         children: [
                        //           Text('ยี่ห้อแผง',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 14,
                        //                   color: Color(0xff9DC75B))),
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 4,
                        //       child: Row(
                        //         children: [
                        //           SizedBox(
                        //             width: 10,
                        //           ),
                        //           Container(
                        //             height: 35,
                        //             width: 150,
                        //             padding:
                        //                 EdgeInsets.only(left: 10, right: 5),
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(12),
                        //               border: Border.all(
                        //                   width: 0.5, color: Color(0xffD3D3D3)),
                        //             ),
                        //             child: DropdownButtonHideUnderline(
                        //               child: DropdownButton(
                        //                 hint: Text(
                        //                   "เลือกแบรนด์",
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize: 14,
                        //                       color: Color(0xff9DC75B)),
                        //                 ),
                        //                 icon: Icon(
                        //                     Icons.keyboard_arrow_down_rounded,
                        //                     size: 20,
                        //                     color: Color(0xff9DC75B)),
                        //                 items: brandls?.map((value) {
                        //                   return DropdownMenuItem(
                        //                     value: value['brand'].toString(),
                        //                     child: Text(
                        //                       value['brand'].toString(),
                        //                       style: TextStyle(
                        //                           fontWeight: FontWeight.w600,
                        //                           fontSize: 14,
                        //                           color: Color(0xff9DC75B)),
                        //                     ),
                        //                   );
                        //                 }).toList(),
                        //                 onChanged: (newvalue) {
                        //                   mystate(() {
                        //                     _selectedValue = newvalue;
                        //                   });
                        //                 },
                        //                 value: _selectedValue,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 1,
                        //       child: Row(
                        //         children: [
                        //           Text('อาการ',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 14,
                        //                   color: Color(0xff9DC75B))),
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 4,
                        //       child: Row(
                        //         children: [
                        //           GestureDetector(
                        //             onTap: () {
                        //               mystate(() {
                        //                 detail = 'แผงแตก';
                        //               });
                        //             },
                        //             child: Container(
                        //               child: Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 10),
                        //                 child: Row(
                        //                   children: [
                        //                     Icon(
                        //                       (detail == 'แผงแตก')
                        //                           ? Icons.radio_button_checked
                        //                           : Icons.radio_button_off,
                        //                       color: Color(0xff9DC75B),
                        //                       size: 20,
                        //                     ),
                        //                     SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                     Text('แผงแตก',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.w500,
                        //                             fontSize: 14,
                        //                             color: Color(0xff9DC75B))),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {
                        //               mystate(() {
                        //                 detail = 'แผงดับ';
                        //               });
                        //             },
                        //             child: Container(
                        //               child: Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 10),
                        //                 child: Row(
                        //                   children: [
                        //                     Icon(
                        //                       (detail == 'แผงดับ')
                        //                           ? Icons.radio_button_checked
                        //                           : Icons.radio_button_off,
                        //                       color: Color(0xff9DC75B),
                        //                       size: 20,
                        //                     ),
                        //                     SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                     Text('แผงดับ',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.w500,
                        //                             fontSize: 14,
                        //                             color: Color(0xff9DC75B))),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          children: [
                            Text('ก่อนซ่อม',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff9DC75B))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GridView.count(
                            shrinkWrap: true,
                            childAspectRatio: 1.1,
                            primary: false,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children:
                                List.generate(desLs_before.length + 1, (index) {
                              if (index > desLs_before.length - 1) {
                                return GestureDetector(
                                  onTap: () {
                                    showAdaptiveActionSheet(
                                      context: context,
                                      // title: const Text('Title'),
                                      actions: <BottomSheetAction>[
                                        BottomSheetAction(
                                          title: Text('กล้อง'),
                                          onPressed: (context) {
                                            openCamera().then((value) {
                                              mystate(() {
                                                desLs_before.add(Descript(
                                                    j_img_id: 0,
                                                    j_img_name: value.path,
                                                    onApi: 0,
                                                    group_no: null,
                                                    img_des_id: 7,
                                                    img_description:
                                                        'ภาพจุดที่เสีย',
                                                    j_img_accessories: null,
                                                    j_img_remark: '',
                                                    hint: '',
                                                    j_img_type: 0,
                                                    type_id: null));
                                              });
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        BottomSheetAction(
                                            title: Text('รูปภาพ'),
                                            onPressed: (context) {
                                              openPhoto().then((value) {
                                                mystate(() {
                                                  desLs_before.add(Descript(
                                                      j_img_id: 0,
                                                      j_img_name: value.path,
                                                      onApi: 0,
                                                      group_no: null,
                                                      img_des_id: 7,
                                                      img_description:
                                                          'ภาพจุดที่เสีย',
                                                      j_img_accessories: null,
                                                      j_img_remark: '',
                                                      hint: '',
                                                      j_img_type: 0,
                                                      type_id: null));

                                                  // desLs_before[index]
                                                  //         .j_img_name =
                                                  //     value.path;
                                                  // desLs_before[index]
                                                  //     .onApi = 0;
                                                });
                                              });

                                              Navigator.pop(context);
                                            }),
                                      ],
                                      cancelAction:
                                          CancelAction(title: Text('ยกเลิก')),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Color(0xffAED76E)),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Color(0xffD6EFB4),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text('ภาพจุดที่เสีย',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Color(0xff464646))),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    (desLs_before[index].j_img_name.isEmpty)
                                        ? showAdaptiveActionSheet(
                                            context: context,
                                            // title: const Text('Title'),
                                            actions: <BottomSheetAction>[
                                              BottomSheetAction(
                                                title: Text('กล้อง'),
                                                onPressed: (context) {
                                                  openCamera().then((value) {
                                                    mystate(() {
                                                      desLs_before[index]
                                                              .j_img_name =
                                                          value.path;
                                                      desLs_before[index]
                                                          .onApi = 0;
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              BottomSheetAction(
                                                  title: Text('รูปภาพ'),
                                                  onPressed: (context) {
                                                    openPhoto().then((value) {
                                                      mystate(() {
                                                        desLs_before[index]
                                                                .j_img_name =
                                                            value.path;
                                                        desLs_before[index]
                                                            .onApi = 0;
                                                      });
                                                    });

                                                    Navigator.pop(context);
                                                  }),
                                            ],
                                            cancelAction: CancelAction(
                                                title: Text('ยกเลิก')),
                                          )
                                        : null;
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Colors.transparent),
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      // (pic[index].onApi == 1)
                                                      //     ?
                                                      (desLs_before[index]
                                                              .j_img_name
                                                              .isNotEmpty)
                                                          ? (desLs_before[index]
                                                                      .onApi ==
                                                                  1)
                                                              ? Image.network(
                                                                  '$api/${desLs_before[index].j_img_name}', // this image doesn't exist
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: double
                                                                      .infinity,
                                                                  width: double
                                                                      .infinity,

                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error_outline_rounded,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    );
                                                                  },
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .green,
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                              : Image.file(
                                                                  File(desLs_before[
                                                                          index]
                                                                      .j_img_name),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: double
                                                                      .infinity,
                                                                  width: double
                                                                      .infinity,
                                                                )
                                                          : Container()),
                                              (desLs_before[index]
                                                      .j_img_name
                                                      .isNotEmpty)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  if (desLs_before[
                                                                              index]
                                                                          .onApi ==
                                                                      1) {
                                                                    deleteLs.add(
                                                                        desLs_before[index]
                                                                            .j_img_id);
                                                                    print(
                                                                        deleteLs);
                                                                  }
                                                                  desLs_before
                                                                      .removeAt(
                                                                          index);
                                                                  // desLs_before[index].j_img_name =
                                                                  //     '';
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          200),
                                                                    ),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                                  child: Center(
                                                                      child:
                                                                          Icon(
                                                                    Icons
                                                                        .close_rounded,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .grey,
                                                                  )),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            Color(0xffD6EFB4),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                            desLs_before[index].img_description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Color(0xff464646))),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            })),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('สาเหตุการชำรุดของอุปกรณ์',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff9DC75B))),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          // height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffD6EFB4)),
                          ),
                          child: TextField(
                            onTapOutside: (b) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            // textInputAction: TextInputAction.done,
                            controller: before_note,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: hint,
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                loading();
                                if (ref == null) {
                                  addrepair().then((val) {
                                    if (desLs_before.isEmpty) {
                                      Navigator.pop(context);
                                      pop('กรุณาอัพโหลดรูป');
                                    } else {
                                      loopdelete().then((value) {
                                        loopupload(group).then((value) {
                                          loopupload_after(group).then((value) {
                                            updateRemark(gg, 0,
                                                    '$_selectedValue||$detail||${before_note.text}')
                                                .then((value) {
                                              updateRemark(
                                                      gg, 1, after_note.text)
                                                  .then((value) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      });
                                    }
                                  });
                                } else {
                                  if (desLs_before.isEmpty) {
                                    Navigator.pop(context);
                                    pop('กรุณาอัพโหลดรูป');
                                  } else {
                                    loopdelete().then((value) {
                                      loopupload(group).then((value) {
                                        loopupload_after(group).then((value) {
                                          updateRemark(gg, 0,
                                                  '$_selectedValue||$detail||${before_note.text}')
                                              .then((value) {
                                            updateRemark(gg, 1, after_note.text)
                                                .then((value) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          });
                                        });
                                      });
                                    });
                                  }
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
        }).then((value) {
      if (ref != null) {
        API.getGroup(ref, widget.type_id).then((value) {
          setState(() {
            print('ok');
            List list = json.decode(value.body);
            groupLs = list.map((m) => Group.fromJson(m)).toList();
          });
        });
      }
    });
  }
}

class API {
  static Future getGroup(idd, typeId) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobGroupRepairImageLs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{'jidx': idd, 'typeId': typeId}),
    );
    return response;
  }

  static Future getDescript(idd, typeId, groupNo, imgType) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobGroupRepairDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': idd,
        'typeId': typeId,
        'groupNo': groupNo,
        'imgType': imgType,
      }),
    );
    return response;
  }
}

class Group {
  final int type_id;
  final int group_no;
  final int before;
  final int after;
  final int max_img;
  final String type_name;

  const Group(
      {required this.type_id,
      required this.type_name,
      required this.group_no,
      required this.before,
      required this.after,
      required this.max_img});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      type_id: json['type_id'],
      group_no: json['group_no'],
      before: json['before'],
      after: json['after'],
      max_img: json['max_img'],
      type_name: json['type_name'],
    );
  }
}

class Descript {
  final int? j_img_id;
  String j_img_name;

  final int? img_des_id;
  final int? type_id;
  final int? j_img_type;
  final int? group_no;
  final String img_description;
  final String j_img_remark;
  final String hint;
  final int? j_img_accessories;
  int onApi;

  Descript(
      {required this.j_img_id,
      required this.j_img_name,
      required this.img_des_id,
      required this.type_id,
      required this.j_img_type,
      required this.group_no,
      required this.img_description,
      required this.j_img_remark,
      required this.j_img_accessories,
      required this.hint,
      required this.onApi});

  factory Descript.fromJson(Map<String, dynamic> json) {
    return Descript(
        j_img_id: json['j_img_id'],
        j_img_name: json['j_img_name'],
        img_des_id: json['img_des_id'],
        type_id: json['type_id'],
        j_img_type: json['j_img_type'],
        group_no: json['group_no'],
        img_description: json['img_description'],
        j_img_remark: (json['j_img_remark'].toString() == 'null')
            ? ""
            : json['j_img_remark'],
        j_img_accessories: json['j_img_accessories'],
        hint: json['hint'] ?? '',
        onApi: 1);
  }
}
