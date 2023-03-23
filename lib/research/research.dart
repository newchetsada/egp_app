import 'package:dotted_line/dotted_line.dart';
import 'package:egp_app/clean/photopage.dart';
import 'package:egp_app/clean/signature.dart';
import 'package:egp_app/pages/homepage.dart';
import 'package:egp_app/research/ctfull.dart';
import 'package:egp_app/research/powersystem.dart';
import 'package:egp_app/research/roof.dart';
import 'package:egp_app/research/stair.dart';
import 'package:egp_app/research/water.dart';
import 'package:egp_app/research/wire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class research extends StatefulWidget {
  @override
  _researchState createState() => _researchState();
}

class _researchState extends State<research> {
  PageController controller = PageController(initialPage: 0);
  int _curpage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
              height: 130,
              decoration: BoxDecoration(
                color: Color(0xff149C32),
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
                              child: Text('สำรวจสถานที่',
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
                                ? 'นัดหมาย 25/1/2023 08:30'
                                : (_curpage == 1)
                                    ? 'ถ่ายรูปตามจุดที่กำหนด พร้อมเขียนรายละเอียดให้ครบถ้วน'
                                    : 'ตรวจสอบงานก่อนเซ็นต์ส่งงาน',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
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
          physics: BouncingScrollPhysics(),

          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('บริษัท : นำโชคเรื่องการเงิน ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            Text('สาขา : นนทบุรี',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xff003175))),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Color(0xff003175),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                      '455/37-38 ถ.พระราม6 เขตราชเทวี แขวงถนนเพชรบุรี กทม 10400',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff646464))),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('วันเดือนปี ติดตั้งแผง : 00 / 00 / 0000',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('วันเดือนปี หมดระยะเวลาประกัน : 00 / 00 / 0000',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('ปริมาณการติดตั้ง :',
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
            Text('รายละเอียดงาน :',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff646464))),
            SizedBox(
              height: 10,
            ),
            Text('หมายเหตุ :',
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
                        Text('คุณ ใจรัก ในงาน',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff464646))),
                        SizedBox(
                          height: 5,
                        ),
                        Text('ตำแหน่ง :ประสานงาน',
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
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget photoPage() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          // height: 30,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 30, right: 30),
                        child: SizedBox(
                          height: 50,
                          // width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => photopage(
                                          type: 2,
                                          limit: 0,
                                          jidx: 0,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xff003175),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'แจ้งซ่อม',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 30, left: 30, right: 30),
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
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
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
              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
              child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 1.2,
                  primary: false,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => powerSystem()),
                        );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('ระบบไฟ',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => wire()),
                        );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('สายไฟ',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => water()),
                        );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('ระบบน้ำ',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ctfull()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('การคล้อง CT Full Load',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Color(0xff003175))),
                                      ],
                                    ),
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
                                          child: Text('0/1',
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
                                              color: Color(0xff003175))),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => roof()),
                        );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('หลังคา',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => stair()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('บันได',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Color(0xff003175))),
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
                                          child: Text('1/2',
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
                                              color: Color(0xff003175))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => signature()),
                              // ).then((value) {
                              //   SystemChrome.setPreferredOrientations([
                              //     DeviceOrientation.portraitUp,
                              //   ]);
                              // });
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
