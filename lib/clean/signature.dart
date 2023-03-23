import 'dart:convert';
// import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;

class signature extends StatefulWidget {
  @override
  _signatureState createState() => _signatureState();

  final int jidx;
  final int imgType;
  final String signName;
  final String user;
  signature(
      {required this.jidx,
      required this.imgType,
      required this.signName,
      required this.user});
}

class _signatureState extends State<signature> {
  final _sign = GlobalKey<SignatureState>();
  ByteData _img = ByteData(0);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  void poptest(total) {
    showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
            child: Column(
              children: [Image.memory(total.buffer.asUint8List())],
            ),
          ),
        );
      },
    );
  }

  uploadPic(image) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://backoffice.energygreenplus.co.th/api/mobile/uploadJobImage'));

    request.headers["X-API-Key"] = 'evdplusm8DdW+Wd3UCweHj';

    request.fields['jidx'] = widget.jidx.toString(); //widget.jidx.toString();
    request.fields['imgType'] =
        widget.imgType.toString(); //widget.type.toString();
    request.fields['typeId'] = '';
    request.fields['subTypeId'] = '';
    request.fields['imgDesId'] = '';
    request.fields['groupNo'] = '1';
    request.fields['remark'] = '';
    request.fields['accessories'] = '';
    request.fields['sign_name'] = widget.signName;
    request.fields['userName'] = widget.user;
    request.fields['filesName'] =
        '${DateTime.now().toString()}.png'; //image.path.split('/').last;

    request.files.add(http.MultipartFile.fromBytes(
        'files', image.buffer.asUint8List(),
        filename: '${DateTime.now().toString()}.png'));

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    // print(response.body);
    // return response.body;
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
                              _img = ByteData(0);
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
                            final sign = _sign.currentState;

                            final image = await sign?.getData();

                            var data = await image?.toByteData(
                                format: ui.ImageByteFormat.png);
                            sign?.clear();
                            // final encoded =
                            //     base64.encode(data!.buffer.asUint8List());
                            setState(() {
                              _img = data!;
                            });
                            uploadPic(_img).then((value) {
                              Navigator.pop(context);
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
