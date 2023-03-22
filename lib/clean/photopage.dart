import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:http/http.dart' as http;

// import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:lottie/lottie.dart';

class photopage extends StatefulWidget {
  @override
  _photopageState createState() => _photopageState();
  final int type;
  final int limit;
  final int jidx;
  const photopage(
      {super.key, required this.type, required this.limit, required this.jidx});
}

class _photopageState extends State<photopage> {
  //img
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  XFile? imagefilesone;
  Uint8List webImage = Uint8List(8);

  int limitFile = 0;
  List deleteLs = [];
  String pathPic = 'https://backoffice.energygreenplus.co.th/';
  var pic = <Album>[];

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
                      color: Color(0xff149C32)),
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

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        if (pickedfiles.length > limitFile - pic.length) {
          limitpop(limitFile - pic.length);
        } else {
          // imagefiles.addAll(pickedfiles);
          imagefilesone = pickedfiles[0];
          webImage = await pickedfiles[0].readAsBytes();
          for (var i = 0; i < pickedfiles.length; i++) {
            pic.add(
                Album(j_img_id: 0, j_img_name: pickedfiles[i].path, onApi: 0));
          }
        }

        setState(() {});

        print("Image List Length:" + pickedfiles.length.toString());
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
      //you can use ImageCourse.camera for Camera capture
      if (pickedfile != null) {
        // imagefiles.add(pickedfile);
        print(pickedfile.path);
        pic.add(Album(j_img_id: 0, j_img_name: pickedfile.path, onApi: 0));

        setState(() {});

        // print("Image List Length:" + imagefiles!.length.toString());
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  uploadPic(File image) async {
    // var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // var length = await image.length();
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString();
    request.fields['imgType'] = widget.type.toString();
    request.fields['typeId'] = '';
    request.fields['subTypeId'] = '';
    request.fields['imgDesId'] = '';
    request.fields['groupNo'] = '1';
    request.fields['remark'] = '';
    request.fields['sign_name'] = '';
    request.fields['sign_name'] = '';
    request.fields['userName'] = 'admintest';
    request.fields['filesName'] = image.path.split('/').last;

    request.files.add(http.MultipartFile.fromBytes(
        'files', image.readAsBytesSync(),
        filename: image.path.split('/').last));

    // http.Response response =
    //     await http.Response.fromStream(await request.send());
    var response = await request.send();
    // print(response.);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    // print(response.body);
    // return response.body;
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    setState(() {
      limitFile = widget.limit;
    });
    API.getPicLs(widget.jidx, widget.type).then((response) {
      print(response.body);
      setState(() {
        List list = json.decode(response.body);
        pic = list.map((m) => Album.fromJson(m)).toList();

        // isLoading = false;
      });
    });
  }

  loopupload() async {
    for (var i = 0; i < pic.length; i++) {
      if (pic[i].onApi == 0) {
        print(pic[i].j_img_name);
        // uploadPic(File(pic[i].j_img_name));
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                        // Navigator.pop(context);
                        loading();
                        print(deleteLs);
                        // for (var i = 0; i < pic.length; i++) {
                        //   if (pic[i].onApi == 0) {
                        //     print(pic[i].j_img_name);
                        //     // uploadPic(File(pic[i].j_img_name));
                        //   }
                        //   Future.delayed(const Duration(seconds: 3));
                        // }
                        loopupload().then((value) {
                          print('ok');
                          Navigator.pop(context);
                        });

                        // print(pic[3].j_img_name);

                        // Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff149C32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'บันทึก',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: Color(0xff149C32),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            (widget.type == 2)
                ? 'แจ้งซ่อม'
                : (widget.type == 0)
                    ? 'ถ่ายรูป ก่อนล้างแผง'
                    : 'ถ่ายรูป หลังล้างแผง',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff149C32)),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'รูปถ่ายก่อนล้างแผง',
                      style: TextStyle(
                          color: Color(0xff003175),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      (pic == null)
                          ? '0/$limitFile'
                          : '${pic.length}/$limitFile',
                      style: TextStyle(
                          color: Color(0xff149C32),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                //new test
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 1.3,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: (pic.length != null)
                          ? (pic.length == limitFile)
                              ? List.generate(pic.length, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: (pic[index].onApi == 1)
                                              ? Image.network(
                                                  '$pathPic${pic[index].j_img_name}', // this image doesn't exist
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
                                                      if (pic[index].onApi ==
                                                          1) {
                                                        deleteLs.add(pic[index]
                                                            .j_img_id);
                                                        pic.removeAt(index);
                                                      } else {
                                                        pic.removeAt(index);
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
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
                                })
                              : List.generate(pic.length + 1, (index) {
                                  if (index > pic.length - 1) {
                                    return add();
                                  } else {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: (pic[index].onApi == 1)
                                                ? Image.network(
                                                    '$pathPic${pic[index].j_img_name}', // this image doesn't exist
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                    width: double.infinity,

                                                    errorBuilder: (context,
                                                        error, stackTrace) {
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
                                                        if (pic[index].onApi ==
                                                            1) {
                                                          deleteLs.add(
                                                              pic[index]
                                                                  .j_img_id);
                                                          pic.removeAt(index);
                                                        } else {
                                                          pic.removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                200),
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
                                })
                          : <Widget>[
                              add(),
                            ],
                    )),
                // Padding(
                //     padding: const EdgeInsets.only(top: 20, bottom: 20),
                //     child: GridView.count(
                //       shrinkWrap: true,
                //       childAspectRatio: 1.3,
                //       primary: false,
                //       crossAxisSpacing: 10,
                //       mainAxisSpacing: 10,
                //       crossAxisCount: 2,
                //       children: (imagefiles.length != null)
                //           ? (imagefiles.length == limitFile)
                //               ? List.generate(imagefiles.length, (index) {
                //                   return Container(
                //                     decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                         image: FileImage(
                //                           File(imagefiles[index].path),
                //                         ),
                //                         fit: BoxFit.cover,
                //                       ),
                //                       color: Color(0xffffffff),
                //                       borderRadius: BorderRadius.circular(10),
                //                       border:
                //                           Border.all(color: Color(0xffF1FAEF)),
                //                     ),
                //                     child: Column(
                //                       children: [
                //                         Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.end,
                //                           children: [
                //                             GestureDetector(
                //                               onTap: () {
                //                                 setState(() {
                //                                   imagefiles.removeAt(index);
                //                                 });
                //                               },
                //                               child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.all(10),
                //                                 child: Container(
                //                                   height: 25,
                //                                   width: 25,
                //                                   decoration: BoxDecoration(
                //                                     // border: Border.all(
                //                                     //     width: 1,
                //                                     //     color: Colors.grey),
                //                                     borderRadius:
                //                                         BorderRadius.all(
                //                                       Radius.circular(200),
                //                                     ),
                //                                     color: Colors.white
                //                                         .withOpacity(0.7),
                //                                   ),
                //                                   child: Center(
                //                                       child: Icon(
                //                                     Icons.close_rounded,
                //                                     size: 20,
                //                                     color: Colors.grey,
                //                                   )),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ],
                //                     ),
                //                   );
                //                 })
                //               : List.generate(imagefiles.length + 1, (index) {
                //                   if (index > imagefiles.length - 1) {
                //                     return add();
                //                   } else {
                //                     return Container(
                //                       decoration: BoxDecoration(
                //                         image: DecorationImage(
                //                           image: FileImage(
                //                             File(imagefiles[index].path),
                //                           ),
                //                           fit: BoxFit.cover,
                //                         ),
                //                         color: Color(0xffffffff),
                //                         borderRadius: BorderRadius.circular(10),
                //                         border: Border.all(
                //                             color: Color(0xffF1FAEF)),
                //                       ),
                //                       child: Column(
                //                         children: [
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.end,
                //                             children: [
                //                               GestureDetector(
                //                                 onTap: () {
                //                                   setState(() {
                //                                     imagefiles.removeAt(index);
                //                                   });
                //                                 },
                //                                 child: Padding(
                //                                   padding:
                //                                       const EdgeInsets.all(10),
                //                                   child: Container(
                //                                     height: 25,
                //                                     width: 25,
                //                                     decoration: BoxDecoration(
                //                                       // border: Border.all(
                //                                       //     width: 1,
                //                                       //     color: Colors.grey),
                //                                       borderRadius:
                //                                           BorderRadius.all(
                //                                         Radius.circular(200),
                //                                       ),
                //                                       color: Colors.white
                //                                           .withOpacity(0.7),
                //                                     ),
                //                                     child: Center(
                //                                         child: Icon(
                //                                       Icons.close_rounded,
                //                                       size: 20,
                //                                       color: Colors.grey,
                //                                     )),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ],
                //                       ),
                //                     );
                //                   }
                //                 })
                //           : <Widget>[
                //               add(),
                //             ],
                //     )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        // height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: TextField(
                          // textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'หมายเหตุ',
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
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget add() {
    return GestureDetector(
      onTap: () {
        showAdaptiveActionSheet(
          context: context,
          // title: const Text('Title'),
          actions: <BottomSheetAction>[
            BottomSheetAction(
              title: Text('Camera'),
              onPressed: (context) {
                openCamera();
                Navigator.pop(context);
              },
            ),
            BottomSheetAction(
                title: Text('Photos'),
                onPressed: (context) {
                  openImages();
                  Navigator.pop(context);
                }),
          ],
          cancelAction: CancelAction(title: Text('Cancel')),
        );
      },
      child: Container(
        // height: 20,
        // width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Color(0xffB3E8A8),
            size: 80,
          ),
        ),
      ),
    );
  }
}

//api
class API {
  static Future getPicLs(idd, type) async {
    final response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobGroupDetail'),
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
}

class Album {
  final int j_img_id;
  final String j_img_name;
  final int onApi;

  const Album(
      {required this.j_img_id, required this.j_img_name, required this.onApi});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        j_img_id: json['j_img_id'],
        j_img_name:
            (json['j_img_name'].toString() == 'null') ? "" : json['j_img_name'],
        onApi: 1);
  }
}
