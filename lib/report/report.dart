import 'dart:convert';

import 'package:egp_app/repair/hero_dialog_route.dart';
import 'package:egp_app/report/report-uploadmounting.dart';
import 'package:egp_app/report/report-uploadpic.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:egp_app/config.dart';

class report extends StatefulWidget {
  @override
  _reportState createState() => _reportState();

  final int jid;
  final int sid;
  final int? ref_jidx_repair;
  final int cusId;
  final String username;
  final int tecId;
  report(
      {required this.jid,
      required this.sid,
      required this.ref_jidx_repair,
      required this.cusId,
      required this.username,
      required this.tecId});
}

class _reportState extends State<report> {
  var groupPic = <picLs>[];
  int? ref;

  _getAPI(id) {
    var idd = id;

    API.getPicLs(idd).then((value) {
      setState(() {
        List list1 = json.decode(value.body);

        groupPic = list1.map((m) => picLs.fromJson(m)).toList();
      });
    });
    return 'true';
  }

  Future getWork(idd, jidx) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobAttempMobileLs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'techId': idd,
        'jidx': jidx,
      }),
    );
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    print(widget.ref_jidx_repair);
    (widget.ref_jidx_repair == null)
        ? null
        : API.getPicLs(widget.ref_jidx_repair).then((value) {
            setState(() {
              ref = widget.ref_jidx_repair;
              List list1 = json.decode(value.body);

              groupPic = list1.map((m) => picLs.fromJson(m)).toList();
            });
          });
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
            (defaultTargetPlatform == TargetPlatform.android) ? 160 : 140,
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
                      Text('แจ้งซ่อม',
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
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 30, right: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                HeroDialogRoute(
                                    builder: (BuildContext context) =>
                                        _buildPopUp(context)));
                          },
                          child: Hero(
                            tag: "bg",
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // color: Color(0xff57A946),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xffE1F5DC),
                                      Color(0xffD6EFB4),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('เพิ่มเรื่องซ่อมบำรุง',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Color(0xff2A302C))),
                                      Icon(
                                        EvaIcons.plusCircle,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.2,
              primary: false,
              crossAxisSpacing: 30,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: List.generate(groupPic.length, (index) {
                return GestureDetector(
                  onTap: () {
                    if (groupPic[index].type_id == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportuploadPicMounting(
                                    jidx: widget.jid,
                                    type_id: groupPic[index].type_id,
                                    sid: widget.sid,
                                    cusId: widget.cusId,
                                    ref_jidx_repair: ref,
                                    username: widget.username,
                                  ))).then((value) {
                        getWork(widget.tecId, widget.jid).then((val) {
                          var jsonResponse = json.decode(val);
                          print(jsonResponse[0]['ref_jidx_repair']);
                          if (jsonResponse[0]['ref_jidx_repair'] != null) {
                            API
                                .getPicLs(jsonResponse[0]['ref_jidx_repair'])
                                .then((value) {
                              setState(() {
                                ref = jsonResponse[0]['ref_jidx_repair'];
                                List list1 = json.decode(value.body);
                                groupPic = list1
                                    .map((m) => picLs.fromJson(m))
                                    .toList();
                              });
                            });
                          }
                        });
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportuploadPic(
                                    jidx: widget.jid,
                                    type_id: groupPic[index].type_id,
                                    sid: widget.sid,
                                    cusId: widget.cusId,
                                    ref_jidx_repair: widget.ref_jidx_repair,
                                    username: widget.username,
                                  ))).then((value) {
                        getWork(widget.tecId, widget.jid).then((val) {
                          var jsonResponse = json.decode(val);
                          print(jsonResponse[0]['ref_jidx_repair']);
                          if (jsonResponse[0]['ref_jidx_repair'] != null) {
                            API
                                .getPicLs(jsonResponse[0]['ref_jidx_repair'])
                                .then((value) {
                              setState(() {
                                ref = jsonResponse[0]['ref_jidx_repair'];
                                List list1 = json.decode(value.body);
                                groupPic = list1
                                    .map((m) => picLs.fromJson(m))
                                    .toList();
                              });
                            });
                          }
                        });
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
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
                          color: Color(0xff57A946).withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  EvaIcons.plusSquare,
                                  color: Color(0xff2A302C),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(groupPic[index].type_name,
                                      // overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff2A302C),
                                      )),
                                ),
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
                                    width: 45,
                                    decoration: BoxDecoration(
                                      // border: Border.all(width: 3),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(13),
                                      ),
                                      color: Color(0xff2A302C),
                                    ),
                                    child: Center(
                                      child: Text(
                                          '${groupPic[index].before_suc}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                  ),
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
          ),
        ],
      ),
    );
  }

  _buildPopUp(BuildContext context) {
    return Center(
      child: Hero(
          tag: "bg",
          child: Material(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Color(0xffE1F5DC),
                  //     Color(0xffD6EFB4),
                  //   ],
                  // ),
                  color: Color(0xffF8FFF6)),
              child: SafeArea(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text('เลือกอุปกรณ์ซ่อมบำรุง',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Color(0xff57A946))),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // Divider(
                    //   thickness: 0.5,
                    //   color: Color(0xff2A302C),
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 1,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          getWork(widget.tecId, widget.jid).then((val) {
                            var jsonResponse = json.decode(val);
                            print(jsonResponse[0]['ref_jidx_repair']);
                            if (jsonResponse[0]['ref_jidx_repair'] != null) {
                              API
                                  .getPicLs(jsonResponse[0]['ref_jidx_repair'])
                                  .then((value) {
                                setState(() {
                                  ref = jsonResponse[0]['ref_jidx_repair'];
                                  List list1 = json.decode(value.body);
                                  groupPic = list1
                                      .map((m) => picLs.fromJson(m))
                                      .toList();
                                });
                              });
                            }
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('PV (แผงโซลาเซลล์)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPicMounting(
                                      jidx: widget.jid,
                                      type_id: 2,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Mounting',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 3,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Inverter',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 4,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('ตู้ DC',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 17,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('ตู้ AC',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 5,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Fuse',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 6,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Breaker',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 7,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Switch',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 8,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Optimizer',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportuploadPic(
                                      jidx: widget.jid,
                                      type_id: 9,
                                      sid: widget.sid,
                                      cusId: widget.cusId,
                                      ref_jidx_repair: ref,
                                      username: widget.username,
                                    ))).then((value) {
                          setState(() {
                            getWork(widget.tecId, widget.jid).then((val) {
                              var jsonResponse = json.decode(val);
                              print(jsonResponse[0]['ref_jidx_repair']);
                              if (jsonResponse[0]['ref_jidx_repair'] != null) {
                                API
                                    .getPicLs(
                                        jsonResponse[0]['ref_jidx_repair'])
                                    .then((value) {
                                  setState(() {
                                    ref = jsonResponse[0]['ref_jidx_repair'];
                                    List list1 = json.decode(value.body);
                                    groupPic = list1
                                        .map((m) => picLs.fromJson(m))
                                        .toList();
                                  });
                                });
                              }
                            });
                          });
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('สายไฟ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff9DC75B))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IconButton(
                        iconSize: 30,
                        color: Color(0xff57A946),
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined)),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

//api
class API {
  static Future getPicLs(idd) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobHeaderImageForRepair'),
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

class picLs {
  final int type_id;
  final String type_name;
  final int before_suc;
  final int after_suc;

  const picLs(
      {required this.type_id,
      required this.type_name,
      required this.before_suc,
      required this.after_suc});

  factory picLs.fromJson(Map<String, dynamic> json) {
    return picLs(
        type_id: json['type_id'],
        type_name: json['type_name'],
        before_suc: json['before_suc'],
        after_suc: json['after_suc']);
  }
}
