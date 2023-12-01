import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:egp_app/config.dart';

// import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class cleanphotopage extends StatefulWidget {
  @override
  _cleanphotopageState createState() => _cleanphotopageState();
  final int type;
  final int limit;
  final int jidx;
  final int status;
  const cleanphotopage(
      {super.key,
      required this.type,
      required this.limit,
      required this.jidx,
      required this.status});
}

class _cleanphotopageState extends State<cleanphotopage> {
  //img
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  XFile? imagefilesone;
  // Uint8List webImage = Uint8List(8);

  String userName = "Loading...";
  int? iduser;

  var remark = TextEditingController();

  int limitFile = 0;
  List deleteLs = [];

  var pic = <Album>[];
  var picEx = <ExPic>[];
  bool isLoading = true;

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

  // void popPicApi(path) {
  //   showDialog<void>(
  //     context: context,
  //     // barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.all(0),
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10))),
  //         content: SingleChildScrollView(
  //             child: Center(
  //           child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Image.network('$api/$path')),
  //         )),
  //       );
  //     },
  //   );
  // }

  // void popPicPre(file) {
  //   showDialog<void>(
  //     context: context,
  //     // barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       // return PinchZoom(
  //       //   child: Image.file(
  //       //     File(file),
  //       //   ),
  //       //   resetDuration: const Duration(milliseconds: 100),
  //       //   maxScale: 2.5,
  //       //   onZoomStart: () {
  //       //     print('Start zooming');
  //       //   },
  //       //   onZoomEnd: () {
  //       //     print('Stop zooming');
  //       //   },
  //       // );
  //       return AlertDialog(
  //           contentPadding: EdgeInsets.all(0),
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10))),
  //           content: SingleChildScrollView(
  //             child: Center(
  //                 child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Image.file(
  //                 File(file),
  //               ),
  //             )),
  //           ));
  //     },
  //   );
  // }

  void limitpop(total) {
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
            child: Column(
              children: [
                Text(
                  'จำนวนรูปเกิน',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff57A946)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'สามารถเพิ่มรูปได้อีก $total รูป',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 2,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff464646)),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'กลับ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff464646)),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // openImages() async {
  //   try {
  //     var pickedfiles = await imgpicker.pickMultiImage();
  //     //you can use ImageCourse.camera for Camera capture
  //     if (pickedfiles != null) {
  //       if (pickedfiles.length > limitFile - pic.length) {
  //         limitpop(limitFile - pic.length);
  //       } else {
  //         // imagefiles.addAll(pickedfiles);
  //         imagefilesone = pickedfiles[0];
  //         // webImage = await pickedfiles[0].readAsBytes();
  //         for (var i = 0; i < pickedfiles.length; i++) {
  //           // pic.add(Album(
  //           //     j_img_id: 0,
  //           //     j_img_name: pickedfiles[i].path,
  //           //     onApi: 0,
  //           //     remark: ''));
  //         }
  //       }

  //       setState(() {});

  //       print("Image List Length:" + pickedfiles.length.toString());
  //     } else {
  //       print("No image is selected.");
  //     }
  //   } catch (e) {
  //     print("error while picking file.");
  //   }
  // }
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

  uploadPic(File image, id) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/mobile/uploadJobImageCleaning'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jImgId'] = id.toString();
    // request.fields['imgType'] = widget.type.toString();
    // request.fields['typeId'] = '';
    // request.fields['subTypeId'] = '';
    // request.fields['imgDesId'] = '';
    // request.fields['groupNo'] = '1';
    // request.fields['remark'] = '';
    // request.fields['accessories'] = '';
    // request.fields['sign_name'] = '';
    request.fields['userName'] = userName;
    request.fields['filesName'] = image.path.split('/').last;

    request.files.add(http.MultipartFile.fromBytes(
        'files', image.readAsBytesSync(),
        filename: image.path.split('/').last));

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print('uploadpic : ${value}');
    });
    // print(response.body);
    // return response.body;
  }

  deletePic(id) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/deleteJobImageCleaning'),
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

  updateRemark(id, type, note) async {
    print('remark');
    var response = await http.post(
      Uri.parse('$api/api/mobile/updateJobDetailInGroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': id,
        'groupNo': 1,
        'imgType': type,
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    setState(() {
      limitFile = widget.limit;
    });
    getUser().then((value) {
      API.getPicLs(widget.jidx, widget.type).then((response) {
        // print(response.body);
        setState(() {
          List list = json.decode(response.body);
          pic = list.map((m) => Album.fromJson(m)).toList();
          if (pic.isEmpty) {
            remark.text = '';
          } else {
            remark.text = pic[0].remark;
          }

          // isLoading = false;
        });
      }).then((value) {
        API.getPicExLs(widget.jidx).then((ex) {
          setState(() {
            List list2 = json.decode(ex.body);
            picEx = list2.map((m) => ExPic.fromJson(m)).toList();

            isLoading = false;
          });
        });
      });
    });
  }

  loopupload() async {
    for (var i = 0; i < pic.length; i++) {
      if (pic[i].onApi == 0 && pic[i].j_img_name.isNotEmpty) {
        print(pic[i].j_img_name);
        await uploadPic(File(pic[i].j_img_name), pic[i].j_img_id);
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
                                  loading();
                                  loopdelete().then((value) {
                                    loopupload().then((value) {
                                      updateRemark(widget.jidx, widget.type,
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
                            Text(
                                (widget.type == 2)
                                    ? 'แจ้งซ่อม'
                                    : (widget.type == 0)
                                        ? 'ถ่ายรูป ก่อนล้างแผง'
                                        : 'ถ่ายรูป หลังล้างแผง',
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
                                      (widget.type == 0)
                                          ? 'รูปถ่ายก่อนล้างแผง'
                                          : 'รูปถ่ายหลังล้างแผง',
                                      style: TextStyle(
                                          color: Color(0xff9DC75B),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       var test = pic
                                    //           .where((e) =>
                                    //               e.j_img_name.isNotEmpty)
                                    //           .length;
                                    //       print(test);

                                    //       // for (var element in pic) {
                                    //       //   if (element.j_img_name.isNotEmpty){
                                    //       //     count++;
                                    //       //   }
                                    //       // }
                                    //     },
                                    //     icon: Icon(Icons.abc))
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
              // leading: IconButton(
              //     splashRadius: 10,
              //     color: Color(0xff57A946),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     icon: Icon(Icons.arrow_back)),
              // title: Text(
              //   (widget.type == 2)
              //       ? 'แจ้งซ่อม'
              //       : (widget.type == 0)
              //           ? 'ถ่ายรูป ก่อนล้างแผง'
              //           : 'ถ่ายรูป หลังล้างแผง',
              //   style: TextStyle(
              //       fontWeight: FontWeight.w600,
              //       fontSize: 19,
              //       color: Color(0xff57A946)),
              // ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (picEx.isEmpty)
                        ? AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/nolayer.png',
                                fit: BoxFit.cover,
                              ),
                            ))
                        : AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ListView.builder(
                              itemCount: picEx.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: (index == 0) ? 0 : 10),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 11,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: (picEx[index]
                                                .j_img_cleaning_des
                                                .isEmpty)
                                            ? Colors.transparent
                                            : Color(0xffEDFAEA),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => Dialog(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: PhotoView(
                                                              tightMode: true,
                                                              minScale: 0.25,
                                                              backgroundDecoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .transparent),
                                                              imageProvider:
                                                                  NetworkImage(
                                                                      '$api/${picEx[index].j_img_cleaning_name}'),
                                                            )));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '$api/${picEx[index].j_img_cleaning_name}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      picEx[index]
                                                          .j_img_cleaning_des,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xff2A302C))),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       vertical: 5),
                                          //   child: Expanded(
                                          //     child: Row(
                                          //       children: [
                                          //         Text(
                                          //             // widget.sitepic[index]
                                          //             //         ['site_img_des'] ??
                                          //             'fwagfsebgifuoasjpkugykuguviohovigydfisuhigyfdusijdhguiyidfsjihgd',
                                          //             overflow: TextOverflow.ellipsis,
                                          //             style: TextStyle(
                                          //                 fontWeight: FontWeight.w500,
                                          //                 fontSize: 14,
                                          //                 color: Color(0xff2A302C))),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${pic.where((e) => e.j_img_name.isNotEmpty).length}/$limitFile',
                            style: TextStyle(
                                color: Color(0xff9DC75B),
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 1.1,
                        primary: false,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: List.generate(pic.length, (index) {
                          return GestureDetector(
                            onTap: (widget.status == 3)
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            child: PhotoView(
                                              tightMode: true,
                                              minScale: 0.25,
                                              backgroundDecoration:
                                                  BoxDecoration(
                                                      color:
                                                          Colors.transparent),
                                              imageProvider: NetworkImage(
                                                  '$api/${pic[index].j_img_name}'),
                                            )));
                                  }
                                : () {
                                    (pic[index].j_img_name.isEmpty)
                                        ? showAdaptiveActionSheet(
                                            context: context,
                                            // title: const Text('Title'),
                                            actions: <BottomSheetAction>[
                                              BottomSheetAction(
                                                title: Text('Camera'),
                                                onPressed: (context) {
                                                  openCamera().then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        pic[index].j_img_name =
                                                            value.path;
                                                        pic[index].onApi = 0;
                                                      });
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              BottomSheetAction(
                                                  title: Text('Photos'),
                                                  onPressed: (context) {
                                                    openPhoto().then((value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          pic[index]
                                                                  .j_img_name =
                                                              value.path;
                                                          pic[index].onApi = 0;
                                                        });
                                                      }
                                                    });

                                                    Navigator.pop(context);
                                                  }),
                                            ],
                                            cancelAction: CancelAction(
                                                title: Text('Cancel')),
                                          )
                                        : (pic[index].onApi == 1)
                                            ? showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: PhotoView(
                                                      tightMode: true,
                                                      minScale: 0.25,
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                              color: Colors
                                                                  .transparent),
                                                      imageProvider: NetworkImage(
                                                          '$api/${pic[index].j_img_name}'),
                                                    )))
                                            : showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: PhotoView(
                                                      tightMode: true,
                                                      minScale: 0.25,
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                              color: Colors
                                                                  .transparent),
                                                      imageProvider: FileImage(
                                                          File(pic[index]
                                                              .j_img_name)),
                                                    )));
                                  },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: (pic[index].j_img_name.isEmpty)
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
                                                (pic[index]
                                                        .j_img_name
                                                        .isNotEmpty)
                                                    ? (pic[index].onApi == 1)
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
                                                          )
                                                    : Container()),
                                        (pic[index].j_img_name.isNotEmpty)
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
                                                              setState(() {
                                                                if (pic[index]
                                                                        .onApi ==
                                                                    1) {
                                                                  deleteLs.add(pic[
                                                                          index]
                                                                      .j_img_id);
                                                                  print(
                                                                      deleteLs);
                                                                }
                                                                pic[index]
                                                                    .j_img_name = '';
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Container(
                                                                height: 20,
                                                                width: 20,
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
                                  padding: const EdgeInsets.only(
                                      top: 5, right: 5, left: 5),
                                  child: Text(pic[index].cleaning_des_name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Color(0xff2A302C))),
                                ),
                              ],
                            ),
                          );
                        })),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'หมายเหตุ',
                            style: TextStyle(
                                color: Color(0xff9DC75B),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              // height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: TextField(
                                controller: remark,
                                // textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: 3,
                                readOnly: (widget.status == 3) ? true : false,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Color(0xff003175),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  // Widget add() {
  //   return GestureDetector(
  //     onTap: () {
  //       showAdaptiveActionSheet(
  //         context: context,
  //         // title: const Text('Title'),
  //         actions: <BottomSheetAction>[
  //           BottomSheetAction(
  //             title: Text('Camera'),
  //             onPressed: (context) {
  //               openCamera();
  //               Navigator.pop(context);
  //             },
  //           ),
  //           BottomSheetAction(
  //               title: Text('Photos'),
  //               onPressed: (context) {
  //                 openImages();
  //                 Navigator.pop(context);
  //               }),
  //         ],
  //         cancelAction: CancelAction(title: Text('Cancel')),
  //       );
  //     },
  //     child: Container(
  //       // height: 20,
  //       // width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Color(0xffffffff),
  //         borderRadius: BorderRadius.circular(15),
  //         border: Border.all(color: Color(0xffAED76E)),
  //       ),
  //       child: Center(
  //         child: Icon(
  //           Icons.add,
  //           color: Color(0xffD6EFB4),
  //           size: 50,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

//api
class API {
  static Future getPicLs(idd, type) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobGroupDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': idd,
        'groupNo': 1,
        'imgType': type,
        'typeId': null
      }),
    );
    return response;
  }

  static Future getPicExLs(idd) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getCleaningLocation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': idd,
      }),
    );
    return response;
  }
}

class Album {
  final int j_img_id;
  String j_img_name;
  int onApi;
  final String remark;
  final String cleaning_des_name;

  Album(
      {required this.j_img_id,
      required this.j_img_name,
      required this.onApi,
      required this.remark,
      required this.cleaning_des_name});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        j_img_id: json['j_img_id'],
        j_img_name:
            (json['j_img_name'].toString() == 'null') ? "" : json['j_img_name'],
        onApi: 1,
        remark: (json['j_img_remark'].toString() == 'null')
            ? ""
            : json['j_img_remark'],
        cleaning_des_name: json['cleaning_des_name'] ?? '');
  }
}

class ExPic {
  final int j_img_cleaning_id;
  final String j_img_cleaning_name;
  final String j_img_cleaning_des;

  ExPic(
      {required this.j_img_cleaning_id,
      required this.j_img_cleaning_name,
      required this.j_img_cleaning_des});

  factory ExPic.fromJson(Map<String, dynamic> json) {
    return ExPic(
        j_img_cleaning_id: json['j_img_cleaning_id'],
        j_img_cleaning_name: json['j_img_cleaning_name'] ?? '',
        j_img_cleaning_des: json['cleaningj_img_cleaning_des_des_name'] ?? '');
  }
}
