import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:egp_app/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class roofup extends StatefulWidget {
  @override
  _roofupState createState() => _roofupState();
  final int status;
  final int jidx;
  final String? problemId;
  final String userName;
  roofup(
      {required this.status,
      required this.problemId,
      required this.jidx,
      required this.userName});
}

class _roofupState extends State<roofup> {
  final ImagePicker imgpicker = ImagePicker();

  bool isLoading = true;
  var remarkproblem = TextEditingController();
  var remarkfix = TextEditingController();
  var picbefore = <Album>[];
  var picafter = <Album>[];
  List deleteLs = [];

  getRoofDetailById(id, pro, j_img_type) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/getRoofDetailById'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': id,
        'problem': pro,
        'j_img_type': j_img_type
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  loopdelete() async {
    for (var i = 0; i < deleteLs.length; i++) {
      print(deleteLs[i]);
      await deletePic(deleteLs[i]);
      // await Future.delayed(const Duration(seconds: 3));
    }
    return deleteLs.length;
  }

  deletePic(id) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/deleteImageProblem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'roofInstallId': id,
        'userName': widget.userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  loopuploadBefore() async {
    for (var i = 0; i < picbefore.length; i++) {
      if (picbefore[i].onApi == 0) {
        print(picbefore[i].j_img_roof_install_image);
        await uploadPic(File(picbefore[i].j_img_roof_install_image), 0,
            remarkproblem.text, remarkfix.text);
        // await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  loopuploadAfter() async {
    for (var i = 0; i < picafter.length; i++) {
      if (picafter[i].onApi == 0) {
        print(picafter[i].j_img_roof_install_image);
        await uploadPic(File(picafter[i].j_img_roof_install_image), 1,
            remarkproblem.text, remarkfix.text);
        // await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  updateRemark(id, proold, pronew, fix) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/updateJobImageProblem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "jidx": id,
        "problemOld": proold,
        "problem": pronew,
        "solution": fix,
        "userName": widget.userName
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    }
  }

  uploadPic(File? image, imgType, problem, solution) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImageProblem'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
    // request.fields['typeId'] = widget.typeId.toString();
    // request.fields['subTypeId'] = sub;
    // request.fields['groupNo'] = widget.group.toString();
    // request.fields['remark'] = '';
    request.fields['problem'] = problem;
    request.fields['solution'] = solution;
    request.fields['imgType'] = imgType.toString();
    // request.fields['sinsId'] = widget.sin.toString();

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
      print(value);
    });
    // print(response.body);
    // return response.body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.problemId == null) {
      setState(() {
        isLoading = false;
        // remarkproblem.text = widget.problemId ?? '';
      });
    } else {
      getRoofDetailById(widget.jidx, widget.problemId, null).then((before) {
        setState(() {
          isLoading = false;
          remarkproblem.text = widget.problemId ?? '';
          remarkfix.text = before[0]['j_img_roof_install_solution'] ?? '';
          List list = before; //json.decode(response.body);
          // var picdetail =
          //     list.map((m) => Album.fromJson(m)).toList();
          picbefore = list
              .map((m) => Album.fromJson(m))
              .toList()
              .where((element) => element.j_img_type == 0)
              .toList();

          picafter = list
              .map((m) => Album.fromJson(m))
              .toList()
              .where((element) => element.j_img_type == 1)
              .toList();
        });
      });
    }
  }

  openImages(after) async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(
          maxHeight: 1080, maxWidth: 1080, imageQuality: 50);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        // return pickedfiles;
        for (var i = 0; i < pickedfiles.length; i++) {
          (after == true)
              ? picafter.add(Album(
                  j_img_roof_install_id: 0,
                  j_img_roof_install_image: pickedfiles[i].path,
                  onApi: 0,
                  j_img_install_remark: '',
                  j_img_type: 1))
              : picbefore.add(Album(
                  j_img_roof_install_id: 0,
                  j_img_roof_install_image: pickedfiles[i].path,
                  onApi: 0,
                  j_img_install_remark: '',
                  j_img_type: 0));
        }
        // setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  openCamera(after) async {
    try {
      var pickedfile = await imgpicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 1080,
          maxWidth: 1080,
          imageQuality: 50);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfile != null) {
        // return pickedfile;
        (after == true)
            ? picafter.add(Album(
                j_img_roof_install_id: 0,
                j_img_roof_install_image: pickedfile.path,
                onApi: 0,
                j_img_install_remark: '',
                j_img_type: 1))
            : picbefore.add(Album(
                j_img_roof_install_id: 0,
                j_img_roof_install_image: pickedfile.path,
                onApi: 0,
                j_img_install_remark: '',
                j_img_type: 0));

        // setState(() {});

        // print("Image List Length:" + imagefiles!.length.toString());
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
                                  if (remarkproblem.text.isEmpty ||
                                      picbefore.isEmpty) {
                                    pop('กรุณากรอกปัญหาและอัพโหลดรูปอย่างน้อย 1 รูป');
                                  } else {
                                    loading();
                                    loopdelete().then((del) {
                                      loopuploadBefore().then((be) {
                                        loopuploadAfter().then((af) {
                                          updateRemark(
                                                  widget.jidx,
                                                  widget.problemId,
                                                  remarkproblem.text,
                                                  remarkfix.text)
                                              .then((up) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
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
                                      'ปัญหาและการแก้ไข',
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
                Column(
                  children: [
                    Row(
                      children: [
                        Text('ปัญหา',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xff2A302C))),
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
                        controller: remarkproblem,
                        readOnly: (widget.status == 3) ? true : false,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text('วิธีแก้ไข',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xff2A302C))),
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
                        controller: remarkfix,
                        readOnly: (widget.status == 3) ? true : false,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'รูปถ่ายก่อนซ่อม',
                      style: TextStyle(
                          color: Color(0xff464646),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1.15,
                    primary: false,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: (widget.status == 3)
                        ? List.generate(picbefore.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                // (picbefore[index].onApi == 1)
                                //     ? popPicbeforeApi(picbefore[index].j_img_roof_install_image)
                                //     : popPicbeforePre(picbefore[index].j_img_roof_install_image);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: (picbefore[index].onApi == 1)
                                    ? Image.network(
                                        '$api/${picbefore[index].j_img_roof_install_image}', // this image doesn't exist
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
                                        File(picbefore[index]
                                            .j_img_roof_install_image),
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                              ),
                            );
                          })
                        : List.generate(picbefore.length + 1, (index) {
                            if (index > picbefore.length - 1) {
                              return GestureDetector(
                                onTap: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    // title: const Text('Title'),
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                        title: Text('กล้อง'),
                                        onPressed: (context) {
                                          openCamera(false).then((value) {
                                            setState(() {});
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      BottomSheetAction(
                                          title: Text('รูปภาพ'),
                                          onPressed: (context) {
                                            openImages(false).then((value) {
                                              setState(() {});
                                            });
                                            Navigator.pop(context);
                                          }),
                                    ],
                                    cancelAction:
                                        CancelAction(title: Text('ยกเลิก')),
                                  );
                                },
                                child: Container(
                                  // height: 20,
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: Color(0xff9DC75B)),
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
                                  //     ? popPicApi(pic[index].j_img_roof_install_image)
                                  //     : popPicPre(pic[index].j_img_roof_install_image);
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: (picbefore[index].onApi == 1)
                                          ? Image.network(
                                              '$api/${picbefore[index].j_img_roof_install_image}', // this image doesn't exist
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,

                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.error_outline_rounded,
                                                    size: 40,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                );
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                              File(picbefore[index]
                                                  .j_img_roof_install_image),
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                            ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (picbefore[index].onApi ==
                                                      1) {
                                                    deleteLs.add(picbefore[
                                                            index]
                                                        .j_img_roof_install_id);
                                                    picbefore.removeAt(index);
                                                  } else {
                                                    picbefore.removeAt(index);
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(200),
                                                    ),
                                                    color: Colors.white
                                                        .withOpacity(0.7),
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
                //after

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'รูปถ่ายหลังซ่อม',
                      style: TextStyle(
                          color: Color(0xff464646),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1.15,
                    primary: false,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: (widget.status == 3)
                        ? List.generate(picafter.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                // (picafter[index].onApi == 1)
                                //     ? popPicafterApi(picafter[index].j_img_roof_install_image)
                                //     : popPicafterPre(picafter[index].j_img_roof_install_image);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: (picafter[index].onApi == 1)
                                    ? Image.network(
                                        '$api/${picafter[index].j_img_roof_install_image}', // this image doesn't exist
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
                                        File(picafter[index]
                                            .j_img_roof_install_image),
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                              ),
                            );
                          })
                        : List.generate(picafter.length + 1, (index) {
                            if (index > picafter.length - 1) {
                              return GestureDetector(
                                onTap: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    // title: const Text('Title'),
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                        title: Text('กล้อง'),
                                        onPressed: (context) {
                                          openCamera(true).then((value) {
                                            setState(() {});
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      BottomSheetAction(
                                          title: Text('รูปภาพ'),
                                          onPressed: (context) {
                                            openImages(true).then((value) {
                                              setState(() {});
                                            });
                                            Navigator.pop(context);
                                          }),
                                    ],
                                    cancelAction:
                                        CancelAction(title: Text('ยกเลิก')),
                                  );
                                },
                                child: Container(
                                  // height: 20,
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: Color(0xff9DC75B)),
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
                                  //     ? popPicApi(pic[index].j_img_roof_install_image)
                                  //     : popPicPre(pic[index].j_img_roof_install_image);
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: (picafter[index].onApi == 1)
                                          ? Image.network(
                                              '$api/${picafter[index].j_img_roof_install_image}', // this image doesn't exist
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,

                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.error_outline_rounded,
                                                    size: 40,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                );
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                              File(picafter[index]
                                                  .j_img_roof_install_image),
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                            ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (picafter[index].onApi ==
                                                      1) {
                                                    deleteLs.add(picafter[index]
                                                        .j_img_roof_install_id);
                                                    picafter.removeAt(index);
                                                  } else {
                                                    picafter.removeAt(index);
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(200),
                                                    ),
                                                    color: Colors.white
                                                        .withOpacity(0.7),
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
              ],
            ),
          );
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
}

class Album {
  final int j_img_roof_install_id;
  final String j_img_roof_install_image;
  final int onApi;
  final String j_img_install_remark;
  final int j_img_type;

  const Album(
      {required this.j_img_roof_install_id,
      required this.j_img_roof_install_image,
      required this.onApi,
      required this.j_img_install_remark,
      required this.j_img_type});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        j_img_roof_install_id: json['j_img_roof_install_id'],
        j_img_roof_install_image:
            (json['j_img_roof_install_image'].toString() == 'null')
                ? ""
                : json['j_img_roof_install_image'],
        onApi: 1,
        j_img_install_remark: "",
        j_img_type: json['j_img_type']);
  }
}
