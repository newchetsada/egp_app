import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:egp_app/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class roofup extends StatefulWidget {
  @override
  _roofupState createState() => _roofupState();
  final int status;
  roofup({required this.status});
}

class _roofupState extends State<roofup> {
  final ImagePicker imgpicker = ImagePicker();

  bool isLoading = true;
  var remarkproblem = TextEditingController();
  var remarkfix = TextEditingController();
  var picbefore = <Album>[];
  var picafter = <Album>[];
  List deleteLs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = false;
    });
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
                  j_img_install_id: 0,
                  j_img_install_name: pickedfiles[i].path,
                  onApi: 0,
                  j_img_install_remark: '',
                  imgType: 1))
              : picbefore.add(Album(
                  j_img_install_id: 0,
                  j_img_install_name: pickedfiles[i].path,
                  onApi: 0,
                  j_img_install_remark: '',
                  imgType: 0));
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
                j_img_install_id: 0,
                j_img_install_name: pickedfile.path,
                onApi: 0,
                j_img_install_remark: '',
                imgType: 1))
            : picbefore.add(Album(
                j_img_install_id: 0,
                j_img_install_name: pickedfile.path,
                onApi: 0,
                j_img_install_remark: '',
                imgType: 0));

        // setState(() {});

        // print("Image List Length:" + imagefiles!.length.toString());
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
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
                                onPressed: () {},
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
                                //     ? popPicbeforeApi(picbefore[index].j_img_install_name)
                                //     : popPicbeforePre(picbefore[index].j_img_install_name);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: (picbefore[index].onApi == 1)
                                    ? Image.network(
                                        '$api/${picbefore[index].j_img_install_name}', // this image doesn't exist
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
                                            .j_img_install_name),
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
                                  //     ? popPicApi(pic[index].j_img_install_name)
                                  //     : popPicPre(pic[index].j_img_install_name);
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: (picbefore[index].onApi == 1)
                                          ? Image.network(
                                              '$api/${picbefore[index].j_img_install_name}', // this image doesn't exist
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
                                                  .j_img_install_name),
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
                                                    deleteLs.add(
                                                        picbefore[index]
                                                            .j_img_install_id);
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
                                //     ? popPicafterApi(picafter[index].j_img_install_name)
                                //     : popPicafterPre(picafter[index].j_img_install_name);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: (picafter[index].onApi == 1)
                                    ? Image.network(
                                        '$api/${picafter[index].j_img_install_name}', // this image doesn't exist
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
                                        File(
                                            picafter[index].j_img_install_name),
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
                                  //     ? popPicApi(pic[index].j_img_install_name)
                                  //     : popPicPre(pic[index].j_img_install_name);
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: (picafter[index].onApi == 1)
                                          ? Image.network(
                                              '$api/${picafter[index].j_img_install_name}', // this image doesn't exist
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
                                                  .j_img_install_name),
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
                                                        .j_img_install_id);
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
}

class Album {
  final int j_img_install_id;
  final String j_img_install_name;
  final int onApi;
  final String j_img_install_remark;
  final int imgType;

  const Album(
      {required this.j_img_install_id,
      required this.j_img_install_name,
      required this.onApi,
      required this.j_img_install_remark,
      required this.imgType});

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
        imgType: json['imgType']);
  }
}
