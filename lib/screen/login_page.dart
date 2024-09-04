import 'package:flutter/material.dart';
import 'package:sancheck/model/user_model.dart';
import 'package:sancheck/screen/find_id.dart';
import 'package:sancheck/screen/find_pw.dart';
import 'package:sancheck/screen/join_page.dart';
import 'package:sancheck/screen/login_success.dart';
import 'package:sancheck/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Create instance of AuthService

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

  void handleLogin(BuildContext context) async {
    String userId = _idController.text;
    String userPw = _passwordController.text;

    if (userId.isEmpty || userPw.isEmpty) {
      return;
    }

    UserModel? user = await _authService.login(userId, userPw);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginSuccess(selectedIndex: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
