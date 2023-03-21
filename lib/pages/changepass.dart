import 'package:flutter/material.dart';

class changepass extends StatefulWidget {
  @override
  _changepassState createState() => _changepassState();

  final int? id;
  changepass({
    required this.id,
  });
}

class _changepassState extends State<changepass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'เปลี่ยนรหัสผ่าน',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Color(0xff149C32),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Color(0xff149C32),
            splashRadius: 15,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
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
                    onPressed: () {},
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
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                ' กรอกรหัสผ่านเดิม',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff003175),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                // controller: fullname,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                ' กรอกรหัสผ่านใหม่',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff003175),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                // controller: email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' กรอกรหัสผ่านใหม่อีกครั้ง',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff003175),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                // controller: email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
                    enabledBorder: myinputborder(),
                    focusedBorder: myinputborder()),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color(0xffD3D3D3),
          width: 1,
        ));
  }
}
