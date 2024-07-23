// import 'package:expense_tracker/model/LogSign.dart';
// import 'package:expense_tracker/report.dart';
// import 'package:flutter/material.dart';
//
//
// class login extends StatefulWidget {
//   const login({super.key});
//
//   @override
//   State<login> createState() => _loginState();
// }
// void _showMyBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return LogSign();
//     },
//   );
// }
//
//
// class _loginState extends State<login> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
//
//     return Scaffold(
//         body: Stack(
//             children: [
//               Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.6),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Image.asset("assets/Bscreen.jpg", fit: BoxFit.fill,),
//               ),
//               Container(
//                 height: height,
//                 width: width,
//                 color: Colors.black.withOpacity(0.4),
//               ),
//               // Positioned(
//               //   top: height * 0.15,
//               //   left: width * 0.1,
//               //   right: width * 0.1,
//               //   child: Column(
//               //     children: [
//               //       Text(
//               //         'Plan Your Budget',
//               //         textAlign: TextAlign.center,
//               //         style: TextStyle(
//               //           fontSize: 30 * textScaleFactor,
//               //           color: Colors.white,
//               //           fontWeight: FontWeight.bold,
//               //           shadows: [
//               //             Shadow(
//               //               blurRadius: 10.0,
//               //               color: Colors.black,
//               //               offset: Offset(2.0, 2.0),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //       SizedBox(height: height * 0.02),
//               //       Text(
//               //         ' Add and keep track of your expenses.',
//               //         textAlign: TextAlign.center,
//               //         style: TextStyle(
//               //           fontWeight: FontWeight.bold,
//               //           fontSize: 12 * textScaleFactor,
//               //           color: Colors.white70,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Positioned(
//                 left: width * 0.25,
//                 right: width * 0.25,
//                 bottom: height * 0.1,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.black, backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: height * 0.01),
//                   ),
//                   onPressed: () {
//                     _showMyBottomSheet(context);
//                   },
//                   child: Text(
//                     "Get Started",
//                     style: TextStyle(
//                       fontSize: 13 * textScaleFactor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             ),
//         );
//     }
// }