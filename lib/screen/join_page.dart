import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sancheck/screen/phone_formatter.dart';
import 'package:intl/intl.dart';

Dio dio = Dio();

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;

  // 입력 필드 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // 입력 형식 지정

  bool _isAvailableId = false;
  bool _isAvailablePassword = false;
  bool _isFormValid = false;

  String _selectedGender = '남성'; // 초기 성별 선택 상태


  @override
  void initState() {
    super.initState();

    _nameController.addListener(_validateForm);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
    _phoneController.addListener(_validateForm);
    _birthdateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // 모든 컨트롤러의 dispose 호출
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    print("111111111");
    setState(() {
      _isFormValid = _nameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _birthdateController.text.isNotEmpty &&
          _isAvailablePassword &&
          _isAvailableId;
    });
    print(_isFormValid.toString()+"241414124");
  }

  void _validatePassword(){
    print("1111111");
    setState(() {
      _isAvailablePassword = _passwordController.text == _confirmPasswordController.text;
      _validateForm();
    });
    //print(_isAvailablePassword.toString()+"1111111111");
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _birthdateController.text = _dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 32, 47),
      appBar: AppBar(
        title: Text('산책 회원가입'),
        backgroundColor: Color(0xFFF7F6E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildForm(),
            // SizedBox(height: 24),
            // _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  // 폼 위젯
  Widget _buildForm() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('이름', '이름을 입력해 주세요.', controller: _nameController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildTextField('아이디', '아이디를 입력해 주세요.', controller: _idController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildCheckDuplicateButton(), // 중복 확인 버튼 추가
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildPasswordField('비밀번호', '비밀번호를 입력해 주세요.', true , controller: _passwordController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildPasswordField('비밀번호 확인', '비밀번호를 다시 입력해주세요', false , controller: _confirmPasswordController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildTextField('전화번호', '전화번호를 입력해 주세요.' , controller: _phoneController, isPhoneNumber: true),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text('생년월일', style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16, fontWeight: FontWeight.w400,),),
              SizedBox(height: 8),
              _buildBirthdateField('생년월일을 입력하세요', _birthdateController),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 4, // 40% of the available width
              //       child: _buildBirthdateField('yyyy', 4, _yearController),
              //     ),
              //     SizedBox(width: 8), // Add some spacing between the fields
              //     Expanded(
              //       flex: 3, // 30% of the available width
              //       child: _buildBirthdateField('MM', 2, _monthController),
              //     ),
              //     SizedBox(width: 8), // Add some spacing between the fields
              //     Expanded(
              //       flex: 3, // 30% of the available width
              //       child: _buildBirthdateField('dd', 2, _dayController),
              //     ),
              //   ],
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildGenderField(), // 성별 필드
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }





// 생년월일 필드
  Widget _buildBirthdateField(String hint, TextEditingController? controller){
    // return TextField(
    //   controller: controller,
    //   keyboardType: TextInputType.number, // 숫자 키보드 표시
    //   inputFormatters: [
    //     FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
    //     LengthLimitingTextInputFormatter(maxLength), // 최대 길이 제한
    //   ],
    //   decoration: InputDecoration(
    //     hintText: hint,
    //     filled: true,
    //     fillColor: Color(0xFFF5F5F5),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(8),
    //       borderSide: BorderSide.none,
    //     ),
    //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //   ),
    // );
    return TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
    decoration: InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Color(0xFFF5F5F5),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    );
  }



  // 성별 선택 필드 위젯
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성별',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남성'),
                value: '남성',
                groupValue: _selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여성'),
                value: '여성',
                groupValue: _selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 비밀번호 입력 필드 위젯
  Widget _buildPasswordField(String label, String hint, bool isPassword,{TextEditingController? controller}) {
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
          obscureText: isPassword ? _isObscuredPassword : _isObscuredConfirmPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(
                isPassword ? (_isObscuredPassword ? Icons.visibility_off : Icons.visibility) : (_isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility),
                color: Color(0xFF1E1E1E),
              ),
              onPressed: () {
                setState(() {
                  if (isPassword) {
                    _isObscuredPassword = !_isObscuredPassword;
                  } else {
                    _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }




  // 텍스트 필드 위젯
  Widget _buildTextField(String label, String hint, {TextEditingController? controller, bool isPhoneNumber = false}) {
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
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
          inputFormatters: isPhoneNumber
              ? [
            PhoneFormatter(), // 전화번호 포맷터 적용
            LengthLimitingTextInputFormatter(13), // 하이픈 포함 최대 길이
          ]
              : null,
        ),
      ],
    );
  }




  // 중복 확인 버튼 위젯
  Widget _buildCheckDuplicateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
          onPressed: () async {
            bool isAvailable = await _checkDuplicate();
            _isAvailableId = isAvailable;
            _validateForm();
            //print(_isAvailableEmail.toString()+"11111111");
          },
        child: Text('아이디 중복 확인'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFF5F5F5), // 버튼 텍스트 색상
          backgroundColor: Color(0xFF2C2C2C), // 버튼 배경색
          minimumSize: Size(double.infinity, 40), // 버튼 최소 크기
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 둥근 모서리
          ),
        ),
      ),
    );
  }




  // 중복 확인 동작
  Future<bool> _checkDuplicate() async {
    // 여기에 실제 중복 확인 로직을 추가해야 합니다.
    String userId = _idController.text;
    if (userId.trim().isEmpty) {
      return false; // 함수 종료
    }
    // print(email);
    // 예를 들어, 서버에 요청을 보내서 중복 여부 확인

    try {
      // 서버 통신
      String url = "http://172.28.112.1:8000/user/handleEmailCheck";
      Response res = await dio.post(url, data: {'user_id': userId});

      // 요청이 완료된 후에만 출력
      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');
      print('Response Data: ${res.data}');
      print(res.data['success']);

      bool isAvailableEmail = res.data['success'];
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAvailableEmail ? '사용 가능한 아이디입니다.' : '중복된 아이디입니다. 다른 아이디로 설정해주세요.')));

      // 다이얼로그를 표시하여 결과를 사용자에게 알림
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text(isAvailableEmail ? '사용 가능한 아이디' : '아이디 중복됨'),
      //     content: Text(
      //       isAvailableEmail
      //           ? '아이디: $email\n 사용 가능한 아이디입니다.'
      //           : '아이디: $email\n 중복된 아이디입니다. 다른 아이디로 설정해주세요.',
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: Text('확인'),
      //       ),
      //     ],
      //   ),
      // );

      return isAvailableEmail;

    } catch (e) {
      // 오류 발생 시 처리
      print('Error occurred: $e');
      return false; // 예외 발생 시 사용 가능한 아이디로 간주하지 않음
    }
  }





  // 제출 버튼 위젯
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: ElevatedButton(
        onPressed: () {
          // 제출 로직
          _submitForm();
        },
        child: Text('제출'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFF5F5F5), // 버튼 텍스트 색상
          backgroundColor: Color(0xFF2C2C2C), // 버튼 배경색
          minimumSize: Size(double.infinity, 40), // 버튼 최소 크기
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 둥근 모서리
          ),
        ),
      ),
    );
  }


  // 제출 로직
  void _submitForm() async{
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
    if(!_isAvailablePassword){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호를 일치시켜주세요.')));
      return;
    }
    if(!_isAvailableId){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디 중복체크 또는 다른 아이디를 작성해주세요.')));
      return;
    }
      if (_isFormValid) {
        try{
        // 제출 로직을 여기에 작성하세요.
        String userName = _nameController.text;
        String userId = _idController.text;
        String userPw = _passwordController.text;
        String userPhone = _phoneController.text;
        String userBirthdate = _birthdateController.text;

        // 서버 통신
        String url = "http://172.28.112.1:8000/user/handleJoin";
        Response res = await dio.post(url,
            data: {
              'user_name' : userName,
              'user_id': userId,
              'user_pw' : userPw,
              'user_phone' : userPhone,
              'user_birthdate' : userBirthdate,
              'user_gender' : _selectedGender
            }
        );

        // 요청이 완료된 후에만 출력
        print('Request URL: ${res.realUri}');
        print('Status Code: ${res.statusCode}');
        print('Response Data: ${res.data}');

        bool isSubmitted = res.data['success'];
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
        
        if(isSubmitted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 완료', style: TextStyle(color: Colors.black,),), backgroundColor: Colors.lightBlueAccent,));
          Navigator.pop(context);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패') , backgroundColor: Colors.redAccent,));
        }
        
        
        
      } catch(e){
          print('Error occurred: $e');
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바 숨기기
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패') , backgroundColor: Colors.redAccent,));
        }
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 올바르게 입력해주세요.')));
        return;
      }
    }



}
