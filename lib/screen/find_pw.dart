import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'find_pw_next.dart';
import 'phone_formatter.dart'; // 전화번호 포맷터 적용

Dio dio = Dio();

class FindPw extends StatelessWidget {
  FindPw({super.key});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // 밝고 부드러운 배경색
      appBar: AppBar(
        title: Text(
          '비밀번호 찾기',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 적용
        ),
        centerTitle: true, // 제목 중앙 정렬
        backgroundColor: Color(0xFFF5F5F5), // LoginSuccess의 상단바 배경색과 동일
        elevation: 0, // 그림자 제거
        iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 설정
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
                  _buildTextField('이메일', '이메일을 입력해 주세요.', _idController),
                  const SizedBox(height: 20),
                  _buildTextField('이름', '이름을 입력해 주세요.', _nameController),
                  const SizedBox(height: 20),
                  _buildTextField('전화번호', '전화번호를 입력해 주세요.', _phoneController),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 비밀번호 찾기 버튼 클릭 시 동작
                          handleFindPw(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50), // iOS Health 앱 느낌의 초록색
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '비밀번호 찾기',
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

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: label == '전화번호' ? TextInputType.phone : TextInputType.text,
          inputFormatters: label == '전화번호'
              ? [
            PhoneFormatter(), // 전화번호 포맷터 적용
            LengthLimitingTextInputFormatter(13), // 하이픈 포함 최대 길이
          ]
              : null,
        ),
      ],
    );
  }

  Future<void> _handleFindPw(BuildContext context) async {

    String userId = _idController.text;
    String userName = _nameController.text;
    String userPhone = _phoneController.text;

    // bool isAvailableId =  _validateEmail(userId);


    if (userId.isEmpty || userName.isEmpty || userPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일, 이름, 전화번호를 모두 입력해 주세요.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // if(!isAvailableId){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('이메일 형식대로 작성해주세요. \n유효한 이메일 형식 : example@example.com'), backgroundColor: Colors.redAccent),
    //   );
    //   return;
    // }



    try {
      // 서버 통신
      String url = "http://172.28.112.1:8000/user/handleFindPw";
      Response res = await dio.post(url, data: {
        'user_id': userId,
        'user_name': userName,
        'user_phone': userPhone,
      });
      // 요청이 완료된 후에만 출력
      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');
      print('Response Data: ${res.data}');

      bool isSuccessed = res.data['success'];

      if (isSuccessed) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindPwNext(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호 찾기 실패'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호 찾기 실패'), backgroundColor: Colors.redAccent),
      );
    }
  }
}
