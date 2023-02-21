import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class photopage extends StatefulWidget {
  @override
  _photopageState createState() => _photopageState();
  final int type;
  const photopage({
    super.key,
    required this.type,
  });
}

class _photopageState extends State<photopage> {
  //img
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];
  int limitFile = 10;

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
        if (pickedfiles.length > limitFile - imagefiles.length) {
          limitpop(limitFile - imagefiles.length);
        } else {
          imagefiles.addAll(pickedfiles);
        }

        setState(() {});

        print("Image List Length:" + imagefiles!.length.toString());
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
        imagefiles.add(pickedfile);

        setState(() {});

        // print("Image List Length:" + imagefiles!.length.toString());
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                        Navigator.pop(context);
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
            (widget.type == 0)
                ? 'แจ้งซ่อม'
                : (widget.type == 1)
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
                      (imagefiles == null)
                          ? '0/$limitFile'
                          : '${imagefiles!.length}/$limitFile',
                      style: TextStyle(
                          color: Color(0xff149C32),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child:
                        // GridView.builder(
                        //     itemCount: imagefiles?.length,
                        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 3),
                        //     itemBuilder: (BuildContext context, int index) {
                        //       return Image.file(
                        //         File(imagefiles![index].path),
                        //         fit: BoxFit.cover,
                        //       );
                        //     }),
                        GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 1.3,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: (imagefiles.length != null)
                          ? (imagefiles.length == limitFile)
                              ? List.generate(imagefiles.length, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(imagefiles[index].path),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Color(0xffF1FAEF)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  imagefiles.removeAt(index);
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(
                                                    //     width: 1,
                                                    //     color: Colors.grey),
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
                                            // IconButton(
                                            //     color: Colors.red[300],
                                            //     onPressed: () {},
                                            //     icon: Icon(Icons.remove_circle_rounded))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              : List.generate(imagefiles.length + 1, (index) {
                                  if (index > imagefiles.length - 1) {
                                    //  (imagefiles!.length == limitFile)
                                    return add();
                                  } else {
                                    return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(imagefiles[index].path),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(0xffF1FAEF)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    imagefiles.removeAt(index);
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      // border: Border.all(
                                                      //     width: 1,
                                                      //     color: Colors.grey),
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
                                              // IconButton(
                                              //     color: Colors.red[300],
                                              //     onPressed: () {},
                                              //     icon: Icon(Icons.remove_circle_rounded))
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                })
                          : <Widget>[
                              add(),
                              // (imagefiles?.length != null)
                              //     ? Image.file(
                              //         File(imagefiles![0].path),
                              //         fit: BoxFit.cover,
                              //       )
                              //     : Container()
                              // add(),
                              // add(),
                              // add(),
                              // add(),
                              // add(),
                              // add(),
                              // add(),
                            ],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'หมายเหตุ',
                    //   style: TextStyle(
                    //       color: Color(0xff003175),
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600),
                    // ),
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20, bottom: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         height: 40,
                    //         width: 150,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             foregroundColor: Colors.white,
                    //             backgroundColor: Color(0xff149C32),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(32.0),
                    //             ),
                    //           ),
                    //           child: Text(
                    //             'บันทึก',
                    //             style: TextStyle(
                    //                 fontSize: 15, fontWeight: FontWeight.w600),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
