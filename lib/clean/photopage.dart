import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class photopage extends StatefulWidget {
  @override
  _photopageState createState() => _photopageState();
}

class _photopageState extends State<photopage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffF8F8F8),
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: Color(0xff57A946),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            'ถ่ายรูป ก่อนล้างแผง',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff57A946)),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: GridView.count(
                          childAspectRatio: 1.3,
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: <Widget>[
                            add(),
                            add(),
                            add(),
                            add(),
                            add(),
                            add(),
                            add(),
                            add(),
                          ],
                        ))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมายเหตุ',
                      style: TextStyle(
                          color: Color(0xff464646),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffE0ECDE)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xff57A946),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: Text(
                                'บันทึก',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget add() {
    return Container(
      // height: 20,
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xffF1FAEF)),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          color: Color(0xffB3E8A8),
          size: 80,
        ),
      ),
    );
  }
}
