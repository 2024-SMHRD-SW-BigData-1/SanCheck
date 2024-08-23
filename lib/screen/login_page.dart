import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sancheck/model/user_model.dart';
import 'package:sancheck/screen/find_id.dart';
import 'package:sancheck/screen/find_pw.dart';
import 'package:sancheck/screen/join_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio dio = Dio();
final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState()  {
    readLoginInfo(); //로그인 여부 확인
  }

  void readLoginInfo() async{
    String? value = await storage.read(key: 'user');  // 로컬 저장소에 저장돼있는지 확인

    if(value != null){
      UserModel user =  userModelFromJson(value);
      Navigator.push(context, MaterialPageRoute(builder: (_)=>JoinPage()));
      // Navigator.pushAndRemoveUntil(context,  // 로그인 돼있는 상태면 다른 페이지로 이동
      //     MaterialPageRoute(builder: (_)=>LoginSuccessPage(user: login[0],)),
      //         (route) => false
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('산책 로그인'),
        backgroundColor: Color(0xFFF8F7E3),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  '환영합니다!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 로그인 버튼 클릭 시 처리할 코드
                    handleLogin(context);
                  },
                  child: Text('로그인'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 아이디 찾기 클릭 시 처리할 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindId()),
                        );
                      },
                      child: Text('아이디 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 비밀번호 찾기 클릭 시 처리할 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindPw()),
                        );
                      },
                      child: Text('비밀번호 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 회원가입 클릭 시 JoinPage로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JoinPage()),
                        );
                      },
                      child: Text('회원가입'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleLogin(context) async{
    //print(_idController.text);
    //print(_passwordController.text);

    String userId = _idController.text;
    String userPw = _passwordController.text;

    if(userId.isEmpty || userPw.isEmpty){
      return;
    }

    try{
      // 서버 통신
      String url = "http://172.28.112.1:8000/user/handleLogin";
      Response res = await dio.post(url,
          data: {
            'user_id': userId,
            'user_pw' : userPw,
          }
      );
      // 요청이 완료된 후에만 출력
      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');
      //print('Response Data: ${res.data}');

      bool isSuccessed = res.data['success'];
      print(res.data['user_data'].runtimeType); // 타입 확인

      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기

      if(isSuccessed){ // 로그인 성공 시

        var userData = res.data['user_data']; // JSON으로 변환

        String userDataString = json.encode(userData); // JSON문자열로 변환
        UserModel user =  userModelFromJson(userDataString); // 모델로 변환
        await storage.write(key: 'user', value: userDataString); // 로컬 저장소 저장
        print("성공");

        Navigator.push(context, MaterialPageRoute(builder: (_)=>JoinPage()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 성공', style: TextStyle(color: Colors.black,),), backgroundColor: Colors.lightBlueAccent,));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 실패') , backgroundColor: Colors.redAccent,));
      }
    }catch(e){
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 실패') , backgroundColor: Colors.redAccent,));
    }




  }
}
