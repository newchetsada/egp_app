import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class signature extends StatefulWidget {
  @override
  _signatureState createState() => _signatureState();
}

class _signatureState extends State<signature> {
  final _sign = GlobalKey<SignatureState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: Color(0xff149C32),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            'ลายเซ็นต์',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff149C32)),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff149C32).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: Signature(
                    color: Colors.black,
                    strokeWidth: 5.0,
                    backgroundPainter: null,
                    onSign: () {
                      final sign = _sign.currentState;
                    },
                    key: _sign,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            final sign = _sign.currentState;
                            sign?.clear();
                            setState(() {
                              // _img = ByteData(0);
                            });
                            debugPrint("cleared");
                          },
                          child: Text(
                            'ล้าง',
                            style: TextStyle(
                                color: Color(0xff464646),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                      SizedBox(
                        height: 45,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            //     final sign = _sign.currentState;

                            // final image = await sign.getData();
                            // var data = await image.toByteData(format: ui.ImageByteFormat.png);
                            // sign.clear();
                            // final encoded = base64.encode(data.buffer.asUint8List());
                            // setState(() {
                            //   _img = data;
                            // });
                            // debugPrint("onPressed " + encoded);
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
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
