import 'package:egp_app/clean/cleansolar.dart';
import 'package:egp_app/pages/settingpage.dart';
import 'package:egp_app/repair/repair.dart';
import 'package:egp_app/research/research.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                        'Hello,',
                        style: TextStyle(
                            color: Color(0xff57A946),
                            fontSize: 34,
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => settingPage()),
                            );
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
            // title: const Text(
            //   'Hello, Nu Por',
            //   style: TextStyle(color: Color(0xff57A946), fontSize: 34),
            // ),
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
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Center(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  cardClean('ล้างแผง', 1, '25 / 1 / 2023  08:30',
                      'นำโชคเรื่องการเงิน สาขา ปทุมธานี'),
                  cardClean('สำรวจสถานที่', 0, '01 / 2 / 2023  08:30',
                      'นำโชคเรื่องการเงิน สาขา ปทุมธานี'),
                  cardClean('ซ่อมบำรุง', 2, '01 / 2 / 2023  08:30',
                      'นำโชคเรื่องการเงิน สาขา ปทุมธานี'),
                ],
              ),
            ),
            // Center(
            //   child: Text("It's rainy here"),
            // ),
            taskloading()
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

  Widget cardClean(type, status, date, comp) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          (type == "ล้างแผง")
              ? Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => cleansolar()),
                )
              : (type == "สำรวจสถานที่")
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => research()),
                    )
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) => repair()));
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
                            type,
                            style: TextStyle(
                                color: Color(0xff064046),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            date,
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
                      (status == 0)
                          ? Row(
                              children: [
                                // Container(
                                //   height: 10,
                                //   width: 10,
                                //   decoration: BoxDecoration(
                                //     // border: Border.all(width: 3),
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(200),
                                //     ),
                                //     color: Color(0xff57A946),
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                Container(
                                  height: 20,
                                  // width: 100,
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
                                ),
                              ],
                            )
                          : (status == 1)
                              ? Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      // width: 100,
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
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      // width: 100,
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

  Widget taskloading() {
    return Center(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
