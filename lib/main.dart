import 'package:flutter/material.dart';
import 'package:sancheck/screen/chat.dart';
import 'package:sancheck/screen/community.dart';
import 'package:sancheck/screen/community_post.dart';
import 'package:sancheck/screen/custom_bottom_nav_bar.dart';
import 'package:sancheck/screen/delete_id.dart';
import 'package:sancheck/screen/find_pw.dart';
import 'package:sancheck/screen/find_pw_next.dart';
import 'package:sancheck/screen/hike.dart';
import 'package:sancheck/screen/home.dart';
import 'package:sancheck/screen/home_mt_detail.dart';
import 'package:sancheck/screen/join_page.dart';
import 'package:sancheck/screen/login_page.dart';
import 'package:sancheck/screen/gpx_navigation.dart';
import 'package:sancheck/screen/login_success.dart';
import 'package:sancheck/screen/my_info.dart';
import 'package:sancheck/screen/mypage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:LoginSuccess(selectedIndex: 1,),
    );
  }
}



