import 'package:egp_app/repair/hero_dialog_route.dart';
import 'package:flutter/material.dart';

class report extends StatefulWidget {
  @override
  _reportState createState() => _reportState();
}

class _reportState extends State<report> {
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
                      backgroundColor: Color(0xff149C32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'บันทึก',
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            color: Color(0xff149C32),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'แจ้งซ่อม',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: Color(0xff149C32)),
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
              child: Hero(
                tag: "bg",
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff003175),
                      borderRadius: BorderRadius.circular(15),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('เพิ่มเรื่องซ่อมบำรุง',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.white)),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                // border: Border.all(width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: Colors.white),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xff003175),
                                size: 30,
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
            child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.4,
                primary: false,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => uploadPic()));
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
                            Text('PV (แผงโซล่าเซลล์)',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff003175))),
                            Column(
                              children: [
                                Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    // border: Border.all(width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    color: Color(0xff003175),
                                  ),
                                  child: Center(
                                    child: Text('6',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('รูปถ่ายก่อนซ่อม',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff003175))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => uploadPic()));
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
                            Text('Inverter',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff003175))),
                            Column(
                              children: [
                                Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    // border: Border.all(width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    color: Color(0xff003175),
                                  ),
                                  child: Center(
                                    child: Text('6',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('รูปถ่ายก่อนซ่อม',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xff003175))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
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
                color: Color(0xff003175),
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
                          child: Text('สายไฟ',
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
}
