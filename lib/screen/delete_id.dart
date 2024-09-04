import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sancheck/model/user_model.dart';
import 'package:sancheck/screen/login_page.dart'; // 로그인 페이지를 가져옵니다.

Dio dio = Dio();

class DeleteId extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // 밝은 배경색 설정
      appBar: AppBar(
        title: Text(
          '회원탈퇴',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 적용
        ),
        centerTitle: true, // 제목 중앙 정렬
        backgroundColor: Color(0xFFF5F5F5), // LoginSuccess의 상단바 배경색과 동일
        elevation: 0, // 그림자 제거
        iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  _buildInputField('아이디', '아이디를 입력해 주세요.', _idController),
                  SizedBox(height: 20),
                  _buildInputField('비밀번호', '비밀번호를 입력해 주세요.', _pwController, obscureText: true),
                  SizedBox(height: 20),
                  _buildInputField('비밀번호 확인', '비밀번호를 다시 입력해 주세요.', _pwConfirmController, obscureText: true),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          handleDeleteId(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE35154), // iOS Health 앱의 강렬한 경고 색상
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '회원탈퇴',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 회원 탈퇴 기능 처리
  void handleDeleteId(BuildContext context) async {
    String userId = _idController.text;
    String userPw = _pwController.text;
    String confirmPw = _pwConfirmController.text;

    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
    if ([userId, userPw, confirmPw].any((element) => element.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 정확히 작성해주세요.')));
      return;
    }

    if (userPw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호를 일치시켜주세요.')));
      return;
    }

    // 저장된 JSON 문자열을 읽어옴
    String? userDataString = await storage.read(key: 'user');

    if (userDataString != null) {
      // JSON 문자열을 Map으로 디코딩
      Map<String, dynamic> userDataMap = json.decode(userDataString);

      // Map을 UserModel 객체로 변환
      UserModel user = UserModel.fromJson(userDataMap);

      if (userId != user.userId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('입력한 아이디가 현재 로그인된 아이디와 다릅니다.')));
        return;
      }

      try {
        // 서버 통신
        String url = "http://172.28.112.1:8000/user/handleDeleteId";
        Response res = await dio.post(url, data: {
          'user_id': userId,
          'user_pw': userPw,
        });
        // 요청이 완료된 후에만 출력
        print('Request URL: ${res.realUri}');
        print('Status Code: ${res.statusCode}');

        bool isSuccessed = res.data['success'];

        if (isSuccessed) {
          // 로컬저장소 값 삭제
          await storage.delete(key: 'user');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false, // 모든 이전 화면을 제거
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원탈퇴 실패'), backgroundColor: Colors.redAccent));
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원탈퇴 실패'), backgroundColor: Colors.redAccent));
      }
    }
  }

  Widget _buildInputField(String label, String hintText, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
