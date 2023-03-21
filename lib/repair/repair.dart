import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:egp_app/clean/photopage.dart';
import 'package:egp_app/clean/signature.dart';
import 'package:egp_app/pages/homepage.dart';
import 'package:egp_app/repair/uploadpic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'hero_dialog_route.dart';

class repair extends StatefulWidget {
  @override
  _repairState createState() => _repairState();
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

  //

  repair({
    required this.jid,
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
  });
}

class _repairState extends State<repair> {
  PageController controller = PageController(initialPage: 0);
  int _curpage = 0;
  var contact = <Album>[];
  bool contactloading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Future.delayed(const Duration(milliseconds: 500), () {
    _getAPI(widget.jid);
    // });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
        contactloading = false;
      });
    });
  }

  void confirmpop() {
    showDialog<void>(
      context: context,
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
                      color: Color(0xff149C32)),
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => homePage()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff149C32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: Text(
                          'ยืนยันส่งงาน',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
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
        backgroundColor: Color(0xff149C32),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            (_curpage == 0) ? 'รายละเอียด' : 'ดำเนินงาน',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xff149C32),
          leading: IconButton(
              splashRadius: 15,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_curpage == 0) {
                  Navigator.pop(context);
                } else {
                  controller.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                }
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Color(0xff149C32),
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(25),
                //     bottomRight: Radius.circular(25))
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                // border: Border.all(width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text('1',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff149C32))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('รายละเอียด',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.white)),
                          ],
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Divider(
                              thickness: 1,
                              color: (_curpage > 0)
                                  ? Colors.white
                                  : Color(0xffB3E8A8)),
                        )),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                // border: Border.all(width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: (_curpage > 0)
                                    ? Colors.white
                                    : Color(0xffB3E8A8),
                              ),
                              child: Center(
                                child: Text('2',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff149C32))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ดำเนินงาน',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: (_curpage > 0)
                                        ? Colors.white
                                        : Color(0xffB3E8A8))),
                          ],
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Divider(
                              thickness: 1,
                              color: (_curpage > 1)
                                  ? Colors.white
                                  : Color(0xffB3E8A8)),
                        )),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                // border: Border.all(width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: (_curpage > 1)
                                    ? Colors.white
                                    : Color(0xffB3E8A8),
                              ),
                              child: Center(
                                child: Text('3',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff149C32))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ตรวจสอบ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: (_curpage > 1)
                                        ? Colors.white
                                        : Color(0xffB3E8A8))),
                          ],
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Divider(
                              thickness: 1,
                              color: (_curpage > 2)
                                  ? Colors.white
                                  : Color(0xffB3E8A8)),
                        )),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                // border: Border.all(width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: (_curpage > 2)
                                    ? Colors.white
                                    : Color(0xffB3E8A8),
                              ),
                              child: Center(
                                child: Text('4',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff149C32))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ส่งงาน',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: (_curpage > 2)
                                        ? Colors.white
                                        : Color(0xffB3E8A8))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 30),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text('ซ่อมบำรุง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xff149C32)))),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: Row(
                      children: [
                        Text(
                            (_curpage == 0)
                                ? 'นัดหมายเข้างาน ${widget.j_start_date}\nนัดหมายส่งงาน ${widget.j_send_date}'
                                : (_curpage == 1)
                                    ? 'ถ่ายรูปตามจุดที่กำหมด พร้อมเขียนรายละเอียดให้ครบถ้วน'
                                    : 'ตรวจสอบงานก่อนเซ็นต์ส่งงาน',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                fontSize: 13,
                                color: Colors.white))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (value) {
                  // print(value);
                  setState(() {
                    _curpage = value;
                  });
                },
                children: <Widget>[detail(), photoPage(), sign(), finished()],
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
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff149C32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'เริ่มดำเนินงาน',
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(
          // physics: BouncingScrollPhysics(),

          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text('บริษัท : ${widget.cus_name} ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            Text('สาขา : ${widget.site_name}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                openMap(0, 0);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Color(0xff003175),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(widget.cus_address,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff646464))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('วันเดือนปี ติดตั้งแผง : ${widget.install_date}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('วันเดือนปี หมดระยะเวลาประกัน : ${widget.warranty_expire}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('ปริมาณการติดตั้ง : ${widget.power_peak}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            DottedLine(dashColor: Color(0xffD5D5D5)),
            SizedBox(
              height: 5,
            ),
            Text('รายละเอียด',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            SizedBox(
              height: 10,
            ),
            Text('รายละเอียดงาน : ${widget.j_detail}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('หมายเหตุ : ${widget.remark_tech}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            DottedLine(dashColor: Color(0xffD5D5D5)),
            SizedBox(
              height: 10,
            ),
            Text('ติดต่อ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            SizedBox(
              height: 10,
            ),
            (contactloading == true)
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              // border: Border.all(width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              color: Color(0xff003175),
                            ),
                            child: Center(
                                child: Icon(
                              Icons.phone,
                              size: 20,
                            )),
                          ),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: contact.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Color(0xff003175),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(contact[index].j_cont_name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Color(0xff464646))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        'ตำแหน่ง : ${contact[index].j_cont_position}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Color(0xff464646))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(contact[index].j_cont_tel,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Color(0xff464646)))
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  // border: Border.all(width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                  color: Color(0xff003175),
                                ),
                                child: Center(
                                  child: IconButton(
                                      splashRadius: 20,
                                      iconSize: 20,
                                      color: Colors.white,
                                      onPressed: () {
                                        _makePhoneCall(
                                            contact[index].j_cont_tel);
                                      },
                                      icon: Icon(Icons.phone)),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 10,
            ),
            DottedLine(dashColor: Color(0xffD5D5D5)),
            SizedBox(
              height: 10,
            ),
            Text('ผู้เปิดงาน',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xff003175))),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xff003175),
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('คุณ ตู่',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff464646))),
                        SizedBox(
                          height: 5,
                        ),
                        Text('ตำแหน่ง : ประสานงาน',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff464646))),
                        SizedBox(
                          height: 5,
                        ),
                        Text('000-000-0000',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xff464646)))
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      // border: Border.all(width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                      color: Color(0xff003175),
                    ),
                    child: Center(
                      child: IconButton(
                          splashRadius: 20,
                          iconSize: 20,
                          color: Colors.white,
                          onPressed: () {
                            _makePhoneCall('0000000000');
                          },
                          icon: Icon(Icons.phone)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _buildPopUp(BuildContext context) {
    return Center(
      child: Hero(
          tag: "bg",
          child: Material(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff149C32),
                // borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Color(0xffE0ECDE)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color(0xff149C32).withOpacity(0.1),
                //     blurRadius: 10,
                //     spreadRadius: 0,
                //     offset: Offset(0, 0), // Shadow position
                //   ),
                // ],
              ),
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
                            color: Colors.white)),
                    SizedBox(
                      height: 25,
                    ),
                    // Divider(
                    //   thickness: 0.5,
                    //   color: Colors.white,
                    // ),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('PV (แผงโซลาเซลล์)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Mounting',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Inverter',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('ตู้ DC, AC',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Fuse',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Breaker',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Switch',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Optimizer',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('อื่นๆ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IconButton(
                        iconSize: 30,
                        color: Colors.white,
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

  Widget photoPage() {
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
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff149C32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ถัดไป',
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    HeroDialogRoute(
                        builder: (BuildContext context) =>
                            _buildPopUp(context)));
              },
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('เพิ่มเรื่องซ่อมบำรุง',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xff464646))),
                        Hero(
                          tag: "bg",
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
          //   child: PullDownButton(
          //     itemBuilder: (context) => [
          //       PullDownMenuItem(
          //         title: 'Menu item',
          //         onTap: () {},
          //       ),
          //       const PullDownMenuDivider(),
          //       PullDownMenuItem(
          //         title: 'Menu item 2',
          //         onTap: () {},
          //       ),
          //     ],
          //     position: PullDownMenuPosition.under,
          //     buttonBuilder: (context, showMenu) => GestureDetector(
          //       onTap: showMenu,
          //       // padding: EdgeInsets.zero,
          //       child: Container(
          //         height: 70,
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(15),
          //           border: Border.all(color: Color(0xffE0ECDE)),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Color(0xff149C32).withOpacity(0.1),
          //               blurRadius: 10,
          //               spreadRadius: 0,
          //               offset: Offset(0, 0), // Shadow position
          //             ),
          //           ],
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 30),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text('เพิ่มเรื่องซ่อมบำรุง',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.w600,
          //                       fontSize: 14,
          //                       color: Color(0xff464646))),
          //               Container(
          //                 height: 30,
          //                 width: 30,
          //                 decoration: BoxDecoration(
          //                   // border: Border.all(width: 3),
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(200),
          //                   ),
          //                   color: Color(0xff149C32),
          //                 ),
          //                 child: Center(
          //                   child: Icon(
          //                     Icons.add,
          //                     color: Colors.white,
          //                     size: 30,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 45, right: 40),
            child: Row(
              children: [
                Text('ซ่อมบำรุง',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff464646))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
            child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.2,
                primary: false,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => uploadPic()));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff149C32),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff003175).withOpacity(0.1),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('PV (แผงโซล่าเซลล์)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
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
                                        color: Color(0xff003175),
                                      ),
                                      child: Center(
                                        child: Text('5/5',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
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
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => uploadPic()));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff149C32),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff003175).withOpacity(0.1),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Inverter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
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
                                        color: Color(0xff003175),
                                      ),
                                      child: Center(
                                        child: Text('5/5',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
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
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => uploadPic()));
                  //   },
                  //   child: Container(
                  //     height: 80,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xffF9FAF8),
                  //       borderRadius: BorderRadius.circular(15),
                  //       border: Border.all(color: Color(0xffE0ECDE)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Color(0xff149C32).withOpacity(0.1),
                  //           blurRadius: 10,
                  //           spreadRadius: 0,
                  //           offset: Offset(0, 0), // Shadow position
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           height: 40,
                  //           width: double.infinity,
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(15),
                  //                   topRight: Radius.circular(15))),
                  //           child: Center(
                  //             child: Text('PV (แผงโซล่าเซลล์)',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.w600,
                  //                     fontSize: 13,
                  //                     color: Color(0xff2DAC34))),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Container(
                  //                     height: 22,
                  //                     width: 22,
                  //                     decoration: BoxDecoration(
                  //                       // border: Border.all(width: 3),
                  //                       borderRadius: BorderRadius.all(
                  //                         Radius.circular(200),
                  //                       ),
                  //                       color: Color(0xffB3E8A8),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text('1',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff149C32))),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 10,
                  //                   ),
                  //                   Text('รูปถ่ายก่อนซ่อม',
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 12,
                  //                           color: Color(0xff2DAC34)))
                  //                 ],
                  //               ),
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Container(
                  //                     height: 22,
                  //                     width: 22,
                  //                     decoration: BoxDecoration(
                  //                       // border: Border.all(width: 3),
                  //                       borderRadius: BorderRadius.all(
                  //                         Radius.circular(200),
                  //                       ),
                  //                       color: Color(0xffB3E8A8),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text('1',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff149C32))),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 10,
                  //                   ),
                  //                   Text('รูปถ่ายหลังซ่อม',
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 12,
                  //                           color: Color(0xff2DAC34)))
                  //                 ],
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ]),
          ),
        ],
      ),
    );
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
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff149C32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ถัดไป',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              //   child: GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => signature()),
              //         ).then((value) {
              //           SystemChrome.setPreferredOrientations([
              //             DeviceOrientation.portraitUp,
              //           ]);
              //         });
              //       },
              //       child: Container(
              //         height: 80,
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: Color(0xffE0ECDE)),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Color(0xff149C32).withOpacity(0.1),
              //               blurRadius: 10,
              //               spreadRadius: 0,
              //               offset: Offset(0, 0), // Shadow position
              //             ),
              //           ],
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.only(left: 10),
              //               child: Container(
              //                 height: 60,
              //                 width: 60,
              //                 decoration: BoxDecoration(
              //                   color: Color(0xffF1FAEF),
              //                   borderRadius: BorderRadius.circular(10),
              //                 ),
              //                 child: Center(
              //                   child: Icon(
              //                     Icons.mode_edit_outlined,
              //                     size: 40,
              //                     color: Color(0xff149C32),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.only(left: 20),
              //               child: Text(
              //                 'หัวหน้างาน (บริษัทบริการลูกค้า)',
              //                 style: TextStyle(
              //                     color: Color(0xff464646),
              //                     fontWeight: FontWeight.w600,
              //                     fontSize: 14),
              //               ),
              //             ),
              //             // Padding(
              //             //   padding: const EdgeInsets.only(right: 10),
              //             //   child: Icon(
              //             //     Icons.check_circle_rounded,
              //             //     size: 20,
              //             //     color: Color(0xff149C32),
              //             //   ),
              //             // ),
              //           ],
              //         ),
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                child: GestureDetector(
                    onTap: () {
                      sheet('ผู้ติดต่อหน้างาน');
                    },
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Color(0xffE0ECDE)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff003175).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff003175),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'ผู้ติดต่อหน้างาน',
                              style: TextStyle(
                                  color: Color(0xff003175),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 10),
                          //   child: Icon(
                          //     Icons.check_circle_rounded,
                          //     size: 20,
                          //     color: Color(0xff149C32),
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                child: GestureDetector(
                    onTap: () {
                      sheet('หัวหน้าทีม');
                    },
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Color(0xffE0ECDE)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff003175).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color(0xff003175),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'หัวหน้าทีม',
                              style: TextStyle(
                                  color: Color(0xff003175),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 10),
                          //   child: Icon(
                          //     Icons.check_circle_rounded,
                          //     size: 20,
                          //     color: Color(0xff149C32),
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ],
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
                      // Navigator.pop(context);
                      confirmpop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff149C32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ยืนยันส่งงาน',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'ยืนยันการส่งข้อมูล',
              style: TextStyle(
                  color: Color(0xff149C32),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ระบบจะส่งข้อมูลหลังจากผู้ใช้งานกดปุ่มยืนยันส่งงาน หากมีการส่งข้อมูลแล้ว ผู้ใช้งานจะไม่สามารถเข้ามาแก้ไขข้อมูลเพิ่มเติมได้อีก',
              style: TextStyle(
                  color: Color(0xff7B7B7B),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'หมายเหตุ',
              style: TextStyle(
                  color: Color(0xff464646),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xffE0ECDE)),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 20),
            //       child: SizedBox(
            //         height: 40,
            //         width: 180,
            //         child: ElevatedButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => photopage(
            //                         type: 0,
            //                       )),
            //             );
            //           },
            //           style: ElevatedButton.styleFrom(
            //             foregroundColor: Colors.white,
            //             backgroundColor: Color(0xffE6B922),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(32.0),
            //             ),
            //           ),
            //           child: Text(
            //             'แจ้งซ่อม',
            //             style: TextStyle(
            //                 fontSize: 15, fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 15),
            //       child: SizedBox(
            //         height: 40,
            //         width: 180,
            //         child: ElevatedButton(
            //           onPressed: () {
            //             // Navigator.pop(context);
            //             confirmpop();
            //           },
            //           style: ElevatedButton.styleFrom(
            //             foregroundColor: Colors.white,
            //             backgroundColor: Color(0xff149C32),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(32.0),
            //             ),
            //           ),
            //           child: Text(
            //             'ยืนยันส่งงาน',
            //             style: TextStyle(
            //                 fontSize: 15, fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  void sheet(title) {
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
                                    color: Color(0xff149C32))),
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
                          border: Border.all(color: Color(0xff149C32)),
                        ),
                        child: TextField(
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
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signature()),
                              ).then((value) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                              });
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
  }
}

//api
class API {
  static Future getContactLs(idd) async {
    final response = await http.post(
      Uri.parse(
          'https://backoffice.energygreenplus.co.th/api/mobile/getJobContactMobileLs'),
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
      j_cont_name: json['j_cont_name'],
      j_cont_position: json['j_cont_position'],
      j_cont_tel: json['j_cont_tel'],
    );
  }
}
