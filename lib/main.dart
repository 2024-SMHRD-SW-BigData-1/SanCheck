import 'package:flutter/material.dart';
import 'package:sancheck/screen/login_page.dart';
// import 'package:sancheck/testtttt.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}





