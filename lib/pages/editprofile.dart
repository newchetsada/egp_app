import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:egp_app/config.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();

  final int? id;
  final String fname;
  final String lname;
  final String email;
  final String tel;
  final String line;
  final String position;
  final String companame;
  final String userName;
  final String pic;
  editprofile(
      {required this.id,
      required this.fname,
      required this.lname,
      required this.email,
      required this.tel,
      required this.line,
      required this.position,
      required this.companame,
      required this.userName,
      required this.pic});
}

class _editprofileState extends State<editprofile> {
  final ImagePicker imgpicker = ImagePicker();
  File? _pickedImage;
  var fname = TextEditingController();
  var lname = TextEditingController();
  var email = TextEditingController();
  // var tel = TextEditingController();
  var line = TextEditingController();
  var position = TextEditingController();
  var companame = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

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

  updatePro(File? image) async {
    String tell = _controllers
        .where((element) => element.text != "")
        .fold("", (acc, element) => acc += "${element.text}, ");
    print(tell);
    var request = http.MultipartRequest(
        'POST', Uri.parse('$api/api/master/updateTechnician'));
    request.headers['X-API-Key'] = 'evdplusm8DdW+Wd3UCweHj';
    request.fields['techId'] = widget.id.toString();
    request.fields['userName'] = widget.userName;
    request.fields['fname'] = fname.text;
    request.fields['lname'] = lname.text;
    request.fields['email'] = email.text;
    request.fields['tel'] = tell.substring(0, tell.length - 2);

    request.fields['line'] = line.text;
    request.fields['position'] = position.text;
    request.fields['company'] = companame.text;
    request.fields['activeFlag'] = '0';
    request.fields['filesName'] =
        (image == null) ? '' : image.path.split('/').last;
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'files', image.readAsBytesSync(),
          filename: image.path.split('/').last));
    }

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    // print(response.body);
    // return response.body;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      fname.text = widget.fname;
      lname.text = widget.lname;
      email.text = widget.email;
      // tel.text = widget.tel;
      line.text = widget.line;
      position.text = widget.position;
      companame.text = widget.companame;
      if (widget.tel.isNotEmpty) {
        var alltel = widget.tel.split(', ');
        print(alltel.length);
        for (var i = 0; i < alltel.length; i++) {
          addTel(alltel[i]);
        }
      } else {
        addTel('');
      }
    });
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

  addTel(number) {
    final controller = TextEditingController();
    final field = TextField(
      onTapOutside: (b) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 10,

      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only numbers can be entered

      decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
          enabledBorder: myinputborder(),
          focusedBorder: myinputborder()),
    );

    setState(() {
      controller.text = number;
      _controllers.add(controller);
      _fields.add(field);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight:
            (defaultTargetPlatform == TargetPlatform.android) ? 70 : 50,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top:
                    (defaultTargetPlatform == TargetPlatform.android) ? 20 : 0),
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
                Text('แก้ไขโปรไฟล์',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
              ],
            ),
          ),
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
                      loading();
                      updatePro(_pickedImage).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                      // String text = _controllers
                      //     .where((element) => element.text != "")
                      //     .fold(
                      //         "", (acc, element) => acc += "${element.text}, ");
                      // print(text);
                    },
                    style: ElevatedButton.styleFrom(
                      // elevation: 0,
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
            ),
          ],
        ),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        // title: const Text('Title'),
                        actions: <BottomSheetAction>[
                          BottomSheetAction(
                            title: Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Noto Sans Thai',
                              ),
                            ),
                            onPressed: (context) {
                              openCamera().then((value) {
                                setState(() {
                                  if (value != null) {
                                    _pickedImage = File(value.path);
                                  }
                                  // desLs_before[index].j_img_name = value.path;
                                });
                              });
                              Navigator.pop(context);
                            },
                          ),
                          BottomSheetAction(
                              title: Text(
                                'Photos',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Noto Sans Thai',
                                ),
                              ),
                              onPressed: (context) {
                                openPhoto().then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _pickedImage = File(value.path);
                                    }
                                    // desLs_before[index].j_img_name = value.path;
                                  });
                                });

                                Navigator.pop(context);
                              }),
                        ],
                        cancelAction: CancelAction(
                            title: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Noto Sans Thai',
                          ),
                        )),
                      );
                    },
                    child: SizedBox(
                        height: 130,
                        width: 130,
                        child: _pickedImage == null
                            ? (widget.pic.isEmpty)
                                ? Icon(
                                    EvaIcons.peopleOutline,
                                    size: 130,
                                    color: Color(0xff57A946).withOpacity(0.5),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        '$api/${widget.pic}'),
                                  )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    _pickedImage!),
                              )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                ' ชื่อ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: fname,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' นามสกุล',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: lname,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Phone number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),

              // _addTile(),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: _fields[index],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        (index == _fields.length - 1)
                            ? GestureDetector(
                                onTap: () {
                                  addTel('');
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Color(0xff9DC75B),
                                      )),
                                  child: Icon(
                                    Icons.add,
                                    size: 22,
                                    color: Color(0xff9DC75B),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controllers.removeAt(index);
                                    _fields.removeAt(index);
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Color.fromARGB(255, 199, 91, 91),
                                      )),
                                  child: Icon(
                                    Icons.delete,
                                    size: 22,
                                    color: Color.fromARGB(255, 199, 91, 91),
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                },
              ),
              // TextField(
              //   onTapOutside: (b) {
              //     FocusManager.instance.primaryFocus?.unfocus();
              //   },
              //   controller: tel,
              //   keyboardType: TextInputType.number,
              //   inputFormatters: <TextInputFormatter>[
              //     // FilteringTextInputFormatter.digitsOnly
              //     // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //     // LengthLimitingTextInputFormatter(4),
              //     // CardFormatter(sample: 'XXXXXXXXXX-XXXXXXXXXX', separator: '-')
              //   ], // Only numbers can be entered
              //   onChanged: (value) {
              //    tel.text.split(', ').
              //   },
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
              //       enabledBorder: myinputborder(),
              //       focusedBorder: myinputborder()),
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' Line ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: line,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' ตำแหน่ง',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: position,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' ชื่อบริษัท',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9DC75B),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: companame,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: Color(0xffD6EFB4),
          width: 0.5,
        ));
  }
}
