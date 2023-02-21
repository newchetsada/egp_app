import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class uploadPic extends StatefulWidget {
  @override
  _uploadPicState createState() => _uploadPicState();
}

class _uploadPicState extends State<uploadPic> {
  final ImagePicker imgpicker = ImagePicker();
  XFile? pic1; // pv จุดที่พัง
  XFile? pic2; // pv รวมๆ
  XFile? pic3; // sn ของ pv
  XFile? pic4; // before pv จุดที่พัง
  XFile? pic5; // before pv รวมๆ
  XFile? pic6; // before sn ของ pv

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
      var pickedfile = await imgpicker.pickImage(source: ImageSource.gallery);
      if (pickedfile != null) {
        return pickedfile;
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            splashRadius: 20,
            color: Color(0xff149C32),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'PV (แผงโซล่าเซลล์)',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: Color(0xff149C32)),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          addcard(),
          items(),
        ],
      )),
    );
  }

  Widget addcard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          beforeSheet();
        },
        child: Container(
          height: 80,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PV (แผงโซล่าเซลล์)',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white)),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    // border: Border.all(width: 3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(200),
                    ),
                    color: Color(0xff149C32),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget items() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          beforeSheet();
        },
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xffE0ECDE)),
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' ชุดที่ 1 แผงโซล่าเซลล์',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xff003175))),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          // width: 45,
                          decoration: BoxDecoration(
                            // border: Border.all(width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(13),
                            ),
                            color: Color(0xffD5FFD9),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('ก่อนซ่อมบำรุง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: Color(0xff149C32))),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(13),
                            ),
                            color: Color(0xffD5FFD9),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('หลังซ่อมบำรุง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: Color(0xff149C32))),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    // border: Border.all(width: 3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(200),
                    ),
                    color: Color(0xff149C32),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardsolar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ชุดที่ 1 แผงโซล่าเซลล์',
                    style: TextStyle(
                        color: Color(0xff464646),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  beforeSheet();
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              // border: Border.all(width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              color: Color(0xffB7B7B7),
                            ),
                            child: Center(
                              child: Text('0',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'รูปถ่ายก่อนซ่อม',
                            style: TextStyle(
                                color: Color(0xffB7B7B7),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(200),
                          ),
                          color: Color(0xffB7B7B7),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(200),
                          ),
                          color: Color(0xffB7B7B7),
                        ),
                        child: Center(
                          child: Text('0',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'รูปถ่ายหลังซ่อม',
                        style: TextStyle(
                            color: Color(0xffB7B7B7),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      // border: Border.all(width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                      color: Color(0xffB7B7B7),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void beforeSheet() {
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
          bool nothavedevice = false;

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
                          padding: const EdgeInsets.only(
                              left: 13, top: 5, bottom: 10),
                          child: Row(
                            children: [
                              Text('ชุดที่ 1 แผงโซล่าเซลล์',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xff003175))),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xffFAFAFA),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('ก่อนซ่อม',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xff003175))),
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
                                  crossAxisCount: 3,
                                  children: <Widget>[
                                    //pic1
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
                                                  mystate(() {
                                                    pic1 = value;
                                                  });
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            BottomSheetAction(
                                                title: Text('Photos'),
                                                onPressed: (context) {
                                                  openPhoto().then((value) {
                                                    mystate(() {
                                                      pic1 = value;
                                                    });
                                                  });

                                                  Navigator.pop(context);
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: Text('Cancel')),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic1 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic1!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xff4FA73C)),
                                                    ),
                                              child: (pic1 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic1 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                        color:
                                                            Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย PV จุดที่พัง',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //pic2
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
                                                  mystate(() {
                                                    pic2 = value;
                                                  });
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            BottomSheetAction(
                                                title: Text('Photos'),
                                                onPressed: (context) {
                                                  openPhoto().then((value) {
                                                    mystate(() {
                                                      pic2 = value;
                                                    });
                                                  });

                                                  Navigator.pop(context);
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: Text('Cancel')),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic2 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic2!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xff4FA73C)),
                                                    ),
                                              child: (pic2 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic2 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                        color:
                                                            Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย PV รวมๆ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //pic3
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
                                                  mystate(() {
                                                    pic3 = value;
                                                  });
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            BottomSheetAction(
                                                title: Text('Photos'),
                                                onPressed: (context) {
                                                  openPhoto().then((value) {
                                                    mystate(() {
                                                      pic3 = value;
                                                    });
                                                  });

                                                  Navigator.pop(context);
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: Text('Cancel')),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic3 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic3!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xff4FA73C)),
                                                    ),
                                              child: (pic3 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic3 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                        color:
                                                            Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย SN ของ PV',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  // height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Color(0xffE0ECDE)),
                                  ),
                                  child: TextField(
                                    // textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: 'หมายเหตุ',
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xffFAFAFA),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('หลังซ่อม',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xff003175))),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        mystate(() {
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
                                                    ? Color(0xff149C32)
                                                    : Color(0xffD3D3D3)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .check_circle_outline_outlined,
                                                color: (nothavedevice == true)
                                                    ? Color(0xff149C32)
                                                    : Color(0xffD3D3D3),
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('ไม่มีอุปกรณ์ซ่อมบำรุง',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: (nothavedevice ==
                                                              true)
                                                          ? Color(0xff149C32)
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
                                  crossAxisCount: 3,
                                  children: <Widget>[
                                    //pic4
                                    GestureDetector(
                                      onTap: () {
                                        (nothavedevice == true)
                                            ? null
                                            : showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: <BottomSheetAction>[
                                                  BottomSheetAction(
                                                    title: Text('Camera'),
                                                    onPressed: (context) {
                                                      openCamera()
                                                          .then((value) {
                                                        mystate(() {
                                                          pic4 = value;
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  BottomSheetAction(
                                                      title: Text('Photos'),
                                                      onPressed: (context) {
                                                        openPhoto()
                                                            .then((value) {
                                                          mystate(() {
                                                            pic4 = value;
                                                          });
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                                cancelAction: CancelAction(
                                                    title: Text('Cancel')),
                                              );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic4 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic4!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : (nothavedevice == true)
                                                      ? BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffD3D3D3)),
                                                        )
                                                      : BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xff4FA73C)),
                                                        ),
                                              child: (pic4 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic4 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                            : Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย PV จุดที่พัง',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //pic5
                                    GestureDetector(
                                      onTap: () {
                                        (nothavedevice == true)
                                            ? null
                                            : showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: <BottomSheetAction>[
                                                  BottomSheetAction(
                                                    title: Text('Camera'),
                                                    onPressed: (context) {
                                                      openCamera()
                                                          .then((value) {
                                                        mystate(() {
                                                          pic5 = value;
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  BottomSheetAction(
                                                      title: Text('Photos'),
                                                      onPressed: (context) {
                                                        openPhoto()
                                                            .then((value) {
                                                          mystate(() {
                                                            pic5 = value;
                                                          });
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                                cancelAction: CancelAction(
                                                    title: Text('Cancel')),
                                              );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic5 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic5!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : (nothavedevice == true)
                                                      ? BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffD3D3D3)),
                                                        )
                                                      : BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xff4FA73C)),
                                                        ),
                                              child: (pic5 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic5 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                            : Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย PV รวมๆ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //pic6
                                    GestureDetector(
                                      onTap: () {
                                        (nothavedevice == true)
                                            ? null
                                            : showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: <BottomSheetAction>[
                                                  BottomSheetAction(
                                                    title: Text('Camera'),
                                                    onPressed: (context) {
                                                      openCamera()
                                                          .then((value) {
                                                        mystate(() {
                                                          pic6 = value;
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  BottomSheetAction(
                                                      title: Text('Photos'),
                                                      onPressed: (context) {
                                                        openPhoto()
                                                            .then((value) {
                                                          mystate(() {
                                                            pic6 = value;
                                                          });
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                                cancelAction: CancelAction(
                                                    title: Text('Cancel')),
                                              );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: (pic6 != null)
                                                  ? BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(pic6!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : (nothavedevice == true)
                                                      ? BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffD3D3D3)),
                                                        )
                                                      : BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xff4FA73C)),
                                                        ),
                                              child: (pic6 != null)
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  pic6 = null;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
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
                                                                      child:
                                                                          Icon(
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
                                                            : Color(0xffB3E8A8),
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('ภาพถ่าย SN ของ PV',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    color: Color(0xff464646))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  // height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Color(0xffE0ECDE)),
                                  ),
                                  child: TextField(
                                    // textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: 'หมายเหตุ',
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
