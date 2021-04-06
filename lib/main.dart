import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          iconTheme: IconThemeData(),
          appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black)),
          fontFamily: GoogleFonts.inter().fontFamily,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrangeAccent),
      home: Home(),
    );
  }
}
//$ flutter run -d chrome --web-hostname localhost --web-port 5000