import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: TextTheme().copyWith(),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrangeAccent),
      home: Home(),
    );
  }
}
//$ flutter run -d chrome --web-hostname localhost --web-port 5000