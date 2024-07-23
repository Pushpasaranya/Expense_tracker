//
// import 'package:flutter/material.dart';
// import '../bot.dart';
// import '../firebase.dart';
// import '../report.dart';
// import 'ForgotPassword.dart';
//
// class emailpass extends StatefulWidget {
//   const emailpass({super.key});
//
//   @override
//   State<emailpass> createState() => _emailpassState();
// }
//
// class _emailpassState extends State<emailpass> {
//   final logFormKey = GlobalKey<FormState>();
//   final logEmailController = TextEditingController();
//   final logPasswordController = TextEditingController();
//   bool logIsPasswordVisible = false;
//
//   Future<void> _login() async {
//     await AuthService.loginUserWithEmailAndPassword(
//       logEmailController.text,
//       logPasswordController.text,
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => bot(),
//       ),
//     );
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => FirstHomePage(),
//     //   ),
//     // );
//   }
//
//   // Future<void> _loginWithGoogle() async {
//   //   await FireAuth.loginWithGoogle();
//   //   // Navigator.push(
//   //   //   context,
//   //   //   MaterialPageRoute(
//   //   //     builder: (context) => FirstHomePage(),
//   //   //   ),
//   //   // );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.black54,
//               Colors.black45,
//               Colors.black38,
//               Colors.black26,
//               Colors.black12,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 48.0),
//                   Row(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.arrow_back_ios_new_outlined,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       const Text(
//                         'Welcome Back!',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const Spacer(flex: 2),
//                     ],
//                   ),
//                   const SizedBox(height: 48.0),
//                   Container(
//                     padding: const EdgeInsets.all(24.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(16.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           offset: const Offset(2, 15),
//                           blurRadius: 8.0,
//                         ),
//                       ],
//                     ),
//                     child: Form(
//                       key: logFormKey,
//                       child: Column(
//                         children: [
//                           buildTextFormField(
//                             controller: logEmailController,
//                             icon: Icons.email,
//                             hintText: "Email ID",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               } else if (!RegExp(
//                                   r'^[^@]+@[^@]+\.[^@]+')
//                                   .hasMatch(value)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 24.0),
//                           buildTextFormField(
//                             controller: logPasswordController,
//                             icon: Icons.lock,
//                             hintText: "Password",
//                             obscureText: !logIsPasswordVisible,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 logIsPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.black,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   logIsPasswordVisible =
//                                   !logIsPasswordVisible;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 48.0),
//                   GestureDetector(
//                     onTap: () {
//                       if (logFormKey.currentState!.validate()) {
//                         _login();
//                       }
//                     },
//                     child: Container(
//                       height: 48.0,
//                       width: 170,
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             offset: const Offset(2, 15),
//                             blurRadius: 5.0,
//                           ),
//                         ],
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "LOGIN",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     _loginWithGoogle();
//                   //     // Navigator.push(
//                   //     //   context,
//                   //     //   MaterialPageRoute(
//                   //     //     builder: (context) => FirstHomePage(),
//                   //     //   ),
//                   //     // );
//                   //   },
//                   //   child: Container(
//                   //     height: 48.0,
//                   //     width: 170,
//                   //     decoration: BoxDecoration(
//                   //       color: Colors.redAccent,
//                   //       borderRadius: BorderRadius.circular(30),
//                   //       boxShadow: [
//                   //         BoxShadow(
//                   //           color: Colors.black26,
//                   //           offset: const Offset(2, 15),
//                   //           blurRadius: 5.0,
//                   //         ),
//                   //       ],
//                   //     ),
//                   //     child: const Center(
//                   //       child: Text(
//                   //         "LOGIN WITH GOOGLE",
//                   //         style: TextStyle(
//                   //           fontSize: 15,
//                   //           color: Colors.white,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 16.0),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ForgotPassword(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Forgot Password?",
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextFormField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hintText,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             offset: const Offset(2, 15),
//             blurRadius: 8.0,
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(fontSize: 15),
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           contentPadding: const EdgeInsets.all(15),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30.0),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           hintText: hintText,
//           suffixIcon: suffixIcon,
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
