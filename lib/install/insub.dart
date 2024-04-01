import 'dart:convert';

import 'package:egp_app/config.dart';
import 'package:egp_app/install/inup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class insub extends StatefulWidget {
  _insubState createState() => _insubState();
  final int jidx;
  final String title;
  final String userName;
  final int status;
  final String date;
  final int no;
  insub(
      {required this.title,
      required this.jidx,
      required this.status,
      required this.userName,
      required this.date,
      required this.no});
}

class _insubState extends State<insub> {
  bool loading = true;
  List<SubType> sub = [];
  String date = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.date.isEmpty) {
      date = DateFormat.MMMMEEEEd("th").format(DateTime.now()).toString();
    } else {
      date = DateFormat.MMMMEEEEd("th")
          .format(DateTime.parse(widget.date))
          .toString();
    }
    API
        .getGroupLs(widget.jidx, widget.title, widget.date, widget.no)
        .then((value) {
      setState(() {
        List list = json.decode(value.body);
        sub = list.map((m) => SubType.fromJson(m)).toList();
        print(list);
        loading = false;
      });
    });
  }

  void loadingPop() {
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
                        date,
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
                                '${widget.title}',
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
                ),
              ],
            ),
          )),
        ),
      ),
      body: (loading == true)
          ? ListView.builder(
              itemCount: 3,
              padding: EdgeInsets.symmetric(horizontal: 30),
              itemBuilder: ((context, index) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.5, color: Color(0xff9DC75B))),
                      ),
                    ));
              }))
          : ListView.builder(
              itemCount: sub.length,
              padding: EdgeInsets.symmetric(horizontal: 30),
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => inup(
                                    title: sub[index].sub_type_install_name,
                                    status: widget.status,
                                    jTaskId: sub[index].j_task_id,
                                    jidx: widget.jidx,
                                    userName: widget.userName,
                                    date: widget.date,
                                    curValue: sub[index].percent,
                                  )))).then((va) {
                        API
                            .getGroupLs(widget.jidx, widget.title, widget.date,
                                widget.no)
                            .then((value) {
                          setState(() {
                            List list = json.decode(value.body);
                            sub = list.map((m) => SubType.fromJson(m)).toList();
                            print(list);
                            loading = false;
                          });
                        });
                      });
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 0.5, color: Color(0xff9DC75B))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${sub[index].sub_type_install_name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0xff57A946),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${sub[index].percent} %',
                                style: TextStyle(
                                    color: Color(0xff57A946),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}

//api
class API {
  static Future getGroupLs(idd, typeInstallName, date, no) async {
    final response = await http.post(
      Uri.parse('$api/api/mobile/getJobSubHeaderImageForInstall'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'jidx': idd,
        'typeInstallName': typeInstallName,
        'sortDate': date,
        'no': no
      }),
    );

    return response;
  }
}

class SubType {
  final int j_task_id;
  final String sub_type_install_name;
  final double percent;

  const SubType(
      {required this.j_task_id,
      required this.sub_type_install_name,
      required this.percent});

  factory SubType.fromJson(Map<String, dynamic> json) {
    return SubType(
      j_task_id: json['j_task_id'],
      sub_type_install_name: json['sub_type_install_name'],
      percent: json['percent'],
    );
  }
}
