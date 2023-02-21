import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ctfull extends StatefulWidget {
  @override
  _ctfullState createState() => _ctfullState();
}

class _ctfullState extends State<ctfull> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        return pickedfiles;
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
        return pickedfile;

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
          'การคล้อง CT Full Load',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: Color(0xff149C32)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                  children: (imagefiles.length != null)
                      ? List.generate(imagefiles.length + 1, (index) {
                          if (index > imagefiles.length - 1) {
                            //  (imagefiles!.length == limitFile)
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
                                          imagefiles.add(value);
                                          setState(() {});
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    BottomSheetAction(
                                        title: Text('Photos'),
                                        onPressed: (context) {
                                          openImages().then((value) {
                                            imagefiles.addAll(value);
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
                                border: Border.all(color: Color(0xffF1FAEF)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imagefiles.removeAt(index);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              // border: Border.all(
                                              //     width: 1,
                                              //     color: Colors.grey),
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
                                    title: Text('Camera'),
                                    onPressed: (context) {
                                      openCamera().then((value) {
                                        imagefiles.add(value);
                                        setState(() {});
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  BottomSheetAction(
                                      title: Text('Photos'),
                                      onPressed: (context) {
                                        openImages().then((value) {
                                          imagefiles.addAll(value);
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void addSheet(title) {
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
                                      color: Color(0xff149C32))),
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
                              children: (imagefiles.length != null)
                                  ? List.generate(imagefiles.length + 1,
                                      (index) {
                                      if (index > imagefiles.length - 1) {
                                        //  (imagefiles!.length == limitFile)
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
                                                      imagefiles.add(value);
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
                                                        imagefiles
                                                            .addAll(value);
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
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(imagefiles[index].path),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                      mystate(() {
                                                        imagefiles
                                                            .removeAt(index);
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
                                                          // border: Border.all(
                                                          //     width: 1,
                                                          //     color: Colors.grey),
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
                                                title: Text('Camera'),
                                                onPressed: (context) {
                                                  openCamera().then((value) {
                                                    imagefiles.add(value);
                                                    mystate(() {});
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              BottomSheetAction(
                                                  title: Text('Photos'),
                                                  onPressed: (context) {
                                                    openImages().then((value) {
                                                      imagefiles.addAll(value);
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
