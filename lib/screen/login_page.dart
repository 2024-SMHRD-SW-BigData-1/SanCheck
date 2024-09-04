import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sancheck/model/user_model.dart';
import 'package:sancheck/screen/find_id.dart';
import 'package:sancheck/screen/find_pw.dart';
import 'package:sancheck/screen/join_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sancheck/screen/login_success.dart';

Dio dio = Dio();
final storage = FlutterSecureStorage(); // 싱글톤 패턴이여서 전역적으로 사용 가능

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscuredPassword = true; // 비밀번호 가리기 상태 관리 변수

  @override
  void initState() {
    super.initState();
    readLoginInfo();
  }

  Future<void> readLoginInfo() async {
    String? value = await storage.read(key: 'user');

    if (value != null) {
      // 이미 로그인 돼있다면 로그인 성공 페이지로 이동
      UserModel user = userModelFromJson(value);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginSuccess(selectedIndex: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8), // 전체 배경색을 부드러운 흰색으로 설정
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      '환영합니다!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _idController,
                      labelText: '아이디',
                      hintText: '아이디를 입력하세요',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: '비밀번호',
                      hintText: '비밀번호를 입력하세요',
                      icon: Icons.lock,
                      obscureText: _isObscuredPassword,
                      isPasswordField: true, // 비밀번호 필드 여부 전달
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          handleLogin(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 모서리를 네모나게 설정
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          '로그인',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTextButton('아이디 찾기', FindId()),
                        _buildTextButton('비밀번호 찾기', FindPw()),
                        _buildTextButton('회원가입', JoinPage()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    bool isPasswordField = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscuredPassword = !_isObscuredPassword;
              });
            },
          )
              : null,
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildTextButton(String text, Widget page) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  void handleLogin(context) async {
    String userId = _idController.text;
    String userPw = _passwordController.text;

    if (userId.isEmpty || userPw.isEmpty) {
      return;
    }

    try {
      // 서버 통신
      String url = "http://172.28.112.1:8000/user/handleLogin";
      Response res = await dio.post(url, data: {
        'user_id': userId,
        'user_pw': userPw,
      });

      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');

      bool isSuccessed = res.data['success'];
      print(res.data['user_data'].runtimeType); // 타입 확인

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (isSuccessed) {
        var userData = res.data['user_data'];
        String userDataString = json.encode(userData);
        UserModel user = userModelFromJson(userDataString);
        await storage.write(key: 'user', value: userDataString);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginSuccess(selectedIndex: 1)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 도중 오류 발생'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
