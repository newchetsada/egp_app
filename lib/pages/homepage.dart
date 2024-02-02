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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:egp_app/config.dart';

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
  final _controller = PageController(initialPage: 0);
  int _selectedIndex = 0;

  _getAPI(id) {
    var idd = id;
    API.getWorkLs(idd).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          List list = json.decode(response.body);
          print(list);

          works = list.map((m) => Album.fromJson(m)).toList();
          datetime = DateTime.now();
          load = false;

          // isLoading = false;
        });
      } else {
        setState(() {
          hasinternet = false;
          load = false;
        });
      }
    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    print(prefs.getString('user'));
    if (prefs.getString('user') != null) {
      setState(() {
        userName = prefs.getString('user') ?? '';
        iduser = prefs.getInt('id')!;
      });
    }
  }

  Future getUserDetail(userId) async {
    try {
      var response = await http.post(
        Uri.parse('$api/api/master/getTechnicianLs'),
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
        print(jsonResponse);

        setState(() {
          fullname =
              '${jsonResponse[0]['tech_fname']} ${jsonResponse[0]['tech_lname']}';
        });
      } else {
        setState(() {
          hasinternet = false;
          load = false;
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

  bool load = true;
  bool hasinternet = true;

  void checkNet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      getUser().then((value) {
        getUserDetail(iduser);
        _getAPI(iduser);
      });
    } else {
      print('No internet :( Reason:');
      setState(() {
        hasinternet = false;
        load = false;
      });
      // print(InternetConnectionChecker().lastTryResults);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // getUser().then((value) {
    //   getUserDetail(iduser);
    //   _getAPI(iduser);
    // });
    checkNet();
  }

  @override
  Widget build(BuildContext context) {
    return (load == true)
        ? Scaffold(
            body: Center(
                child: Lottie.asset('assets/logoloading.json', height: 90)))
        : (hasinternet == false)
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/internet.png',
                      //   height: 150,
                      // ),
                      Icon(
                        CupertinoIcons.wifi_exclamationmark,
                        size: 150,
                        color: Color(0xff818181),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'อินเทอร์เน็ตมีปัญหา',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff9DC75B),
                            fontSize: 20),
                      ),
                      Text(
                        'โปรดตรวจสอบการเชื่อมต่อและลองอีกครั้ง',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff818181),
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xff9DC75B)),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'ลองอีกครั้ง',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              )
            : DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(125.0),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      flexibleSpace: SafeArea(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Hello, $fullname',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Color(0xff9DC75B),
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  IconButton(
                                      iconSize: 30,
                                      splashRadius: 20,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  settingPage()),
                                        ).then((value) {
                                          setState(() {
                                            getUserDetail(iduser);
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.settings_rounded,
                                        color: Color(0xff9DC75B),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                      _controller.animateToPage(0,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease);
                                    },
                                    child: (_selectedIndex == 0)
                                        ? Container(
                                            height: 35,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: Color(0xffAED76E)),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'งาน',
                                                  style: TextStyle(
                                                      color: Color(0xff2A302C),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 35,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: Color(0xffffffff),
                                                border: Border.all(
                                                    color: Color(0xffAED76E))),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'งาน',
                                                  style: TextStyle(
                                                      color: Color(0xff9DC75B),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                      });
                                      _controller.animateToPage(1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease);
                                    },
                                    child: (_selectedIndex == 1)
                                        ? Container(
                                            height: 35,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: Color(0xffAED76E)),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'เสร็จสิ้น',
                                                  style: TextStyle(
                                                      color: Color(0xff2A302C),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 35,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: Color(0xffffffff),
                                                border: Border.all(
                                                    color: Color(0xffAED76E))),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'เสร็จสิ้น',
                                                  style: TextStyle(
                                                      color: Color(0xff9DC75B),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.white,
                      // bottom: TabBar(
                      //   splashBorderRadius: BorderRadius.all(Radius.circular(15)),
                      //   indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                      //   indicatorWeight: 5,
                      //   indicatorColor: Color(0xff57A946),
                      //   labelStyle: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 15,
                      //   ),
                      //   labelColor: Color(0xff57A946),
                      //   unselectedLabelColor: Color(0xff9D9D9D),
                      //   tabs: <Widget>[
                      //     Icon(Icons.abc)
                      //     // Tab(
                      //     //   text: 'งาน',
                      //     // ),,
                      //     ,
                      //     Tab(
                      //       text: 'เสร็จสิ้น',
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                  body: PageView(
                    controller: _controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Center(
                        child: RefreshIndicator(
                          onRefresh: () => _ref(),
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 30),
                            itemCount: works.length,
                            itemBuilder: (context, index) {
                              return (works[index].j_status == 3)
                                  ? Container()
                                  : cardWork(
                                      works[index].type_id,
                                      works[index].j_status,
                                      works[index].startdate,
                                      works[index].cus_name,
                                      works[index].jidx,
                                      works[index].j_no,
                                      works[index].job_newly_delayed,
                                      // works[index].senddate
                                    );
                            },
                          ),
                        ),
                      ),
                      //finished
                      Center(
                        child: RefreshIndicator(
                          onRefresh: () => _ref(),
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 30),
                            itemCount: works.length,
                            itemBuilder: (context, index) {
                              return (works[index].j_status == 3)
                                  ? cardWork(
                                      works[index].type_id,
                                      works[index].j_status,
                                      works[index].startdate,
                                      works[index].cus_name,
                                      works[index].jidx,
                                      works[index].j_no,
                                      works[index].job_newly_delayed,
                                      // works[index].senddate
                                    )
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

  Widget cardWork(type, status, datestart, comp, id, sn, delay) {
    var col = (status == 1)
        ? Color(0xff1975D0)
        : (status == 2)
            ?
            // (datetime.isAfter(DateTime.parse(datesend)))
            //     ? Color(0xffE44E47)
            //     :
            Color(0xff7540EE)
            : (status == 3)
                ? Color(0xff2DAC34)
                : (status == 5)
                    ? Color(0xffE44E47)
                    : Color(0xff9DC75B);
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
          String amount = '';
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
          int belt_flag = 0;
          String j_remark_complete = '';
          int? sid;
          String site_layout = '';
          List sitepic = [];

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
            if (jsonResponse != null) {
              setState(() {
                print(jsonResponse);
                j_start_date = DateFormat('dd/MM/yyyy HH:mm')
                    .format(DateTime.parse(jsonResponse[0]['j_start_date']))
                    .toString();
                j_send_date = DateFormat('dd/MM/yyyy HH:mm')
                    .format(DateTime.parse(jsonResponse[0]['j_send_date']))
                    .toString();
                cus_name = jsonResponse[0]['cus_name'] ?? '';
                site_name = jsonResponse[0]['site_name'] ?? '';
                cus_address =
                    '${jsonResponse[0]['cus_address'] ?? ''} ${jsonResponse[0]['tambon_th'] ?? ''} ${jsonResponse[0]['amphur_th'] ?? ''} ${jsonResponse[0]['province_th'] ?? ''} ${jsonResponse[0]['postcode'] ?? ''}';
                install_date = (jsonResponse[0]['install_date'] == null)
                    ? ''
                    : DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(jsonResponse[0]['install_date']))
                        .toString();
                warranty_expire = (jsonResponse[0]['warranty_expire'] == null)
                    ? ''
                    : DateFormat('dd/MM/yyyy')
                        .format(
                            DateTime.parse(jsonResponse[0]['warranty_expire']))
                        .toString();
                power_peak = (jsonResponse[0]['power_peak'] == null)
                    ? ''
                    : jsonResponse[0]['power_peak'].toString();
                amount = (jsonResponse[0]['amount'] == null)
                    ? ''
                    : jsonResponse[0]['amount'].toString();
                j_detail = jsonResponse[0]['j_detail'] ?? '';
                remark_tech = jsonResponse[0]['remark_tech'] ?? '';
                lat = (jsonResponse[0]['lat'] == null)
                    ? 0.0
                    : jsonResponse[0]['lat'].toDouble();
                lon = (jsonResponse[0]['lon'] == null)
                    ? 0.0
                    : jsonResponse[0]['lon'].toDouble();
                site_clener = jsonResponse[0]['site_clener'] ?? '';
                // fullname =
                //     '${jsonResponse[0]['tech_fname']} ${jsonResponse[0]['tech_lname']}';
                fullname = jsonResponse[0]['fullname'] ?? '';
                position = jsonResponse[0]['position'] ?? '';
                tel = jsonResponse[0]['tel'] ?? '';
                j_status = jsonResponse[0]['j_status'];
                ppe_flag = jsonResponse[0]['ppe_flag'];
                j_remark_complete = jsonResponse[0]['j_remark_complete'] ?? '';
                sid = jsonResponse[0]['sid'];
                site_layout = jsonResponse[0]['site_layout'] ?? '';
                sitepic = jsonResponse[0]['images'] ?? [];
                belt_flag = jsonResponse[0]['belt_flag'] ?? 0;
              });
            }
          }).then((value) {
            Navigator.pop(context);
            (sid == 0)
                ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เกิดข้อผิดพลาด โปรดลองอีกครั้ง'),
                      backgroundColor: Colors.red,
                    ),
                  )
                : (type == 0)
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
                                  j_remark_complete: j_remark_complete,
                                  sid: sid ?? 0,
                                  pic: site_layout,
                                  sitepic: sitepic,
                                  belt_flag: belt_flag,
                                  amount: amount,
                                  type: type,
                                )),
                      ).then((value) => _ref())
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
                                      j_remark_complete: j_remark_complete,
                                      pic: site_layout,
                                      sid: sid ?? 0,
                                      sitepic: sitepic,
                                      belt_flag: belt_flag,
                                      amount: amount,
                                      type: type,
                                    ))).then((value) => _ref())
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
                                      type: type,
                                      pic: site_layout,
                                      sid: sid,
                                      sitepic: sitepic,
                                      belt_flag: belt_flag,
                                      amount: amount,
                                    )),
                          ).then((value) => _ref());
          });
        },
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffF5F5F5))
              // boxShadow: [
              //   BoxShadow(
              //     color: Color(0xff57A946).withOpacity(0.1),
              //     blurRadius: 10,
              //     spreadRadius: 0,
              //     offset: Offset(0, 0), // Shadow position
              //   ),
              // ],
              ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
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
                                color: Color(0xff9DC75B),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$sn',
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 2,
                            color: Color(0xff9DC75B),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'บริษัท : $comp',
                                style: TextStyle(
                                    color: Color(0xff464646),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'ไซต์ : $comp',
                                style: TextStyle(
                                    color: Color(0xff464646),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // (status == 1)
                      //     ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 15,
                                color: col,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(datestart)),
                                style: TextStyle(
                                    color: col,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.access_time_filled_rounded,
                                size: 15,
                                color: col,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat('HH:mm')
                                    .format(DateTime.parse(datestart)),
                                style: TextStyle(
                                    color: col,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              (status == 1)
                                  ? Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
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
                                  : (status == 2 || status == 5)
                                      ? Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color(0xffE4D8FF)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                'กำลังดำเนินงาน',
                                                style: TextStyle(
                                                    color: Color(0xff7540EE),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      : (status == 3)
                                          ? Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Color(0xffD5FFD9)),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    'เสร็จสิ้น',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff2DAC34),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                              (delay == 1)
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xffFEF0D6)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              'เลยกำหนด',
                                              style: TextStyle(
                                                  color: Color(0xffFBB237),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (status == 5)
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xffFFF0F8)),
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
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
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
        Uri.parse('$api/api/mobile/getJobAttempMobileLs'),
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
      } else {
        getWorkdetail(userId, jidx);
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
      Uri.parse('$api/api/mobile/getJobAttempMobileLs'),
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
  final String senddate;
  final String j_no;
  final int job_newly_delayed;

  const Album(
      {required this.jidx,
      required this.j_detail,
      required this.startdate,
      required this.cus_name,
      required this.j_status,
      required this.type_id,
      required this.senddate,
      required this.j_no,
      required this.job_newly_delayed});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        jidx: json['jidx'],
        j_detail:
            (json['j_detail'].toString() == 'null') ? "" : json['j_detail'],
        startdate: json['j_start_date'],
        cus_name: json['cus_name'],
        j_status: json['j_status'],
        type_id: json['type_flag'],
        senddate: json['j_send_date'],
        j_no: json['j_no'],
        job_newly_delayed: json['job_newly_delayed']);
  }
}
