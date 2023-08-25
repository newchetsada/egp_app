// import 'package:flutter/material.dart';

// class audit extends StatefulWidget {
//   @override
//   _auditState createState() => _auditState();

//   final int jidx;
//   final int typeId;
//   final String typeName;

//   audit({required this.jidx, required this.typeId, required this.typeName});
// }

// class _auditState extends State<audit> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         bottomNavigationBar: Container(
//           // height: 30,
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 20, bottom: 30, left: 30, right: 30),
//                   child: SizedBox(
//                     height: 50,
//                     // width: 160,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: Color(0xff57A946),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         'บันทึก',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//               color: Color(0xff57A946),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.arrow_back)),
//           title: Text(
//             widget.typeName,
//             style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 19,
//                 color: Color(0xff57A946)),
//           ),
//         ),
//         body: ListView.builder(
//             itemCount: groupSub.length,
//             itemBuilder: ((context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
//                 child: GestureDetector(
//                     onTap: () {
//                       loading();
//                       API
//                           .getPicLs(widget.jidx, widget.typeId,
//                               groupSub[index].sub_type_id)
//                           .then((response) {
//                         // print(response.body);
//                         setState(() {
//                           List list = json.decode(response.body);
//                           pic = list.map((m) => Album.fromJson(m)).toList();
//                           if (pic.isEmpty) {
//                             remark.text = '';
//                           } else {
//                             remark.text = pic[0].remark;
//                           }
//                         });
//                         Navigator.pop(context);
//                         addSheet(groupSub[index].sub_type_name,
//                             groupSub[index].sub_type_id);
//                       });
//                     },
//                     child: Container(
//                       height: 70,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         // border: Border.all(color: Color(0xffE0ECDE)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xff57A946).withOpacity(0.1),
//                             blurRadius: 10,
//                             spreadRadius: 0,
//                             offset: Offset(0, 0), // Shadow position
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   groupSub[index].sub_type_name,
//                                   style: TextStyle(
//                                       color: Color(0xff003175),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   'รูปทั้งหมด  ${groupSub[index].amount_pic}',
//                                   style: TextStyle(
//                                       color: Color(0xff57A946),
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 11),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               height: 25,
//                               width: 25,
//                               decoration: BoxDecoration(
//                                 color: (groupSub[index].amount_pic > 0)
//                                     ? Color(0xff57A946)
//                                     : Color(0xffB7B7B7),
//                                 borderRadius: BorderRadius.circular(100),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.check,
//                                   size: 20,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )),
//               );
//             })));
//   }
// }
