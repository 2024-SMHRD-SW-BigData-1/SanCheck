import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'phone_formatter.dart'; // 새로운 파일에서 클래스를 가져오는 경우


Dio dio = Dio();

class FindId extends StatelessWidget {
  FindId({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('아이디 찾기'),
        backgroundColor: Color(0xFFFFF5DA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('이름', '이름을 입력해 주세요.', _nameController),
                  SizedBox(height: 20),
                  _buildTextField('전화번호', '전화번호를 입력해 주세요.', _phoneController),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 아이디 찾기 버튼 클릭 시 동작
                          handleFindId(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6DA462),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '아이디 찾기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
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
          style: TextStyle(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
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

  // 다이얼로그 표시 함수
  void showIdDialog(BuildContext context, List<dynamic> userIds, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('아이디 찾기 성공'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userIds.map((id) => Text("$userName님의 아이디는 '$id' 입니다.")).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }


  //아이디 찾기
  void handleFindId(context) async{
    String userName = _nameController.text;
    String userPhone = _phoneController.text;

    if(userName.isEmpty || userPhone.isEmpty){
      return;
    }

    try{
      // 서버 통신
      String url = "http://172.28.112.1:8000/user/handleFindId";
      Response res = await dio.post(url,
          data: {
            'user_name': userName,
            'user_phone' : userPhone,
          }
      );
      // 요청이 완료된 후에만 출력
      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');
      print('Response Data: ${res.data}');

      bool isSuccessed = res.data['success'];
      print(res.data['user_id']);
      List<dynamic> listData = res.data['user_id'];

      // user_id의 값만 추출
      List userIds = listData.map((item) => item['user_id']!).toList();

      if(isSuccessed){
        showIdDialog(context, userIds, userName);

        
        
      }else{
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디 찾기 실패') , backgroundColor: Colors.redAccent,));
      }
    }catch(e){
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디 찾기 실패') , backgroundColor: Colors.redAccent,));
    }

  }



}
