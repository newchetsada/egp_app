import 'dart:convert';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:egp_app/audit/addaudit.dart';
import 'package:egp_app/audit/groupaudit.dart';
import 'package:egp_app/clean/photopage.dart';
import 'package:egp_app/clean/signature.dart';
import 'package:egp_app/pages/homepage.dart';
import 'package:egp_app/repair/hero_dialog_route.dart';
import 'package:egp_app/report/report.dart';
import 'package:egp_app/research/groupresearch.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:egp_app/config.dart';

class research extends StatefulWidget {
  @override
  _researchState createState() => _researchState();

  final int jid;
  //detail
  final String j_start_date;
  final String j_send_date;
  final String cus_name;
  final String site_name;
  final String cus_address;
  final String install_date;
  final String warranty_expire;
  final String power_peak;
  final String j_detail;
  final String remark_tech;
  final double lat;
  final double lon;
  final String fullname;
  final String position;
  final String tel;
  final int j_status;
  final int ppe_flag;
  final String j_remark_complete;
  final int type;
  final String pic;
  final int? sid;
  final List sitepic;
  final int belt_flag;
  final String amount;

  //

  research(
      {required this.jid,
      required this.j_start_date,
      required this.j_send_date,
      required this.cus_name,
      required this.site_name,
      required this.cus_address,
      required this.install_date,
      required this.warranty_expire,
      required this.power_peak,
      required this.j_detail,
      required this.remark_tech,
      required this.lat,
      required this.lon,
      required this.fullname,
      required this.position,
      required this.tel,
      required this.j_status,
      required this.ppe_flag,
      required this.j_remark_complete,
      required this.type,
      required this.pic,
      required this.sid,
      required this.sitepic,
      required this.belt_flag,
      required this.amount});
}

class _researchState extends State<research> {
  PageController controller = PageController(initialPage: 0);
  int _curpage = 0;

  var contact = <Album>[];
  var groupPic = <GroupLs>[];

  bool contactloading = true;

  var remarkEnd = TextEditingController();

  String sign_name_1 = '';
  String path_sign1 = '';
  String sign_name_2 = '';
  String path_sign2 = '';

  int ispass = 0;
  bool totalpass = false;
  int workstatus = 0;

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

  void openMap(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  _getAPI(id) {
    var idd = id;
    API.getContactLs(idd).then((response) {
      setState(() {
        List list = json.decode(response.body);
        contact = list.map((m) => Album.fromJson(m)).toList();
        remarkEnd.text = widget.j_remark_complete;
      });
      API.getGroupLs(idd, widget.type).then((value) {
        setState(() {
          List list1 = json.decode(value.body);

          groupPic = list1.map((m) => GroupLs.fromJson(m)).toList();
          ispass = 0;
          for (var i = 0; i < groupPic.length; i++) {
            if (groupPic[i].amount_sub_type_true ==
                groupPic[i].amount_sub_type_all) {
              ispass = ispass + 1;
            }
          }
          if (ispass == groupPic.length) {
            totalpass = true;
          } else {
            totalpass = false;
          }

          contactloading = false;
        });
      });
    });
  }

  StartWork() async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/startWorking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': widget.jid,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  endWork(note) async {
    var response = await http.post(
      Uri.parse('$api/api/mobile/endWorking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': widget.jid,
        'remark': note,
        'userName': userName,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  Future getsign1(jidx) async {
    try {
      var response = await http.post(
        Uri.parse((widget.type == 3)
            ? '$api/api/mobile/getJobGroupDetail'
            : '$api/api/mobile/getJobGroupDetailByAudit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'jidx': jidx,
          "groupNo": 1,
          'typeId': null,
          'imgType': 3
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        setState(() {
          sign_name_1 = jsonResponse[0]['sign_name'];
          path_sign1 = jsonResponse[0]['j_img_name'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future getsign2(jidx) async {
    try {
      var response = await http.post(
        Uri.parse((widget.type == 3)
            ? '$api/api/mobile/getJobGroupDetail'
            : '$api/api/mobile/getJobGroupDetailByAudit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'jidx': jidx,
          "groupNo": 1,
          'typeId': null,
          'imgType': 2
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        setState(() {
          sign_name_2 = jsonResponse[0]['sign_name'];
          path_sign2 = jsonResponse[0]['j_img_name'];
        });
      }
    } catch (error) {
      print(error);
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

  void popsign(path) {
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
              child: Center(
            child: Image.network('$api/$path'),
          )),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    setState(() {
      workstatus = widget.j_status;
    });
    getUser();
    _getAPI(widget.jid);
    getsign1(widget.jid);
    getsign2(widget.jid);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void confirmpop() {
    showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'ยืนยันการส่งข้อมูล',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffAED76E)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'กรณีส่งข้อมูลแล้ว ผู้ใช้งานจะไม่สามารถเข้ามาแก้ไขข้อมูลเพิ่มเติมได้อีก',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff464646)),
                        )),
                    SizedBox(
                      height: 40,
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          loading();
                          endWork(remarkEnd.text).then((value) {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => homePage()),
                                (route) => false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shadowColor: Colors.white,
                          backgroundColor: Color(0xffAED76E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: Text(
                          'ยืนยันส่งงาน',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2A302C)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // if (Navigator.of(context).userGestureInProgress) {
        //   return false;
        // } else

        if (_curpage == 0) {
          Navigator.pop(context);
        } else {
          controller.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }

        return Future(() => false);

        // return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight:
              (defaultTargetPlatform == TargetPlatform.android) ? 200 : 180,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffF8FFF6),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (_curpage == 0) {
                                      Navigator.pop(context);
                                    } else {
                                      controller.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease);
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xff57A946),
                                    size: 25,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Text((_curpage == 0) ? 'รายละเอียด' : 'ดำเนินงาน',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xff2A302C))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              (widget.type == 3)
                                  ? 'สำรวจสถานที่'
                                  : 'ตรวจสอบประจำปี',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xff57A946))),
                          Text('บริษัท : ${widget.cus_name} ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xff57A946))),
                          Text('สาขา : ${widget.site_name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xff57A946))),
                          SizedBox(
                            height: 5,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     openMap(widget.lat, widget.lon);
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.location_on_rounded,
                          //         color: Color(0xff57A946),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Flexible(
                          //         child: Text(widget.cus_address,
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 12,
                          //                 color: Color(0xff646464))),
                          //       )
                          //     ],
                          //   ),
                          // ),
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
                          child: (widget.j_status == 3)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 25,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text('รายละเอียด',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: (_curpage == 0)
                                                      ? Color(0xff57A946)
                                                      : Color(0xff7A86A1))),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text('ส่งงาน',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: (_curpage == 1)
                                                      ? Color(0xff57A946)
                                                      : Color(0xff7A86A1))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 25,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('รายละเอียด',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: (_curpage == 0)
                                                  ? Color(0xff57A946)
                                                  : Color(0xff7A86A1))),
                                      Text('ดำเนินงาน',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: (_curpage == 1)
                                                  ? Color(0xff57A946)
                                                  : Color(0xff7A86A1))),
                                      Text('ตรวจสอบ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: (_curpage == 2)
                                                  ? Color(0xff57A946)
                                                  : Color(0xff7A86A1))),
                                      Text('ส่งงาน',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: (_curpage == 3)
                                                  ? Color(0xff57A946)
                                                  : Color(0xff7A86A1))),
                                    ],
                                  ),
                                ),
                        ),
                        Container(
                          height: 15,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(25),
              //     topRight: Radius.circular(25))),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (value) {
                  // print(value);
                  setState(() {
                    _curpage = value;
                  });
                },
                children: (widget.j_status == 3)
                    ? <Widget>[detail(), sendPage()]
                    : <Widget>[detail(), photoPage(), sign(), finished()],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget detail() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
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
                padding: const EdgeInsets.only(
                    top: 0, bottom: 30, left: 30, right: 30),
                child: SizedBox(
                  height: 50,
                  // width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      if (workstatus == 1) {
                        loading();
                        StartWork().then((jsonResponse) {
                          print(jsonResponse);
                          if (jsonResponse['status'] == true) {
                            setState(() {
                              workstatus = 2;
                            });
                            Navigator.pop(context);
                            controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          } else {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(jsonResponse['message']),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        });
                      } else {
                        controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffAED76E),
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      (workstatus == 1) ? 'เริ่มดำเนินงาน' : 'ถัดไป',
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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Row(children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [.05, .05],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff9DC75B),
                              Colors.transparent, // top Right part
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border:
                              Border.all(color: Color(0xffD6EFB4), width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 15,
                                  color: Color(0xff9DC75B),
                                ),
                                Text('นัดหมายเข้างาน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Color(0xff9DC75B))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(widget.j_start_date.substring(0, 10),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff9DC75B))),
                                Text(widget.j_start_date.substring(11, 16),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff9DC75B))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [.05, .05],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff57A946),
                              Colors.transparent, // top Right part
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border:
                              Border.all(color: Color(0xff57A946), width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 15,
                                  color: Color(0xff57A946),
                                ),
                                Text('นัดหมายส่งงาน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Color(0xff57A946))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(widget.j_send_date.substring(0, 10),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff57A946))),
                                Text(widget.j_send_date.substring(11, 16),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xff57A946))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                  ]),
                ),

                SizedBox(
                  height: 10,
                ),
                Text('ติดต่อ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xff58A946))),
                SizedBox(
                  height: 10,
                ),
                (contactloading == true)
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            // padding: EdgeInsets.symmetric(horizontal: 30),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: (index == 0) ? 0 : 10),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 100,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xffE1F5DC),
                                          Color(0xffD6EFB4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                    : (contact.isEmpty)
                        ? SizedBox(
                            height: 100,
                            child: Center(
                              child: Text('ไม่มีข้อมูลผู้ติดต่อ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(255, 153, 156, 153))),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: contact.length,
                              scrollDirection: Axis.horizontal,
                              // padding: EdgeInsets.symmetric(horizontal: 30),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: (index == 0) ? 0 : 10),
                                  child: GestureDetector(
                                    onTap: (contact[index].j_cont_tel.isEmpty)
                                        ? null
                                        : () {
                                            var tel = contact[index].j_cont_tel;
                                            var moretel = tel.split(', ');
                                            if (moretel.length > 1) {
                                              showAdaptiveActionSheet(
                                                context: context,
                                                // title: const Text('Title'),
                                                actions: List.generate(
                                                  moretel.length,
                                                  (index) => BottomSheetAction(
                                                    title: Text(moretel[index],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        )),
                                                    onPressed: (context) {
                                                      Navigator.pop(context);
                                                      _makePhoneCall(
                                                          moretel[index]);
                                                    },
                                                  ),
                                                ),

                                                cancelAction: CancelAction(
                                                    title: Text('Cancel',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ))),
                                              );
                                            } else {
                                              _makePhoneCall(
                                                  contact[index].j_cont_tel);
                                            }
                                          },
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xffE1F5DC),
                                            Color(0xffD6EFB4),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              EvaIcons.peopleOutline,
                                              color: Color(0xff2A302C),
                                              size: 22,
                                            ),
                                            Text(contact[index].j_cont_name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 13,
                                                    color: Color(0xff464646))),
                                            Text(
                                                'ตำแหน่ง : ${contact[index].j_cont_position}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    color: Color(0xff464646))),
                                            Text(contact[index].j_cont_tel,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Color(0xff464646)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    openMap(widget.lat, widget.lon);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Color(0xffD6EFB4), width: 1)),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xff57A946),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(widget.cus_address,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff646464))),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xff57A946),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Text('วันเดือนปี ติดตั้งแผง : ${widget.install_date}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                Text('วันเดือนปี หมดระยะเวลาประกัน : ${widget.warranty_expire}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                Text('ขนาดการติดตั้ง : ${widget.power_peak} kW',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                Text('จำนวนแผง : ${widget.amount} PV',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                Text('รายละเอียดงาน : ${widget.j_detail}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                Text('หมายเหตุ : ${widget.remark_tech}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff2A302C))),
                SizedBox(
                  height: 10,
                ),
                (widget.ppe_flag == 1)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff57A946),
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('ชุด PPE',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff57A946))),
                          ],
                        ),
                      )
                    : Container(),

                (widget.belt_flag == 1)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff57A946),
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('คาดเข็มขัดนิรภัย',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff57A946))),
                          ],
                        ),
                      )
                    : Container(),

                // DottedLine(dashColor: Color(0xffD5D5D5)),
                Text('แผนผังไซต์งาน',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xff58A946))),
                SizedBox(
                  height: 10,
                ),
                (widget.sitepic.isEmpty)
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
                          itemCount: widget.sitepic.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: (index == 0) ? 0 : 10),
                              child: AspectRatio(
                                aspectRatio: 16 / 11,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: (widget.sitepic[index]
                                                    ['site_img_des'] ==
                                                null ||
                                            widget.sitepic[index]
                                                    ['site_img_des'] ==
                                                '')
                                        ? Colors.transparent
                                        : Color(0xffEDFAEA),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: GestureDetector(
                                              onTap: (widget.sitepic.isEmpty)
                                                  ? null
                                                  : () {
                                                      Navigator.push(
                                                          context,
                                                          HeroDialogRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Dialog(
                                                                      elevation:
                                                                          0,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      child:
                                                                          Hero(
                                                                        tag:
                                                                            'pic$index',
                                                                        child:
                                                                            PhotoView(
                                                                          tightMode:
                                                                              true,
                                                                          backgroundDecoration:
                                                                              BoxDecoration(color: Colors.transparent),
                                                                          imageProvider:
                                                                              NetworkImage('$api/${widget.sitepic[index]['site_img_name']}'),
                                                                        ),
                                                                      ))));
                                                    },
                                              child: Hero(
                                                tag: 'pic$index',
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '$api/${widget.sitepic[index]['site_img_name']}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ))),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet<void>(
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SafeArea(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Color(
                                                                  0xffEDFAEA),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                  widget.sitepic[
                                                                              index]
                                                                          [
                                                                          'site_img_des'] ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Color(
                                                                          0xff2A302C))),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                    widget.sitepic[index]
                                                            ['site_img_des'] ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff2A302C))),
                                              ),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('เจ้าหน้าที่ประสานงาน',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xff58A946))),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.tel.isEmpty) {
                    } else {
                      var tel = widget.tel;
                      var moretel = tel.split(', ');
                      print(moretel);
                      if (moretel.length > 1) {
                        showAdaptiveActionSheet(
                          context: context,
                          // title: const Text('Title'),
                          actions: List.generate(
                            moretel.length,
                            (index) => BottomSheetAction(
                              title: Text(moretel[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                              onPressed: (context) {
                                Navigator.pop(context);
                                _makePhoneCall(moretel[index]);
                              },
                            ),
                          ),

                          cancelAction: CancelAction(
                              title: Text('Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ))),
                        );
                      } else {
                        _makePhoneCall(widget.tel);
                      }
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE1F5DC),
                          Color(0xffD6EFB4),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            EvaIcons.peopleOutline,
                            color: Color(0xff2A302C),
                            size: 22,
                          ),
                          Text(widget.fullname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff464646))),
                          Text('ตำแหน่ง : ${widget.position}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff464646))),
                          Text(widget.tel,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xff464646)))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget photoPage() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 30, right: 30),
                //         child: SizedBox(
                //           height: 50,
                //           // width: 160,
                //           child: ElevatedButton(
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         report(jid: widget.jid)),
                //               );
                //             },
                //             style: ElevatedButton.styleFrom(
                //               foregroundColor: Colors.white,
                //               backgroundColor: Color(0xff2A302C),
                //               shadowColor: Colors.white,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //             ),
                //             child: Text(
                //               'แจ้งซ่อม',
                //               style: TextStyle(
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.w600,
                //                   color: Color(0xffAED76E)),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 30, left: 30, right: 30),
                        child: SizedBox(
                          height: 50,
                          // width: 160,
                          child: ElevatedButton(
                            onPressed: (totalpass == true)
                                ? () {
                                    controller.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xffAED76E),
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'ถัดไป',
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
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 0.9,
                  primary: false,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: List.generate(groupPic.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        print(groupPic[index].type_id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (widget.type ==
                                      3) // 3 = servay
                                  ? groupresearch(
                                      jidx: widget.jid,
                                      typeId: groupPic[index].type_id,
                                      typeName: groupPic[index].type_name,
                                      status: widget.j_status,
                                    )
                                  : (groupPic[index].type_id == 29 ||
                                          groupPic[index].type_id == 30 ||
                                          groupPic[index].type_id == 31 ||
                                          groupPic[index].type_id == 32 ||
                                          groupPic[index].type_id == 37 ||
                                          groupPic[index].type_id == 40)
                                      ? addaudit(
                                          jidx: widget.jid,
                                          typeId: groupPic[index].type_id,
                                          typeName: groupPic[index].type_name,
                                          status: widget.j_status,
                                          choice: groupPic[index].choice_flag,
                                          sid: widget.sid,
                                        )
                                      : groupaudit(
                                          jidx: widget.jid,
                                          typeId: groupPic[index].type_id,
                                          typeName: groupPic[index].type_name,
                                          status: widget.j_status,
                                          choice: groupPic[index].choice_flag,
                                        )),
                        ).then((value) {
                          setState(() {
                            API
                                .getGroupLs(widget.jid, widget.type)
                                .then((value) {
                              setState(() {
                                List list1 = json.decode(value.body);

                                groupPic = list1
                                    .map((m) => GroupLs.fromJson(m))
                                    .toList();

                                ispass = 0;
                                for (var i = 0; i < groupPic.length; i++) {
                                  if (groupPic[i].amount_sub_type_true ==
                                      groupPic[i].amount_sub_type_all) {
                                    ispass = ispass + 1;
                                  }
                                }
                                print(ispass);
                                if (ispass == groupPic.length) {
                                  totalpass = true;
                                } else {
                                  totalpass = false;
                                }
                              });
                            });
                          });
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: (groupPic[index].amount_sub_type_true ==
                                groupPic[index].amount_sub_type_all)
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffE1F5DC),
                                    Color(0xffD6EFB4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffAED76E).withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Color(0xffAED76E)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffAED76E).withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],
                              ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      EvaIcons.image2,
                                      color: Color(0xff2A302C),
                                    ),
                                    (widget.type == 3)
                                        ? Text(groupPic[index].type_name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Color(0xff2A302C),
                                            ))
                                        : Text(groupPic[index].type_name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xff2A302C),
                                            )),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          // border: Border.all(width: 3),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color: Color(0xff2A302C),
                                        ),
                                        child: Center(
                                          child: Text(
                                              '${groupPic[index].amount_sub_type_true}/${groupPic[index].amount_sub_type_all}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('งานทั้งหมด',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xff2A302C))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                )),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget sign() {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    onPressed:
                        (sign_name_1.isNotEmpty && sign_name_2.isNotEmpty)
                            ? () {
                                controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shadowColor: Colors.white,
                      backgroundColor: Color(0xffAED76E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ถัดไป',
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
      body: RefreshIndicator(
        onRefresh: () async {
          await getsign1(widget.jid);
          await getsign2(widget.jid);
        },
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: GestureDetector(
                      onTap: () async {
                        loading();
                        await getsign1(widget.jid);
                        await getsign2(widget.jid);
                        Navigator.pop(context);

                        (sign_name_1.isNotEmpty)
                            ? popsign(path_sign1)
                            : sheet('ผู้ติดต่อหน้างาน', 3);
                      },
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: (sign_name_1.isNotEmpty)
                              ? Color(0xff9DC75B)
                              : Color(0xffEEF5E2),
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: Color(0xffE0ECDE)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: (sign_name_1.isNotEmpty)
                                      ? Colors.white
                                      : Color(0xff9CC75B),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(EvaIcons.peopleOutline,
                                      size: 20,
                                      color: (sign_name_1.isNotEmpty)
                                          ? Color(0xff9CC75B)
                                          : Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ผู้ติดต่อหน้างาน',
                                    style: TextStyle(
                                        color: (sign_name_1.isNotEmpty)
                                            ? Colors.white
                                            : Color(0xffAED76E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  (sign_name_1.isNotEmpty)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            sign_name_1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: GestureDetector(
                      onTap: () async {
                        loading();
                        await getsign1(widget.jid);
                        await getsign2(widget.jid);
                        Navigator.pop(context);

                        (sign_name_2.isNotEmpty)
                            ? popsign(path_sign2)
                            : sheet('ช่าง', 2);
                      },
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: (sign_name_2.isNotEmpty)
                              ? Color(0xff9DC75B)
                              : Color(0xffEEF5E2),
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: Color(0xffE0ECDE)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: (sign_name_2.isNotEmpty)
                                      ? Colors.white
                                      : Color(0xff9CC75B),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(EvaIcons.peopleOutline,
                                      size: 20,
                                      color: (sign_name_2.isNotEmpty)
                                          ? Color(0xff9CC75B)
                                          : Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ช่าง',
                                    style: TextStyle(
                                        color: (sign_name_2.isNotEmpty)
                                            ? Colors.white
                                            : Color(0xffAED76E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  (sign_name_2.isNotEmpty)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            sign_name_2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget finished() {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                      (widget.j_status == 3)
                          ? Navigator.pop(context)
                          : confirmpop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffAED76E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      (widget.j_status == 3) ? 'เสร็จสิ้น' : 'ยืนยันส่งงาน',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'ยืนยันการส่งข้อมูล',
              style: TextStyle(
                  color: Color(0xffAED76E),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ระบบจะส่งข้อมูลหลังจากผู้ใช้งานกดปุ่มยืนยันส่งงาน หากมีการส่งข้อมูลแล้ว ผู้ใช้งานจะไม่สามารถเข้ามาแก้ไขข้อมูลเพิ่มเติมได้อีก',
              style: TextStyle(
                  color: Color(0xff464646),
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'หมายเหตุ',
              style: TextStyle(
                  color: Color(0xffAED76E),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xffD6EFB4)),
                ),
                child: TextField(
                  controller: remarkEnd,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  readOnly: (widget.j_status == 3) ? true : false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget sendPage() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
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
                padding: const EdgeInsets.only(
                    top: 0, bottom: 30, left: 30, right: 30),
                child: SizedBox(
                  height: 50,
                  // width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffAED76E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ตกลง',
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(
          children: [
            Text('ดำเนินงาน',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xffAED76E))),
            SizedBox(
              height: 10,
            ),
            GridView.count(
              shrinkWrap: true,
              childAspectRatio: 0.9,
              primary: false,
              crossAxisSpacing: 30,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              children: List.generate(groupPic.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (widget.type == 3) // 3 = servay
                              ? groupresearch(
                                  jidx: widget.jid,
                                  typeId: groupPic[index].type_id,
                                  typeName: groupPic[index].type_name,
                                  status: widget.j_status,
                                )
                              : (groupPic[index].type_id == 29 ||
                                      groupPic[index].type_id == 30 ||
                                      groupPic[index].type_id == 31 ||
                                      groupPic[index].type_id == 32 ||
                                      groupPic[index].type_id == 37 ||
                                      groupPic[index].type_id == 40)
                                  ? addaudit(
                                      jidx: widget.jid,
                                      typeId: groupPic[index].type_id,
                                      typeName: groupPic[index].type_name,
                                      status: widget.j_status,
                                      choice: groupPic[index].choice_flag,
                                      sid: widget.sid,
                                    )
                                  : groupaudit(
                                      jidx: widget.jid,
                                      typeId: groupPic[index].type_id,
                                      typeName: groupPic[index].type_name,
                                      status: widget.j_status,
                                      choice: groupPic[index].choice_flag,
                                    )),
                    ).then((value) {
                      setState(() {
                        API.getGroupLs(widget.jid, widget.type).then((value) {
                          setState(() {
                            List list1 = json.decode(value.body);

                            groupPic =
                                list1.map((m) => GroupLs.fromJson(m)).toList();

                            ispass = 0;
                            for (var i = 0; i < groupPic.length; i++) {
                              if (groupPic[i].amount_sub_type_true ==
                                  groupPic[i].amount_sub_type_all) {
                                ispass = ispass + 1;
                              }
                            }
                            print(ispass);
                            if (ispass == groupPic.length) {
                              totalpass = true;
                            } else {
                              totalpass = false;
                            }
                          });
                        });
                      });
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: (groupPic[index].amount_sub_type_true ==
                            groupPic[index].amount_sub_type_all)
                        ? BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffE1F5DC),
                                Color(0xffD6EFB4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffAED76E).withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          )
                        : BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xffAED76E)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffAED76E).withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  EvaIcons.image2,
                                  color: Color(0xff2A302C),
                                ),
                                (widget.type == 3)
                                    ? Text(groupPic[index].type_name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Color(0xff2A302C),
                                        ))
                                    : Text(groupPic[index].type_name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xff2A302C),
                                        )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      // border: Border.all(width: 3),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Color(0xff2A302C),
                                    ),
                                    child: Center(
                                      child: Text(
                                          '${groupPic[index].amount_sub_type_true}/${groupPic[index].amount_sub_type_all}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('งานทั้งหมด',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff2A302C))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            Text('ลายเซ็นต์',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xffAED76E))),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  (sign_name_1.isNotEmpty)
                      ? popsign(path_sign1)
                      : sheet('ผู้ติดต่อหน้างาน', 3);
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (sign_name_1.isNotEmpty)
                        ? Color(0xff9DC75B)
                        : Color(0xffEEF5E2),
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(color: Color(0xffE0ECDE)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: (sign_name_1.isNotEmpty)
                                ? Colors.white
                                : Color(0xff9CC75B),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(EvaIcons.peopleOutline,
                                size: 20,
                                color: (sign_name_1.isNotEmpty)
                                    ? Color(0xff9CC75B)
                                    : Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ผู้ติดต่อหน้างาน',
                              style: TextStyle(
                                  color: (sign_name_1.isNotEmpty)
                                      ? Colors.white
                                      : Color(0xffAED76E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            (sign_name_1.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      sign_name_1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  (sign_name_2.isNotEmpty)
                      ? popsign(path_sign2)
                      : sheet('ช่าง', 2);
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (sign_name_2.isNotEmpty)
                        ? Color(0xff9DC75B)
                        : Color(0xffEEF5E2),
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(color: Color(0xffE0ECDE)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: (sign_name_2.isNotEmpty)
                                ? Colors.white
                                : Color(0xff9CC75B),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(EvaIcons.peopleOutline,
                                size: 20,
                                color: (sign_name_2.isNotEmpty)
                                    ? Color(0xff9CC75B)
                                    : Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ช่าง',
                              style: TextStyle(
                                  color: (sign_name_2.isNotEmpty)
                                      ? Colors.white
                                      : Color(0xffAED76E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            (sign_name_2.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      sign_name_2,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text('หมายเหตุ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xffAED76E))),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xffD6EFB4)),
                ),
                child: TextField(
                  controller: remarkEnd,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  readOnly: (widget.j_status == 3) ? true : false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  void sheet(title, type) {
    var putname = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 10),
                        child: Row(
                          children: [
                            Text(title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Color(0xffAED76E))),
                          ],
                        ),
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
                          border: Border.all(color: Color(0xffAED76E)),
                        ),
                        child: TextField(
                          controller: putname,
                          // textInputAction: TextInputAction.done,

                          decoration: InputDecoration(
                            hintText: 'ชื่อ-นามสกุล',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (putname.text.isEmpty) {
                                pop('กรุณากรอกชื่อ-นามสกุล');
                              } else {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signature(
                                            jidx: widget.jid,
                                            imgType: type,
                                            signName: putname.text,
                                            user: userName,
                                            type: widget.type,
                                          )),
                                ).then((value) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                  ]);
                                  setState(() {
                                    getsign1(widget.jid);
                                    getsign2(widget.jid);
                                  });
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  pop(title) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return (defaultTargetPlatform == TargetPlatform.android)
              ? AlertDialog(
                  actionsPadding: EdgeInsets.all(5),
                  // title: Text(
                  //     'ต้องการลบข้อมูลหรือไม่'),
                  contentPadding: EdgeInsets.only(top: 30, bottom: 20),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); //close Dialog
                      },
                      child: Text('ตกลง'),
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  content: Text(title),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); //close Dialog
                      },
                      child: Text('ตกลง'),
                    ),
                  ],
                );
        });
  }
}

//api
class API {
  static Future getContactLs(idd) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobContactMobileLs'),
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

  static Future getGroupLs(idd, typ) async {
    final response = await http.post(
      Uri.parse((typ == 3)
          ? '$api/api/mobile/getJobHeaderImageForSurvey'
          : '$api/api/mobile/getJobHeaderImageForAudit'),
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
  final String j_cont_name;
  final String j_cont_position;
  final String j_cont_tel;

  const Album({
    required this.j_cont_name,
    required this.j_cont_position,
    required this.j_cont_tel,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      j_cont_name:
          '${json['j_cont_fname'] ?? ''} ${json['j_cont_lname'] ?? ''}',
      j_cont_position: json['j_cont_position'],
      j_cont_tel: json['j_cont_tel'],
    );
  }
}

class GroupLs {
  final int type_id;
  final String type_name;
  final int amount_sub_type_true;
  final int amount_sub_type_all;
  final int? choice_flag;

  const GroupLs(
      {required this.type_id,
      required this.type_name,
      required this.amount_sub_type_true,
      required this.amount_sub_type_all,
      required this.choice_flag});

  factory GroupLs.fromJson(Map<String, dynamic> json) {
    return GroupLs(
        type_id: json['type_id'],
        type_name: json['type_name'],
        amount_sub_type_true: json['amount_sub_type_true'],
        amount_sub_type_all: json['amount_sub_type_all'],
        choice_flag: json['choice_flag']);
  }
}
