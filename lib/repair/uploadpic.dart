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

class uploadPic extends StatefulWidget {
  @override
  _uploadPicState createState() => _uploadPicState();

  final int jidx;
  final int type_id;
  final int status;
  final int sid;
  uploadPic(
      {required this.jidx,
      required this.type_id,
      required this.status,
      required this.sid});
}

class _uploadPicState extends State<uploadPic> {
  final ImagePicker imgpicker = ImagePicker();
  String typeName = '';
  var groupLs = <Group>[];
  var desLs_before = <Descript>[];
  var desLs_after = <Descript>[];

  bool nothavedevice = false;
  bool nothavedevice_f = false;
  String detail = '';
  String? _selectedValue;
  String gg = '';
  String hint = '';

  String afhint = '';

  var before_note = TextEditingController();
  var after_note = TextEditingController();

  List deleteLs = [];

  String pathPic = 'https://backoffice.energygreenplus.co.th/';

  String userName = "Loading...";
  int? iduser;
  bool lsloading = true;
  List? brandls;

  openCamera() async {
    try {
      var pickedfile = await imgpicker.pickImage(source: ImageSource.camera);
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
          maxHeight: 480,
          maxWidth: 640,
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/deleteJobImage'),
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/deleteJobGroupImage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': widget.jidx,
        'typeId': widget.type_id,
        'groupNo': idg,
        'userName': userName,
      }),
    );
    print(idg);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  getBrandLs() async {
    var response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getBrandBysid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'sid': widget.sid,
        'accType': (widget.type_id == 1) ? 0 : 1,
      }),
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
        'POST',
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
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
        'POST',
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
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

  checkbefore() async {
    int haveimg = 0;
    for (var i = 0; i < desLs_before.length; i++) {
      if (desLs_before[i].j_img_name.isNotEmpty) {
        haveimg = haveimg + 1;
      }
    }
    return (haveimg == desLs_before.length) ? true : false;
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/updateJobDetailInGroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': widget.jidx,
        'groupNo': groupNo,
        'typeId': widget.type_id,
        'imgType': imgType,
        'accessories': (imgType == 0)
            ? null
            : (nothavedevice == true)
                ? 1
                : 0,
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

  @override
  void initState() {
    super.initState();
    getUser();
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
                                          : (widget.type_id == 17)
                                              ? 'ตู้ AC'
                                              : 'อื่นๆ';
    });
    API.getGroup(widget.jidx, widget.type_id).then((value) {
      setState(() {
        List list = json.decode(value.body);
        groupLs = list.map((m) => Group.fromJson(m)).toList();
        lsloading = false;
      });
      // API.getDescript(widget.jidx, widget.type_id, 3, 0).then((value) {
      //   setState(() {
      //     List list1 = json.decode(value.body);
      //     desLs_before = list1.map((m) => Descript.fromJson(m)).toList();
      //   });
      //   API.getDescript(widget.jidx, widget.type_id, 3, 1).then((value_after) {
      //     setState(() {
      //       List list2 = json.decode(value_after.body);
      //       desLs_after = list2.map((m) => Descript.fromJson(m)).toList();
      //       lsloading = false;
      //     });
      //   });
      // });
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

  @override
  Widget build(BuildContext context) {
    final slidable = Slidable.of(context)?.openEndActionPane();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: (widget.status == 3)
            ? (defaultTargetPlatform == TargetPlatform.android)
                ? 100
                : 80
            : (defaultTargetPlatform == TargetPlatform.android)
                ? 160
                : 140,
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
                        child: (widget.status == 3)
                            ? Container(
                                height: 20,
                              )
                            : addcard()),
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
      bottomNavigationBar: (widget.status == 3)
          ? null
          : Container(
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
                    padding: EdgeInsets.only(top: 20, left: 25, right: 25),
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
                            child: (widget.status == 3)
                                ? items(
                                    index + 1,
                                    groupLs[index].before,
                                    groupLs[index].after,
                                    groupLs[index].max_img,
                                    groupLs[index].group_no)
                                : Slidable(
                                    endActionPane: ActionPane(
                                      extentRatio: 0.2,
                                      motion: BehindMotion(),
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SlidableAction(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          onPressed: ((context) {
                                            // print(group);
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return (defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android)
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
                                                              child: Text(
                                                                  'ยกเลิก'),
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
                                                                child:
                                                                    Text('ลบ')),
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
                                                              child: Text(
                                                                  'ยกเลิก'),
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
                                                                child:
                                                                    Text('ลบ')),
                                                          ],
                                                        );
                                                }).then((value) {
                                              API
                                                  .getGroup(widget.jidx,
                                                      widget.type_id)
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
                                        index + 1,
                                        groupLs[index].before,
                                        groupLs[index].after,
                                        groupLs[index].max_img,
                                        groupLs[index].group_no)));
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
            hint = '';
            afhint = '';
            nothavedevice = false;
            nothavedevice_f = false;
            deleteLs.clear();
            gg = '';
          });
          API.getDescript(widget.jidx, widget.type_id, null, 0).then((value) {
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
              }
              // print(desLs_before);
            });
            getBrandLs().then((val) {
              API
                  .getDescript(widget.jidx, widget.type_id, null, 1)
                  .then((value_after) {
                setState(() {
                  List list2 = json.decode(value_after.body);
                  desLs_after = list2.map((m) => Descript.fromJson(m)).toList();
                  print(list2);
                  setState(() {
                    afhint = desLs_after[0].hint;
                  });
                  Navigator.pop(context);
                  beforeSheet('', 0);
                });
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

  Widget items(group, before, after, max, realgroup) {
    return GestureDetector(
      onTap: () {
        loading();
        setState(() {
          _selectedValue = null;
          detail = '';
          before_note.text = '';
          after_note.text = '';
          nothavedevice = false;
          nothavedevice_f = false;
          hint = '';
          afhint = '';

          deleteLs.clear();
          gg = realgroup.toString();
        });
        API
            .getDescript(widget.jidx, widget.type_id, realgroup, 0)
            .then((value) {
          setState(() {
            List list1 = json.decode(value.body);
            desLs_before = list1.map((m) => Descript.fromJson(m)).toList();
            print(list1);
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
            }
            // print(desLs_before);
          });
          getBrandLs().then((brand) {
            API
                .getDescript(widget.jidx, widget.type_id, realgroup, 1)
                .then((value_after) {
              setState(() {
                List list2 = json.decode(value_after.body);

                desLs_after = list2.map((m) => Descript.fromJson(m)).toList();

                setState(() {
                  afhint = desLs_after[0].hint;
                });
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
                    break;
                  }
                }

                Navigator.pop(context);
                beforeSheet(realgroup, group);
              });
            });
          });
        });
      },
      child: Container(
        height: 70,
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
                  Text(' ชุดที่ $group $typeName',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xff9DC75B))),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffAED76E)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                          color: (before == max)
                              ? Color(0xffAED76E)
                              : Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('ก่อนซ่อมบำรุง',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: (before == max)
                                        ? Color(0xffffffff)
                                        : Color(0xffAED76E))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 25,
                        // width: 45,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 3),
                          border: Border.all(color: Color(0xffAED76E)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                          color:
                              (after == max) ? Color(0xffAED76E) : Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('หลังซ่อมบำรุง',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: (after == max)
                                        ? Color(0xffffffff)
                                        : Color(0xffAED76E))),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // Container(
              //   height: 25,
              //   width: 25,
              //   decoration: BoxDecoration(
              //     // border: Border.all(width: 3),
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(200),
              //     ),
              //     color: (before == max && after == max)
              //         ? Color(0xff57A946)
              //         : Color(0xffB7B7B7),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       Icons.check,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              // ),
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
          // bool nothavedevice = false;
          // // String detail = 'แผงแตก';
          // String _selectedValue = 'Solar Edga';

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
                        (widget.type_id == 1 || widget.type_id == 3)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Text('ยี่ห้อ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xff9DC75B))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          (widget.status == 3)
                                              ? Text('$_selectedValue',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Color(0xff9DC75B)))
                                              : Container(
                                                  height: 30,
                                                  width: 150,
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color:
                                                            Color(0xffD3D3D3)),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      hint: Text(
                                                        "เลือกแบรนด์",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff9DC75B)),
                                                      ),
                                                      icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down_rounded,
                                                          size: 20,
                                                          color: Color(
                                                              0xff9DC75B)),
                                                      items:
                                                          brandls?.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value['brand']
                                                              .toString(),
                                                          child: Text(
                                                            value['brand']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff9DC75B)),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newvalue) {
                                                        mystate(() {
                                                          _selectedValue =
                                                              newvalue;
                                                        });
                                                      },
                                                      value: _selectedValue,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        (widget.type_id == 1)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Text('อาการ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xff9DC75B))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: (widget.status == 3)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Text('$detail',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xff9DC75B))),
                                                ],
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    mystate(() {
                                                      detail = 'แผงแตก';
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            (detail == 'แผงแตก')
                                                                ? Icons
                                                                    .radio_button_checked
                                                                : Icons
                                                                    .radio_button_off,
                                                            color: Color(
                                                                0xff9DC75B),
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text('แผงแตก',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff9DC75B))),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    mystate(() {
                                                      detail = 'แผงดับ';
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            (detail == 'แผงดับ')
                                                                ? Icons
                                                                    .radio_button_checked
                                                                : Icons
                                                                    .radio_button_off,
                                                            color: Color(
                                                                0xff9DC75B),
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text('แผงดับ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff9DC75B))),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('ก่อนซ่อม',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff2A302C))),
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
                                List.generate(desLs_before.length, (index) {
                              return GestureDetector(
                                onTap: (widget.status == 3)
                                    ? null
                                    : () {
                                        (desLs_before[index].j_img_name.isEmpty)
                                            ? showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: <BottomSheetAction>[
                                                  BottomSheetAction(
                                                    title: Text('Camera'),
                                                    onPressed: (context) {
                                                      openCamera()
                                                          .then((value) {
                                                        if (value != null) {
                                                          mystate(() {
                                                            desLs_before[index]
                                                                    .j_img_name =
                                                                value.path;
                                                            desLs_before[index]
                                                                .onApi = 0;
                                                          });
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  BottomSheetAction(
                                                      title: Text('Photos'),
                                                      onPressed: (context) {
                                                        openPhoto()
                                                            .then((value) {
                                                          if (value != null) {
                                                            mystate(() {
                                                              desLs_before[
                                                                          index]
                                                                      .j_img_name =
                                                                  value.path;
                                                              desLs_before[
                                                                      index]
                                                                  .onApi = 0;
                                                            });
                                                          }
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                                cancelAction: CancelAction(
                                                    title: Text('Cancel')),
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
                                              color: (desLs_before[index]
                                                      .j_img_name
                                                      .isEmpty)
                                                  ? Color(0xffAED76E)
                                                  : Colors.transparent),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
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
                                                                '$pathPic${desLs_before[index].j_img_name}', // this image doesn't exist
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
                                                                    child: Icon(
                                                                      Icons
                                                                          .error_outline_rounded,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
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
                                                ? (widget.status == 3)
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  mystate(() {
                                                                    if (desLs_before[index]
                                                                            .onApi ==
                                                                        1) {
                                                                      deleteLs.add(
                                                                          desLs_before[index]
                                                                              .j_img_id);
                                                                      print(
                                                                          deleteLs);
                                                                    }
                                                                    desLs_before[
                                                                            index]
                                                                        .j_img_name = '';
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
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
                                                                        child: Icon(
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
                                                      color: Color(0xffD6EFB4),
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
                            })),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('สาเหตุการชำรุดของอุปกรณ์',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
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
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffD6EFB4)),
                          ),
                          child: TextField(
                            // textInputAction: TextInputAction.done,
                            controller: before_note,
                            readOnly: (widget.status == 3) ? true : false,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: hint,
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey[300]),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('หลังซ่อม',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff2A302C))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (widget.status == 3)
                                  ? null
                                  : () {
                                      mystate(() {
                                        deleteLs.clear();
                                        for (var i = 0;
                                            i < desLs_after.length;
                                            i++) {
                                          if (desLs_after[i].onApi == 1) {
                                            deleteLs
                                                .add(desLs_after[i].j_img_id);
                                            print(deleteLs);
                                          }
                                        }
                                        (nothavedevice)
                                            ? nothavedevice = false
                                            : nothavedevice = true;
                                      });
                                      print(nothavedevice);
                                    },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (nothavedevice == true)
                                            ? Color(0xff9DC75B)
                                            : Color(0xffD3D3D3)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_outlined,
                                        color: (nothavedevice == true)
                                            ? Color(0xff9DC75B)
                                            : Color(0xffD3D3D3),
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('ไม่มีอุปกรณ์ซ่อมบำรุง',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: (nothavedevice == true)
                                                  ? Color(0xff9DC75B)
                                                  : Color(0xffD3D3D3))),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.count(
                            shrinkWrap: true,
                            childAspectRatio: 1.1,
                            primary: false,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children:
                                List.generate(desLs_after.length, (index) {
                              return GestureDetector(
                                onTap: (widget.status == 3)
                                    ? null
                                    : () {
                                        (nothavedevice == true)
                                            ? null
                                            : (desLs_after[index]
                                                    .j_img_name
                                                    .isEmpty)
                                                ? showAdaptiveActionSheet(
                                                    context: context,
                                                    // title: const Text('Title'),
                                                    actions: <BottomSheetAction>[
                                                      BottomSheetAction(
                                                        title: Text('Camera'),
                                                        onPressed: (context) {
                                                          openCamera()
                                                              .then((value) {
                                                            if (value != null) {
                                                              mystate(() {
                                                                desLs_after[index]
                                                                        .j_img_name =
                                                                    value.path;
                                                                desLs_after[
                                                                        index]
                                                                    .onApi = 0;
                                                              });
                                                            }
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      BottomSheetAction(
                                                          title: Text('Photos'),
                                                          onPressed: (context) {
                                                            openPhoto()
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                mystate(() {
                                                                  desLs_after[index]
                                                                          .j_img_name =
                                                                      value
                                                                          .path;
                                                                  desLs_after[
                                                                          index]
                                                                      .onApi = 0;
                                                                });
                                                              }
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                    ],
                                                    cancelAction: CancelAction(
                                                        title: Text('Cancel')),
                                                  )
                                                : null;
                                      },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: (nothavedevice == true)
                                            ? BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Color(0xffD3D3D3)),
                                              )
                                            : BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: (desLs_after[index]
                                                            .j_img_name
                                                            .isEmpty)
                                                        ? Color(0xffAED76E)
                                                        : Colors.transparent),
                                              ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                child:
                                                    // (pic[index].onApi == 1)
                                                    //     ?
                                                    (desLs_after[index]
                                                            .j_img_name
                                                            .isNotEmpty)
                                                        ? (desLs_after[index]
                                                                    .onApi ==
                                                                1)
                                                            ? Image.network(
                                                                '$pathPic${desLs_after[index].j_img_name}', // this image doesn't exist
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
                                                                    child: Icon(
                                                                      Icons
                                                                          .error_outline_rounded,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
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
                                                                File(desLs_after[
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
                                            (desLs_after[index]
                                                    .j_img_name
                                                    .isNotEmpty)
                                                ? (widget.status == 3)
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  mystate(() {
                                                                    if (desLs_after[index]
                                                                            .onApi ==
                                                                        1) {
                                                                      deleteLs.add(
                                                                          desLs_after[index]
                                                                              .j_img_id);
                                                                      print(
                                                                          deleteLs);
                                                                    }
                                                                    desLs_after[
                                                                            index]
                                                                        .j_img_name = '';
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
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
                                                                        child: Icon(
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
                                                      color: (nothavedevice ==
                                                              true)
                                                          ? Color(0xffD3D3D3)
                                                          : Color(0xffD6EFB4),
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
                                          desLs_after[index].img_description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Color(0xff464646))),
                                    ),
                                  ],
                                ),
                              );
                            })),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('สาเหตุการชำรุดของอุปกรณ์',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
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
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffD6EFB4)),
                          ),
                          child: TextField(
                            // textInputAction: TextInputAction.done,
                            controller: after_note,
                            readOnly: (widget.status == 3) ? true : false,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: afhint,
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey[300]),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        (widget.status == 3)
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      loading();
                                      if (widget.type_id == 1) {
                                        if (_selectedValue == null ||
                                            detail == '') {
                                          Navigator.pop(context);
                                          pop('กรุณากรอกรายละเอียด');
                                          print('กรุณากรอกรายละเอียด');
                                        } else {
                                          checkbefore().then((va) {
                                            if (va == false) {
                                              Navigator.pop(context);
                                              pop('กรุณาอัพโหลดรูปก่อนซ่อม');
                                              print('กรุณาอัพโหลดรูปก่อนซ่อม');
                                            } else {
                                              loopdelete().then((value) {
                                                loopupload(group).then((value) {
                                                  loopupload_after(group)
                                                      .then((value) {
                                                    updateRemark(gg, 0,
                                                            '$_selectedValue||$detail||${before_note.text}')
                                                        .then((value) {
                                                      updateRemark(gg, 1,
                                                              after_note.text)
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
                                        }
                                      } else if (widget.type_id == 3) {
                                        if (_selectedValue == null) {
                                          Navigator.pop(context);
                                          pop('กรุณากรอกรายละเอียด');
                                          print('กรุณากรอกรายละเอียด');
                                        } else {
                                          checkbefore().then((va) {
                                            if (va == false) {
                                              Navigator.pop(context);
                                              pop('กรุณาอัพโหลดรูปก่อนซ่อม');
                                              print('กรุณาอัพโหลดรูปก่อนซ่อม');
                                            } else {
                                              loopdelete().then((value) {
                                                loopupload(group).then((value) {
                                                  loopupload_after(group)
                                                      .then((value) {
                                                    updateRemark(gg, 0,
                                                            '$_selectedValue||$detail||${before_note.text}')
                                                        .then((value) {
                                                      updateRemark(gg, 1,
                                                              after_note.text)
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
                                        }
                                      } else {
                                        checkbefore().then((va) {
                                          if (va == false) {
                                            Navigator.pop(context);
                                            pop('กรุณาอัพโหลดรูปก่อนซ่อม');
                                            print('กรุณาอัพโหลดรูปก่อนซ่อม');
                                          } else {
                                            loopdelete().then((value) {
                                              loopupload(group).then((value) {
                                                loopupload_after(group)
                                                    .then((value) {
                                                  updateRemark(gg, 0,
                                                          '$_selectedValue||$detail||${before_note.text}')
                                                      .then((value) {
                                                    updateRemark(gg, 1,
                                                            after_note.text)
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
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        }).then((value) {
      API.getGroup(widget.jidx, widget.type_id).then((value) {
        setState(() {
          print('ok');
          List list = json.decode(value.body);
          groupLs = list.map((m) => Group.fromJson(m)).toList();
        });
      });
    });
  }
}

class API {
  static Future getGroup(idd, typeId) async {
    final response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobGroupRepairImageLs'),
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobGroupRepairDetail'),
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
  final int? j_img_accessories;
  final String hint;

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
