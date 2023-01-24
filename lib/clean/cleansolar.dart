import 'package:egp_app/clean/photopage.dart';
import 'package:egp_app/clean/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_line/dotted_line.dart';

class cleansolar extends StatefulWidget {
  _cleansolarState createState() => _cleansolarState();
}

class _cleansolarState extends State<cleansolar> {
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
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            (_curpage == 0) ? 'รายละเอียด' : 'ดำเนินงาน',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xff57A946),
          leading: IconButton(
              onPressed: () {
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
                  color: Color(0xff57A946),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
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
                                        fontSize: 10,
                                        color: Color(0xff57A946))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('รายละเอียด',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
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
                                        fontSize: 10,
                                        color: Color(0xff57A946))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ดำเนินงาน',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
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
                                        fontSize: 10,
                                        color: Color(0xff57A946))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ตรวจสอบ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
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
                                        fontSize: 10,
                                        color: Color(0xff57A946))),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('ส่งงาน',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
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
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text('ล้างแผง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff57A946)))),
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
                                    ? 'ผู้ใช้งานสุ่มถ่ายรูป แผลโซล่าเซลล์ก่อนล้าง หลังล้าง'
                                    : 'ตรวจสอบงานก่อนเซ็นต์ส่งงาน',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
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
            ))
          ],
        ),
      ),
    );
  }

  Widget detail() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: ListView(
        physics: BouncingScrollPhysics(),

        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text('บริษัท : นำโชคเรื่องการเงิน ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xff57A946))),
          Text('สาขา : นนทบุรี',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xff57A946))),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Color(0xff57A946),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                    '455/37-38 ถ.พระราม6 เขตราชเทวี แขวงถนนเพชรบุรี กทม 10400',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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
                  fontSize: 12,
                  color: Color(0xff646464))),
          SizedBox(
            height: 10,
          ),
          Text('วันเดือนปี หมดระยะเวลาประกัน : 00 / 00 / 0000',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff646464))),
          SizedBox(
            height: 10,
          ),
          Text('ปริมาณการติดตั้ง :',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
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
                  fontSize: 13,
                  color: Color(0xff57A946))),
          SizedBox(
            height: 10,
          ),
          Text('รายละเอียดงาน :',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff646464))),
          SizedBox(
            height: 10,
          ),
          Text('หมายเหตุ :',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
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
                  fontSize: 13,
                  color: Color(0xff57A946))),
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
                    color: Color(0xff57A946),
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
                              fontSize: 12,
                              color: Color(0xff464646))),
                      Text('ตำแหน่ง :ประสานงาน',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff464646))),
                      Text('000-000-0000',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
                    color: Color(0xff57A946),
                  ),
                  child: Center(
                    child: IconButton(
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
                  color: Color(0xff57A946))),
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
                    color: Color(0xff57A946),
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
                              fontSize: 12,
                              color: Color(0xff464646))),
                      Text('ตำแหน่ง : ประสานงาน',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff464646))),
                      Text('000-000-0000',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
                    color: Color(0xff57A946),
                  ),
                  child: Center(
                    child: IconButton(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: SizedBox(
                  height: 40,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff57A946),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Text(
                      'เริ่มดำเนินงาน',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget photoPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => photopage()),
                    );
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffE0ECDE)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xffF1FAEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(Icons.abc),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ถ่ายรูป ก่อนล้างแผง',
                              style: TextStyle(
                                  color: Color(0xff464646),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            Text(
                              'สุ่มถ่ายรูป แผงโซล่าเซลล์ก่อนล้าง 10 แผง',
                              style: TextStyle(
                                  color: Color(0xff7B7B7B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Color(0xff57A946),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
              child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => cleansolar()),
                    // );
                  },
                  child: Container(
                    height: 80,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xffF1FAEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ถ่ายรูป หลังล้างแผง',
                              style: TextStyle(
                                  color: Color(0xff464646),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            Text(
                              'สุ่มถ่ายรูป แผงโซล่าเซลล์หลังล้าง 10 แผง',
                              style: TextStyle(
                                  color: Color(0xff7B7B7B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff57A946),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: Text(
                'ถัดไป',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signature()),
                    ).then((value) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    });
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffE0ECDE)),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xffF1FAEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.mode_edit_outlined,
                                size: 40,
                                color: Color(0xff57A946),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'หัวหน้างาน (บริษัทบริการลูกค้า)',
                            style: TextStyle(
                                color: Color(0xff464646),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 10),
                        //   child: Icon(
                        //     Icons.check_circle_rounded,
                        //     size: 20,
                        //     color: Color(0xff57A946),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => photopage()),
                    // );
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
                          color: Color(0xff57A946).withOpacity(0.1),
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xffF1FAEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.mode_edit_outlined,
                                size: 40,
                                color: Color(0xffC2D3BF),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'ผู้ติดต่อหน้างาน',
                            style: TextStyle(
                                color: Color(0xff464646),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 10),
                        //   child: Icon(
                        //     Icons.check_circle_rounded,
                        //     size: 20,
                        //     color: Color(0xff57A946),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => photopage()),
                    // );
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
                          color: Color(0xff57A946).withOpacity(0.1),
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xffF1FAEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.mode_edit_outlined,
                                size: 40,
                                color: Color(0xffC2D3BF),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'หัวหน้าทีม',
                            style: TextStyle(
                                color: Color(0xff464646),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 10),
                        //   child: Icon(
                        //     Icons.check_circle_rounded,
                        //     size: 20,
                        //     color: Color(0xff57A946),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff57A946),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: Text(
                'ถัดไป',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget finished() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            'ยืนยันการส่งข้อมูล',
            style: TextStyle(
                color: Color(0xff57A946),
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'ระบบจะส่งข้อมูลหลังจากผู้ใช้งานกดปุ่ม แจ้งซ่อม หรือปุ่ม ยืนยันส่งงาน หากมีการส่งข้อมุลแล้ว ผู้ใช้งานจะไม่สามารถเข้ามาแก้ไขข้อมูลเพิ่มเติมได้อีก',
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
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xffE0ECDE)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 40,
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffE6B922),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Text(
                      'แจ้งซ่อม',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  height: 40,
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff57A946),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Text(
                      'ยืนยันส่งงาน',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
