import 'dart:convert';

import 'package:egp_app/clean/cleansolar.dart';
import 'package:egp_app/login.dart';
import 'package:egp_app/pages/settingpage.dart';
import 'package:egp_app/repair/repair.dart';
import 'package:egp_app/research/research.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String userName = "Loading...";
  int? iduser;
  var works = <Album>[];
  DateTime datetime = DateTime.now();

  String fullname = 'Loading...';

  _getAPI(id) {
    var idd = id;
    API.getWorkLs(idd).then((response) {
      setState(() {
        List list = json.decode(response.body);
        works = list.map((m) => Album.fromJson(m)).toList();
        datetime = DateTime.now();

        // isLoading = false;
      });
    });
  }

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

  Future getUserDetail(userId) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/master/getTechnicianLs'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'techId': userId,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        setState(() {
          fullname = jsonResponse[0]['tech_fullname'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _ref() async {
    setState(() {
      _getAPI(iduser);
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getUser().then((value) {
      getUserDetail(iduser);
      _getAPI(iduser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello, $fullname',
                        style: TextStyle(
                            color: Color(0xff57A946),
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => settingPage()),
                            ).then((value) {
                              setState(() {
                                getUserDetail(iduser);
                              });
                            });
                          },
                          icon: Icon(
                            Icons.settings_rounded,
                            color: Color(0xff96A7AF),
                          ))
                    ],
                  ),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            bottom: TabBar(
              splashBorderRadius: BorderRadius.all(Radius.circular(15)),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
              indicatorWeight: 5,
              indicatorColor: Color(0xff57A946),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              labelColor: Color(0xff57A946),
              unselectedLabelColor: Color(0xff9D9D9D),
              tabs: <Widget>[
                Tab(
                  text: 'งาน',
                ),
                Tab(
                  text: 'เสร็จสิ้น',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(
              child: RefreshIndicator(
                onRefresh: () => _ref(),
                child: ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    return (works[index].j_status == 3)
                        ? Container()
                        : cardWork(
                            works[index].type_id,
                            works[index].j_status,
                            works[index].startdate,
                            works[index].cus_name,
                            works[index].jidx);
                  },
                ),
              ),
            ),
            //finished
            Center(
              child: RefreshIndicator(
                onRefresh: () => _ref(),
                child: ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    return (works[index].j_status == 3)
                        ? cardWork(
                            works[index].type_id,
                            works[index].j_status,
                            works[index].startdate,
                            works[index].cus_name,
                            works[index].jidx)
                        : Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskall() {
    return Center(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [],
      ),
    );
  }

  Widget cardWork(type, status, date, comp, id) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          //detail
          String j_start_date = '';
          String j_send_date = '';
          String cus_name = '';
          String site_name = '';
          String cus_address = '';
          String install_date = '';
          String warranty_expire = '';
          String power_peak = '';
          String j_detail = '';
          String remark_tech = '';
          double lat = 0;
          double lon = 0;
          String site_clener = '';
          String fullname = '';
          String position = '';
          String tel = '';
          int j_status = 0;
          int ppe_flag = 0;
          String j_remark_complete = '';

          //
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
                        child: Lottie.asset('assets/logoloading.json',
                            height: 80)),
                  ),
                );
              });

          getWorkdetail(iduser, id).then((jsonResponse) {
            setState(() {
              j_start_date = DateFormat('dd/MM/yyyy HH:mm')
                  .format(DateTime.parse(jsonResponse[0]['j_start_date']))
                  .toString();
              j_send_date = DateFormat('dd/MM/yyyy HH:mm')
                  .format(DateTime.parse(jsonResponse[0]['j_send_date']))
                  .toString();
              cus_name = jsonResponse[0]['cus_name'];
              site_name = jsonResponse[0]['site_name'];
              cus_address = jsonResponse[0]['cus_address'] +
                  ' ' +
                  jsonResponse[0]['tambon_th'] +
                  ' ' +
                  jsonResponse[0]['amphur_th'] +
                  ' ' +
                  jsonResponse[0]['province_th'] +
                  ' ' +
                  jsonResponse[0]['postcode'];
              install_date = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(jsonResponse[0]['install_date']))
                  .toString();
              warranty_expire = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(jsonResponse[0]['warranty_expire']))
                  .toString();
              power_peak = jsonResponse[0]['power_peak'].toString();
              j_detail = jsonResponse[0]['j_detail'];
              remark_tech = jsonResponse[0]['remark_tech'];
              lat = jsonResponse[0]['lat'];
              lon = jsonResponse[0]['lon'];
              site_clener = jsonResponse[0]['site_clener'];
              fullname = jsonResponse[0]['fullname'];
              position = jsonResponse[0]['position'];
              tel = jsonResponse[0]['tel'];
              j_status = jsonResponse[0]['j_status'];
              ppe_flag = jsonResponse[0]['ppe_flag'];
              j_remark_complete = (jsonResponse[0]['j_remark_complete'] == null)
                  ? ''
                  : jsonResponse[0]['j_remark_complete'];
            });
          }).then((value) {
            Navigator.pop(context);
            (type == 0)
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => cleansolar(
                            jid: id,
                            j_start_date: j_start_date,
                            j_send_date: j_send_date,
                            cus_name: cus_name,
                            cus_address: cus_address,
                            install_date: install_date,
                            warranty_expire: warranty_expire,
                            power_peak: power_peak,
                            j_detail: j_detail,
                            remark_tech: remark_tech,
                            lat: lat,
                            lon: lon,
                            site_name: site_name,
                            fullname: fullname,
                            position: position,
                            tel: tel,
                            j_status: j_status,
                            ppe_flag: ppe_flag,
                            j_remark_complete: j_remark_complete)),
                  )
                : (type == 1 || type == 2)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => repair(
                                jid: id,
                                j_start_date: j_start_date,
                                j_send_date: j_send_date,
                                cus_name: cus_name,
                                cus_address: cus_address,
                                install_date: install_date,
                                warranty_expire: warranty_expire,
                                power_peak: power_peak,
                                j_detail: j_detail,
                                remark_tech: remark_tech,
                                lat: lat,
                                lon: lon,
                                site_name: site_name,
                                fullname: fullname,
                                position: position,
                                tel: tel,
                                j_status: j_status,
                                ppe_flag: ppe_flag,
                                j_remark_complete: j_remark_complete)))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => research(
                                jid: id,
                                j_start_date: j_start_date,
                                j_send_date: j_send_date,
                                cus_name: cus_name,
                                cus_address: cus_address,
                                install_date: install_date,
                                warranty_expire: warranty_expire,
                                power_peak: power_peak,
                                j_detail: j_detail,
                                remark_tech: remark_tech,
                                lat: lat,
                                lon: lon,
                                site_name: site_name,
                                fullname: fullname,
                                position: position,
                                tel: tel,
                                j_status: j_status,
                                ppe_flag: ppe_flag,
                                j_remark_complete: j_remark_complete,
                                type: type)),
                      );
          });
        },
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xff57A946).withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (type == 0)
                                ? 'ล้างแผง'
                                : (type == 1 || type == 2)
                                    ? 'ซ่อมบำรุง'
                                    : (type == 3)
                                        ? 'สำราจสถานที่'
                                        : 'ตรวจสอบประจำปี',
                            style: TextStyle(
                                color: Color(0xff064046),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(DateTime.parse(date)),
                            style: TextStyle(
                                color: Color(0xff464646),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Text(
                        'บริษัท : $comp',
                        style: TextStyle(
                            color: Color(0xff464646),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      // (status == 1)
                      //     ?
                      Row(
                        children: [
                          (status == 1)
                              ? Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Color(0xffE3EFFF)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'งานใหม่',
                                        style: TextStyle(
                                            color: Color(0xff1975D0),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              : (status == 2)
                                  ? Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Color(0xffE4D8FF)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'กำลังดำเนินงาน',
                                            style: TextStyle(
                                                color: Color(0xff7540EE),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    )
                                  : (status == 3)
                                      ? Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color(0xffD5FFD9)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                'เสร็จสิ้น',
                                                style: TextStyle(
                                                    color: Color(0xff2DAC34),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                          SizedBox(
                            width: 5,
                          ),
                          (status == 3)
                              ? Container()
                              : (datetime.isAfter(DateTime.parse(date)))
                                  ? Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Color.fromARGB(
                                              255, 255, 214, 211)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'ล่าช้า',
                                            style: TextStyle(
                                                color: Color(0xffE44E47),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget taskloading() {
  //   return Center(
  //     child: RefreshIndicator(
  //       onRefresh: () => _ref(),
  //       child: ListView(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //             child: Container(
  //               height: 200,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                   color: Colors.blueGrey,
  //                   borderRadius: BorderRadius.circular(20)),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //             child: Container(
  //               height: 200,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                   color: Colors.blueGrey,
  //                   borderRadius: BorderRadius.circular(20)),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //             child: Container(
  //               height: 200,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                   color: Colors.blueGrey,
  //                   borderRadius: BorderRadius.circular(20)),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
  //             child: Container(
  //               height: 200,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                   color: Colors.blueGrey,
  //                   borderRadius: BorderRadius.circular(20)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future getWorkdetail(userId, jidx) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/getJobAttempMobileLs'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'techId': userId,
          'jidx': jidx,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      }
    } catch (error) {
      print(error);
    }
  }
}

//api
class API {
  static Future getWorkLs(idd) async {
    final response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobAttempMobileLs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-Key': 'evdplusm8DdW+Wd3UCweHj',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'techId': idd,
        'jidx': null,
      }),
    );
    return response;
  }
}

class Album {
  final int jidx;
  final String j_detail;
  final String startdate;
  final String cus_name;
  final int j_status;
  final int type_id;

  const Album(
      {required this.jidx,
      required this.j_detail,
      required this.startdate,
      required this.cus_name,
      required this.j_status,
      required this.type_id});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      jidx: json['jidx'],
      j_detail: (json['j_detail'].toString() == 'null') ? "" : json['j_detail'],
      startdate: json['j_start_date'],
      cus_name: json['cus_name'],
      j_status: json['j_status'],
      type_id: json['type_flag'],
    );
  }
}
