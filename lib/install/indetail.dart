import 'dart:convert';

import 'package:egp_app/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class indetail extends StatefulWidget {
  _indetailState createState() => _indetailState();
  final int jidx;
  final String userName;
  indetail({required this.jidx, required this.userName});
}

class _indetailState extends State<indetail> {
  var timein = TextEditingController();
  var timeout = TextEditingController();
  // var tech = TextEditingController();
  // var head = TextEditingController();
  // var secur = TextEditingController();
  // var normal = TextEditingController();
  String? select;
  int? detailId;

  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];
  List<TextEditingController> _controllersname = [];
  List<TextField> _fieldsname = [];

  addDaily(jidx, work) async {
    var body = jsonEncode(<dynamic, dynamic>{
      "jidx": jidx,
      "startTime": '12:00',
      "endTime": '18:00',
      "weather": select,
      "userName": widget.userName,
      "workers": work
    });
    try {
      var response =
          await http.post(Uri.parse('$api/api/mobile/addDailyDetailInstall'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
              },
              body: body);
      // print('add code : ${body}');
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('add : ${jsonResponse}');
      }
    } catch (error) {
      print(error);
    }
  }

  updateDaily(jidx, work) async {
    var body = jsonEncode(<dynamic, dynamic>{
      "jDetailInstallId": jidx,
      "startTime": '12:00',
      "endTime": '18:00',
      "weather": select,
      "userName": widget.userName,
      "workers": work
    });
    try {
      var response =
          await http.post(Uri.parse('$api/api/mobile/updateDailyDetailInstall'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
              },
              body: body);
      print('update code : ${body}');
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('update : ${jsonResponse}');
      }
    } catch (error) {
      print(error);
    }
  }

  getdetail(jidx) async {
    try {
      var response = await http.post(
        Uri.parse('$api/api/mobile/getDailyDetailInstall'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{"jidx": jidx}),
      );
      print(jidx);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse;
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail(widget.jidx).then((val) {
      if (val.isEmpty) {
        print('emp');
        // person('วิศวกรคุมงาน', tech),
        // person('หัวหน้าคนงาน', head),
        // person('เจ้าหน้าที่ความปลอดภัย', secur),
        // person('คนงาน', normal),
        addMaster('วิศวกรคุมงาน', '');
        addMaster('หัวหน้าคนงาน', '');
        addMaster('เจ้าหน้าที่ความปลอดภัย', '');
        addMaster('คนงาน', '');
        addOther('', '');
      } else {
        print('have');
        setState(() {
          detailId = val[0]['j_detail_install_id'];
          select = val[0]['weather'];
          timein.text = val[0]['j_detail_install_start_time'];
          timeout.text = val[0]['j_detail_install_end_time'];
          List all = val[0]['workers'];
          for (var i = 0; i < all.length; i++) {
            print(all[i]['worker_name']);
            if (all[i]['other'] == false) {
              addMaster(
                  all[i]['worker_name'], all[i]['worker_amount'].toString());
            } else {
              addOther(
                  all[i]['worker_name'], all[i]['worker_amount'].toString());
            }
          }
          addOther('', '');
        });
      }
    });
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          //   (widget.status == 3)
          // ? null
          // :
          Container(
        // height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              spreadRadius: 10,
              offset: Offset(0, -3), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                child: SizedBox(
                  height: 50,
                  // width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);

                      loading();
                      List workers = [];

                      for (var data in masterCon) {
                        workers.add({
                          "workerName": data['workerName'],
                          "workerAmount": data['workerAmount'].text,
                          "other": false
                        });
                      }

                      for (var i = 0; i < _controllers.length; i++) {
                        if (_controllersname[i].text.isNotEmpty) {
                          workers.add({
                            "workerName": _controllersname[i].text,
                            "workerAmount": _controllers[i].text,
                            "other": true
                          });
                        }
                      }
                      print(workers);
                      if (detailId == null) {
                        print('add');

                        addDaily(widget.jidx, workers).then((val) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      } else {
                        print('update');
                        updateDaily(detailId, workers).then((val) {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
            (defaultTargetPlatform == TargetPlatform.android) ? 140 : 120,
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
                top:
                    (defaultTargetPlatform == TargetPlatform.android) ? 20 : 0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(0xff57A946),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Icon(
                            Icons.mode_edit_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'วันจันทร์ที่ 20 มกราคม',
                        style: TextStyle(
                            color: Color(0xff57A946),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
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
                                'รายละเอียด ติดตั้งระบบโซล่าเซลล์',
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
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
          children: [
            time('เวลาเข้างาน', timein),
            time('เวลาออกงาน', timeout),
            Text(
              'สภาพภูมิอากาศ',
              style: TextStyle(
                  color: Color(0xff464646),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            weather('แจ่มใส'),
            weather('มืดครึ้ม'),
            weather('ฝนตก'),
            SizedBox(
              height: 10,
            ),
            Text(
              'จำนวนผู้ปฏิบัติงาน',
              style: TextStyle(
                  color: Color(0xff464646),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            // person('วิศวกรคุมงาน', tech),
            // person('หัวหน้าคนงาน', head),
            // person('เจ้าหน้าที่ความปลอดภัย', secur),
            // person('คนงาน', normal),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: master.length,
                itemBuilder: (context, index) {
                  return master[index];
                }),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: _fields.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffD6EFB4)),
                          ),
                          child: _fieldsname[index],
                        ),
                      )),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xffD6EFB4)),
                                ),
                                child: _fields[index],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            (index == _fields.length - 1)
                                ? GestureDetector(
                                    onTap: () {
                                      addOther('', '');
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Color(0xffD6EFB4),
                                          )),
                                      child: Icon(
                                        Icons.add,
                                        size: 22,
                                        color: Color(0xffD6EFB4),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controllers.removeAt(index);
                                        _fields.removeAt(index);
                                        _controllersname.removeAt(index);
                                        _fieldsname.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 199, 91, 91),
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
    );
  }

  time(title, con) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff2A302C),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          )),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xffD6EFB4)),
              ),
              child: TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: con,
                decoration: InputDecoration(
                  hintText: '00:00',
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  person(title, con) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff2A302C),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          )),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xffD6EFB4)),
              ),
              child: TextField(
                onTapOutside: (b) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: con,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List master = [];
  List masterCon = [];
  addMaster(titleMas, val) {
    final controller = TextEditingController();
    setState(() {
      controller.text = val;
      master.add(person(titleMas, controller));
      masterCon.add({"workerName": titleMas, "workerAmount": controller});
    });
  }

  addOther(title, number) {
    final controllername = TextEditingController();

    final controller = TextEditingController();
    final name = TextField(
      onTapOutside: (b) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controllername,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'อื่นๆ',
        hintStyle: TextStyle(fontSize: 15),
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      ),
    );
    final field = TextField(
      onTapOutside: (b) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      ),
    );

    setState(() {
      controller.text = number;
      controllername.text = title;
      _controllers.add(controller);
      _fields.add(field);
      _controllersname.add(controllername);
      _fieldsname.add(name);
    });
  }

  weather(val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            select = val;
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(
                (select == val)
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Color(0xff9DC75B),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  val,
                  style: TextStyle(
                      color: Color(0xff2A302C),
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
