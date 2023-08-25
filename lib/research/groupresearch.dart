import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class groupresearch extends StatefulWidget {
  @override
  _groupresearchState createState() => _groupresearchState();

  final int jidx;
  final int typeId;
  final String typeName;

  groupresearch(
      {required this.jidx, required this.typeId, required this.typeName});
}

class _groupresearchState extends State<groupresearch> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  var groupSub = <SubLs>[];
  String pathPic = 'https://backoffice.energygreenplus.co.th/';
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
      var pickedfiles = await imgpicker.pickMultiImage();
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
      var pickedfile = await imgpicker.pickImage(source: ImageSource.camera);
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
        'POST',
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/uploadJobImage'));

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

  updateRemark(id, type, sub, note) async {
    var response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/updateJobDetailInGroup'),
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
                        if (widget.typeId == 13) {
                          loading();
                          loopdelete().then((value) {
                            loopupload("").then((value) {
                              updateRemark(widget.jidx, widget.typeId, null,
                                      remark.text)
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
                        backgroundColor: Color(0xff57A946),
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
              color: Color(0xff57A946),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            widget.typeName,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff57A946)),
          ),
        ),
        body: (widget.typeId == 13)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: GridView.count(
                            shrinkWrap: true,
                            childAspectRatio: 1.3,
                            primary: false,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: List.generate(pic.length + 1, (index) {
                              if (index > pic.length - 1) {
                                return GestureDetector(
                                  onTap: () {
                                    showAdaptiveActionSheet(
                                      context: context,
                                      // title: const Text('Title'),
                                      actions: <BottomSheetAction>[
                                        BottomSheetAction(
                                          title: Text('Camera'),
                                          onPressed: (context) {
                                            openCamera().then((value) {
                                              setState(() {});
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        BottomSheetAction(
                                            title: Text('Photos'),
                                            onPressed: (context) {
                                              openImages().then((value) {
                                                setState(() {});
                                              });
                                              Navigator.pop(context);
                                            }),
                                      ],
                                      cancelAction:
                                          CancelAction(title: Text('Cancel')),
                                    );
                                  },
                                  child: Container(
                                    // height: 20,
                                    // width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
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
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    // (pic[index].onApi == 1)
                                    //     ? popPicApi(pic[index].j_img_name)
                                    //     : popPicPre(pic[index].j_img_name);
                                  },
                                  child: Container(
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
                                  ),
                                );
                              }
                            }))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
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
              )
            : ListView.builder(
                // shrinkWrap: true,
                // primary: false,
                itemCount: groupSub.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 30, right: 30),
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
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(color: Color(0xffE0ECDE)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff57A946).withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      groupSub[index].sub_type_name,
                                      style: TextStyle(
                                          color: Color(0xff003175),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'รูปทั้งหมด  ${groupSub[index].amount_pic}',
                                      style: TextStyle(
                                          color: Color(0xff57A946),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: (groupSub[index].amount_pic > 0)
                                        ? Color(0xff57A946)
                                        : Color(0xffB7B7B7),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 13, top: 5),
                          child: Row(
                            children: [
                              Text(title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xff57A946))),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: GridView.count(
                              shrinkWrap: true,
                              childAspectRatio: 1.3,
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: (pic.length > 0)
                                  ? List.generate(pic.length + 1, (index) {
                                      if (index > pic.length - 1) {
                                        return GestureDetector(
                                          onTap: () {
                                            showAdaptiveActionSheet(
                                              context: context,
                                              // title: const Text('Title'),
                                              actions: <BottomSheetAction>[
                                                BottomSheetAction(
                                                  title: Text('Camera'),
                                                  onPressed: (context) {
                                                    openCamera().then((value) {
                                                      // imagefiles.add(value);
                                                      mystate(() {});
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                BottomSheetAction(
                                                    title: Text('Photos'),
                                                    onPressed: (context) {
                                                      openImages()
                                                          .then((value) {
                                                        // imagefiles
                                                        //     .addAll(value);
                                                        mystate(() {});
                                                      });
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                              cancelAction: CancelAction(
                                                  title: Text('Cancel')),
                                            );
                                          },
                                          child: Container(
                                            // height: 20,
                                            // width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
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
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            // (pic[index].onApi == 1)
                                            //     ? popPicApi(
                                            //         pic[index].j_img_name)
                                            //     : popPicPre(
                                            //         pic[index].j_img_name);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
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
                                                          MainAxisAlignment.end,
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
                                                                color:
                                                                    Colors.grey,
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
                                                title: Text('Camera'),
                                                onPressed: (context) {
                                                  openCamera().then((value) {
                                                    // imagefiles.add(value);
                                                    mystate(() {});
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              BottomSheetAction(
                                                  title: Text('Photos'),
                                                  onPressed: (context) {
                                                    openImages().then((value) {
                                                      // imagefiles.addAll(value);
                                                      mystate(() {});
                                                    });
                                                    Navigator.pop(context);
                                                  }),
                                            ],
                                            cancelAction: CancelAction(
                                                title: Text('Cancel')),
                                          );
                                        },
                                        child: Container(
                                          // height: 20,
                                          // width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Color(0xffB3E8A8),
                                              size: 80,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                            )),
                        Container(
                          // height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffE0ECDE)),
                          ),
                          child: TextField(
                            // textInputAction: TextInputAction.done,
                            controller: remark,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'หมายเหตุ',
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                loading();
                                loopdelete().then((value) {
                                  loopupload(subb).then((value) {
                                    updateRemark(widget.jidx, widget.typeId,
                                            subb, remark.text)
                                        .then((value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xff57A946),
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobGroupSurveyImageLs'),
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
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobGroupDetail'),
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
