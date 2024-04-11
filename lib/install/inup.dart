import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:egp_app/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class inup extends StatefulWidget {
  _inupState createState() => _inupState();
  final int jidx;
  final int jTaskId;
  final String title;
  final int status;
  final String userName;
  final String date;
  final double curValue;
  inup(
      {required this.title,
      required this.status,
      required this.jTaskId,
      required this.jidx,
      required this.userName,
      required this.date,
      required this.curValue});
}

class _inupState extends State<inup> {
  final ImagePicker imgpicker = ImagePicker();

  double Value = 0;
  var pic = <Album>[];
  List deleteLs = [];
  String date = '';

  var remark = TextEditingController();

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(
          maxHeight: 1080, maxWidth: 1080, imageQuality: 50);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        // return pickedfiles;
        for (var i = 0; i < pickedfiles.length; i++) {
          pic.add(Album(
              j_img_install_id: 0,
              j_img_install_name: pickedfiles[i].path,
              onApi: 0,
              j_img_install_remark: '',
              j_img_install_percent: 0));
        }
        // setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  openCamera() async {
    try {
      var pickedfile = await imgpicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1080,
          maxWidth: 1080,
          imageQuality: 50);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfile != null) {
        // return pickedfile;
        pic.add(Album(
            j_img_install_id: 0,
            j_img_install_name: pickedfile.path,
            onApi: 0,
            j_img_install_remark: '',
            j_img_install_percent: 0));

        // setState(() {});

        // print("Image List Length:" + imagefiles!.length.toString());
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  getPicLs(idd, sortDate) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobInstallImageDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body:
          jsonEncode(<dynamic, dynamic>{'jTaskId': idd, 'sortDate': sortDate}),
    );
    return response;
  }

  uploadPic(File? image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImageInstall'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
    request.fields['jTaskId'] = widget.jTaskId.toString();
    request.fields['percent'] = '0.0';
    request.fields['remark'] = '';

    request.fields['userName'] = widget.userName;
    request.fields['filesName'] =
        (image == null) ? "" : image.path.split('/').last;

    (image == null)
        ? null
        : request.files.add(http.MultipartFile.fromBytes(
            'files', image.readAsBytesSync(),
            filename: image.path.split('/').last));

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print('uppic : $value');
    });
    // print(response.body);
    // return response.body;
  }

  loopupload() async {
    for (var i = 0; i < pic.length; i++) {
      if (pic[i].onApi == 0) {
        print(pic[i].j_img_install_name);
        await uploadPic(File(pic[i].j_img_install_name));
        // await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  loopdelete() async {
    for (var i = 0; i < deleteLs.length; i++) {
      print(deleteLs[i]);
      await deletePic(deleteLs[i]);
    }
  }

  deletePic(id) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/deleteImageInstall'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jImgInstallId': id,
        'userName': widget.userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  updateRemark() async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/updateJobDetailInstall'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "jTaskId": widget.jTaskId,
        "percent": Value.toInt(),
        "remark": remark.text,
        "userName": widget.userName
      }),
    );
    print('upremark : ${response.statusCode}');
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
    // TODO: implement initState
    super.initState();

    print("jidx: ${widget.jidx} ,jTaskId: ${widget.jTaskId}");

    if (widget.date.isEmpty) {
      date = DateFormat.yMMMMEEEEd("th").format(DateTime.now()).toString();
    } else {
      date = DateFormat.yMMMMEEEEd("th")
          .format(DateTime.parse(widget.date))
          .toString();
    }
    getPicLs(widget.jTaskId, widget.date).then((val) {
      List list = json.decode(val.body);

      if (list.isNotEmpty) {
        setState(() {
          pic = list.map((m) => Album.fromJson(m)).toList();
          Value = pic[0].j_img_install_percent ?? 0.0;
          remark.text = pic[0].j_img_install_remark ?? "";
        });
      } else {
        print('null');
        setState(() {
          Value = widget.curValue ?? 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Text('ดำเนินงาน',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff2A302C))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(0xff57A946),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Icon(
                            Icons.mode_edit_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        date,
                        style: TextStyle(
                            color: Color(0xff57A946),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
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
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            '${widget.title}',
            style: TextStyle(
                color: Color(0xff9DC75B),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ทำงาน',
                style: TextStyle(
                    color: Color(0xff464646),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${Value.toStringAsFixed(0)} %',
                style: TextStyle(
                    color: Color(0xff464646),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Slider(
                  value: Value,
                  max: 100,
                  divisions: 20,
                  label: Value.round().toString(),
                  onChanged: (widget.status == 3)
                      ? null
                      : (double value) {
                          if (value < Value) {
                            setState(() {
                              Value = widget.curValue;
                            });
                          } else {
                            setState(() {
                              Value = value;
                            });
                          }
                        },
                  activeColor: Color(0xff57A946),
                  inactiveColor: Color(0xffD6EFB4)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 0 ',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' 20 ',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' 40',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' 60',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' 80',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '100',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เพิ่มรูปภาพ',
                style: TextStyle(
                    color: Color(0xff464646),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.15,
              primary: false,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: (widget.status == 3)
                  ? List.generate(pic.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          // (pic[index].onApi == 1)
                          //     ? popPicApi(pic[index].j_img_install_name)
                          //     : popPicPre(pic[index].j_img_install_name);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: (pic[index].onApi == 1)
                              ? Image.network(
                                  '$api/${pic[index].j_img_install_name}', // this image doesn't exist
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,

                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.error_outline_rounded,
                                        size: 40,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : Image.file(
                                  File(pic[index].j_img_install_name),
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                        ),
                      );
                    })
                  : List.generate(pic.length + 1, (index) {
                      if (index > pic.length - 1) {
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
                                      setState(() {});
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                BottomSheetAction(
                                    title: Text('รูปภาพ'),
                                    onPressed: (context) {
                                      openImages().then((value) {
                                        setState(() {});
                                      });
                                      Navigator.pop(context);
                                    }),
                              ],
                              cancelAction: CancelAction(title: Text('ยกเลิก')),
                            );
                          },
                          child: Container(
                            // height: 20,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Color(0xff9DC75B)),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xffD6EFB4),
                                size: 60,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            // (pic[index].onApi == 1)
                            //     ? popPicApi(pic[index].j_img_install_name)
                            //     : popPicPre(pic[index].j_img_install_name);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: (pic[index].onApi == 1)
                                    ? Image.network(
                                        '$api/${pic[index].j_img_install_name}', // this image doesn't exist
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,

                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.error_outline_rounded,
                                              size: 40,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.green,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      )
                                    : Image.file(
                                        File(pic[index].j_img_install_name),
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (pic[index].onApi == 1) {
                                              deleteLs.add(
                                                  pic[index].j_img_install_id);
                                              pic.removeAt(index);
                                            } else {
                                              pic.removeAt(index);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(200),
                                              ),
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.close_rounded,
                                              size: 20,
                                              color: Colors.grey,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(index.toString()),
                                  // Text('${pic[index].j_img_id}')
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    })),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Text('หมายเหตุ',
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
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xffD6EFB4)),
                ),
                child: TextField(
                  onTapOutside: (b) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  // textInputAction: TextInputAction.done,
                  controller: remark,
                  readOnly: (widget.status == 3) ? true : false,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[300]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
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
                            if (pic.isEmpty) {
                              pop('กรุณาเพิ่มรูปอย่างน้อย 1 รูป');
                            } else {
                              loading();
                              loopdelete().then((del) {
                                loopupload().then((val) {
                                  updateRemark().then((va) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
                  ),
                ],
              ),
            ),
    );
  }
}

class Album {
  final int j_img_install_id;
  final String j_img_install_name;
  final int onApi;
  final String j_img_install_remark;
  final double? j_img_install_percent;

  const Album(
      {required this.j_img_install_id,
      required this.j_img_install_name,
      required this.onApi,
      required this.j_img_install_remark,
      required this.j_img_install_percent});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        j_img_install_id: json['j_img_install_id'],
        j_img_install_name: (json['j_img_install_name'].toString() == 'null')
            ? ""
            : json['j_img_install_name'],
        onApi: 1,
        j_img_install_remark:
            (json['j_img_install_remark'].toString() == 'null')
                ? ""
                : json['j_img_install_remark'],
        j_img_install_percent: json['j_img_install_percent']);
  }
}
