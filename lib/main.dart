

import 'package:expense_tracker/model/welcomescreen.dart';

import 'package:expense_tracker/theme.dart';
import 'package:expense_tracker/theme/theme.dart';
import 'package:expense_tracker/widgets/push.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';


Future<void> main() async {

  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider())
      ],
      child: MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDrQUsfYRk_PSpCVfTBKYJIsIKpLXk0bg0",
        appId: "1:1007559969240:web:6d48545f45bf83678b4aad",
        messagingSenderId: "1007559969240",
        projectId: "exptrack-6918e"
    ),
  );
  await FirebaseApi().initNotifications();

}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
        builder: (context,child)=> ResponsiveBreakpoints(child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ]),
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: lightMode,
        darkTheme: ThemeData.dark(),
        home: welcomescreen(),
        );
    }
}