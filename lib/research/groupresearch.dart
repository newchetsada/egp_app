import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:egp_app/config.dart';

class groupresearch extends StatefulWidget {
  @override
  _groupresearchState createState() => _groupresearchState();

  final int jidx;
  final int typeId;
  final String typeName;
  final int status;

  groupresearch(
      {required this.jidx,
      required this.typeId,
      required this.typeName,
      required this.status});
}

class _groupresearchState extends State<groupresearch> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  var groupSub = <SubLs>[];

  var pic = <Album>[];
  var remark = TextEditingController();
  List deleteLs = [];

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

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(
          maxHeight: 1080, maxWidth: 1080, imageQuality: 50);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        // return pickedfiles;
        for (var i = 0; i < pickedfiles.length; i++) {
          pic.add(Album(
              j_img_id: 0,
              j_img_name: pickedfiles[i].path,
              onApi: 0,
              remark: ''));
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
            j_img_id: 0, j_img_name: pickedfile.path, onApi: 0, remark: ''));

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

  uploadPic(File image, sub) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
    request.fields['imgType'] = '0';
    request.fields['typeId'] = widget.typeId.toString();
    request.fields['subTypeId'] = sub;
    request.fields['imgDesId'] = '';
    request.fields['groupNo'] = '1';
    request.fields['remark'] = '';
    request.fields['accessories'] = '';
    request.fields['sign_name'] = '';
    request.fields['userName'] = userName;
    request.fields['filesName'] = image.path.split('/').last;

    request.files.add(http.MultipartFile.fromBytes(
        'files', image.readAsBytesSync(),
        filename: image.path.split('/').last));

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    // print(response.body);
    // return response.body;
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

  updateRemark(id, type, sub, note) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/updateJobDetailInGroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': id,
        'groupNo': 1,
        'imgType': 0,
        'typeId': type,
        'subTypeId': sub,
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
    if (widget.typeId != 13) {
      API.getSubLs(widget.jidx, widget.typeId).then((response) {
        setState(() {
          List list = json.decode(response.body);
          groupSub = list.map((m) => SubLs.fromJson(m)).toList();
          // contactloading = false;
        });
      });
    } else {
      API.getPicLs(widget.jidx, widget.typeId, null).then((response) {
        // print(response.body);
        setState(() {
          List list = json.decode(response.body);
          pic = list.map((m) => Album.fromJson(m)).toList();
          if (pic.isEmpty) {
            remark.text = '';
          } else {
            remark.text = pic[0].remark;
          }
        });
      });
    }
  }

  loopupload(subid) async {
    for (var i = 0; i < pic.length; i++) {
      if (pic[i].onApi == 0) {
        print(pic[i].j_img_name);
        await uploadPic(File(pic[i].j_img_name), subid.toString());
        // await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  loopdelete() async {
    for (var i = 0; i < deleteLs.length; i++) {
      print(deleteLs[i]);
      await deletePic(deleteLs[i]);
      // await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              if (widget.typeId == 13) {
                                loading();
                                loopdelete().then((value) {
                                  loopupload("").then((value) {
                                    updateRemark(widget.jidx, widget.typeId,
                                            null, remark.text)
                                        .then((value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  });
                                });
                              } else {
                                Navigator.pop(context);
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
                        Text(widget.typeName,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.typeName,
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
        body: (widget.typeId == 13)
            ? ListView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                children: [
                  GridView.count(
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
                                  //     ? popPicApi(pic[index].j_img_name)
                                  //     : popPicPre(pic[index].j_img_name);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: (pic[index].onApi == 1)
                                      ? Image.network(
                                          '$api/${pic[index].j_img_name}', // this image doesn't exist
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
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
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
                                          File(pic[index].j_img_name),
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
                                    //     ? popPicApi(pic[index].j_img_name)
                                    //     : popPicPre(pic[index].j_img_name);
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: (pic[index].onApi == 1)
                                            ? Image.network(
                                                '$api/${pic[index].j_img_name}', // this image doesn't exist
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: double.infinity,

                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons
                                                          .error_outline_rounded,
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
                                                File(pic[index].j_img_name),
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
                                                    if (pic[index].onApi == 1) {
                                                      deleteLs.add(
                                                          pic[index].j_img_id);
                                                      pic.removeAt(index);
                                                    } else {
                                                      pic.removeAt(index);
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
                  Row(
                    children: [
                      Text('หมายเหตุ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff9DC75B))),
                    ],
                  ),
                  Container(
                    // height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xffAED76E)),
                    ),
                    child: TextField(
                      onTapOutside: (b) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: remark,
                      // textInputAction: TextInputAction.done,
                      readOnly: (widget.status == 3) ? true : false,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Color(0xffAED76E),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemCount: groupSub.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: GestureDetector(
                        onTap: () {
                          loading();
                          API
                              .getPicLs(widget.jidx, widget.typeId,
                                  groupSub[index].sub_type_id)
                              .then((response) {
                            // print(response.body);
                            setState(() {
                              List list = json.decode(response.body);
                              pic = list.map((m) => Album.fromJson(m)).toList();
                              if (pic.isEmpty) {
                                remark.text = '';
                              } else {
                                remark.text = pic[0].remark;
                              }
                            });
                            Navigator.pop(context);
                            addSheet(groupSub[index].sub_type_name,
                                groupSub[index].sub_type_id);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Color(0xff9DC75B), width: 0.5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          groupSub[index].sub_type_name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xff57A946),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'รูปทั้งหมด  ${groupSub[index].amount_pic}',
                                          style: TextStyle(
                                              color: Color(0xff9DC75B),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    EvaIcons.checkmarkCircle2,
                                    size: 30,
                                    color: (groupSub[index].amount_pic > 0)
                                        ? Color(0xffABD06F)
                                        : Color.fromARGB(255, 211, 211, 211),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
                })));
  }

  void addSheet(title, subb) {
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
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff149C32))),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                                          //     ? popPicApi(
                                          //         pic[index].j_img_name)
                                          //     : popPicPre(
                                          //         pic[index].j_img_name);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          child: (pic[index].onApi == 1)
                                              ? Image.network(
                                                  '$api/${pic[index].j_img_name}', // this image doesn't exist
                                                  fit: BoxFit.cover,
                                                  height: double.infinity,
                                                  width: double.infinity,

                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Center(
                                                      child: Icon(
                                                        Icons
                                                            .error_outline_rounded,
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
                                                    if (loadingProgress ==
                                                        null) {
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
                                                  File(pic[index].j_img_name),
                                                  fit: BoxFit.cover,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                ),
                                        ),
                                      );
                                    })
                                  : (pic.length > 0)
                                      ? List.generate(pic.length + 1, (index) {
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
                                                        openCamera()
                                                            .then((value) {
                                                          // imagefiles.add(value);
                                                          mystate(() {});
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    BottomSheetAction(
                                                        title: Text('รูปภาพ'),
                                                        onPressed: (context) {
                                                          openImages()
                                                              .then((value) {
                                                            // imagefiles
                                                            //     .addAll(value);
                                                            mystate(() {});
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ],
                                                  cancelAction: CancelAction(
                                                      title: Text('ยกเลิก')),
                                                );
                                              },
                                              child: Container(
                                                // height: 20,
                                                // width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Color(0xff9DC75B)),
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
                                                //     ? popPicApi(
                                                //         pic[index].j_img_name)
                                                //     : popPicPre(
                                                //         pic[index].j_img_name);
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: (pic[index].onApi ==
                                                            1)
                                                        ? Image.network(
                                                            '$api/${pic[index].j_img_name}', // this image doesn't exist
                                                            fit: BoxFit.cover,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,

                                                            errorBuilder:
                                                                (context, error,
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
                                                            loadingBuilder:
                                                                (BuildContext
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
                                                            File(pic[index]
                                                                .j_img_name),
                                                            fit: BoxFit.cover,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              mystate(() {
                                                                if (pic[index]
                                                                        .onApi ==
                                                                    1) {
                                                                  deleteLs.add(pic[
                                                                          index]
                                                                      .j_img_id);
                                                                  pic.removeAt(
                                                                      index);
                                                                } else {
                                                                  pic.removeAt(
                                                                      index);
                                                                }
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
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
                                                                  size: 20,
                                                                  color: Colors
                                                                      .grey,
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
                                        })
                                      : <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: <BottomSheetAction>[
                                                  BottomSheetAction(
                                                    title: Text('กล้อง'),
                                                    onPressed: (context) {
                                                      openCamera()
                                                          .then((value) {
                                                        // imagefiles.add(value);
                                                        mystate(() {});
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  BottomSheetAction(
                                                      title: Text('รูปภาพ'),
                                                      onPressed: (context) {
                                                        openImages()
                                                            .then((value) {
                                                          // imagefiles.addAll(value);
                                                          mystate(() {});
                                                        });
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                                cancelAction: CancelAction(
                                                    title: Text('ยกเลิก')),
                                              );
                                            },
                                            child: Container(
                                              // height: 20,
                                              // width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Color(0xff9DC75B)),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Color(0xffD6EFB4),
                                                  size: 60,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                            )),
                        Row(
                          children: [
                            Text('หมายเหตุ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Color(0xff9DC75B))),
                          ],
                        ),
                        Container(
                          // height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffAED76E)),
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
                              hintStyle: TextStyle(fontSize: 14),
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
                                      // Navigator.pop(context);
                                      loading();
                                      loopdelete().then((value) {
                                        loopupload(subb).then((value) {
                                          updateRemark(
                                                  widget.jidx,
                                                  widget.typeId,
                                                  subb,
                                                  remark.text)
                                              .then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        });
                                      });
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        }).then((value) {
      setState(() {
        API.getSubLs(widget.jidx, widget.typeId).then((response) {
          setState(() {
            List list = json.decode(response.body);
            groupSub = list.map((m) => SubLs.fromJson(m)).toList();
            // contactloading = false;
          });
        });
      });
    });
  }
}

//api
class API {
  static Future getSubLs(idd, type) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobGroupSurveyImageLs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{'jidx': idd, 'typeId': type}),
    );
    return response;
  }

  static Future getPicLs(idd, type, sub) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobGroupDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': idd,
        'groupNo': 1,
        'imgType': 0,
        'typeId': type,
        'subTypeId': sub
      }),
    );
    return response;
  }
}

class SubLs {
  final int sub_type_id;
  final String sub_type_name;
  final int amount_pic;

  const SubLs({
    required this.sub_type_id,
    required this.sub_type_name,
    required this.amount_pic,
  });

  factory SubLs.fromJson(Map<String, dynamic> json) {
    return SubLs(
      sub_type_id: json['sub_type_id'],
      sub_type_name: json['sub_type_name'],
      amount_pic: json['amount_pic'],
    );
  }
}

class Album {
  final int j_img_id;
  final String j_img_name;
  final int onApi;
  final String remark;

  const Album(
      {required this.j_img_id,
      required this.j_img_name,
      required this.onApi,
      required this.remark});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      j_img_id: json['j_img_id'],
      j_img_name:
          (json['j_img_name'].toString() == 'null') ? "" : json['j_img_name'],
      onApi: 1,
      remark: (json['j_img_remark'].toString() == 'null')
          ? ""
          : json['j_img_remark'],
    );
  }
}
