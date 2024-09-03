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
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _birthdateController.text.isNotEmpty &&
          _isAvailablePassword &&
          _isAvailableId;
    });
  }

  void _validatePassword() {
    setState(() {
      _isAvailablePassword = _passwordController.text == _confirmPasswordController.text;
      _validateForm();
    });
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
      backgroundColor: Color(0xFFF5F5F5), // 밝은 배경색으로 변경
      appBar: AppBar(
        title: Text(
          '산책 회원가입',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
        ),
        centerTitle: true, // 제목 중앙 정렬
        backgroundColor: Color(0xFFF5F5F5), // LoginSuccess의 상단바 배경색과 동일
        elevation: 0, // 그림자 제거
        iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildForm(),
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('이름', '이름을 입력해 주세요.', controller: _nameController),
              SizedBox(height: 16),
              _buildTextField('아이디', '아이디를 입력해 주세요.', controller: _idController),
              SizedBox(height: 16),
              _buildCheckDuplicateButton(),
              SizedBox(height: 16),
              _buildPasswordField('비밀번호', '비밀번호를 입력해 주세요.', true, controller: _passwordController),
              SizedBox(height: 16),
              _buildPasswordField('비밀번호 확인', '비밀번호를 다시 입력해주세요', false, controller: _confirmPasswordController),
              SizedBox(height: 16),
              _buildTextField('전화번호', '전화번호를 입력해 주세요.', controller: _phoneController, isPhoneNumber: true),
              SizedBox(height: 16),
              _buildBirthdateField('생년월일을 입력하세요', _birthdateController),
              SizedBox(height: 16),
              _buildGenderField(),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 생년월일 필드
  Widget _buildBirthdateField(String hint, TextEditingController? controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
          style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16, fontWeight: FontWeight.w400),
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
  Widget _buildPasswordField(String label, String hint, bool isPassword, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16, fontWeight: FontWeight.w400),
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
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(
                isPassword
                    ? (_isObscuredPassword ? Icons.visibility_off : Icons.visibility)
                    : (_isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility),
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
          style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
      child: Align(
        alignment: Alignment.center, // 버튼을 가운데 정렬
        child: ElevatedButton(
          onPressed: () async {
            bool isAvailable = await _checkDuplicate();
            _isAvailableId = isAvailable;
            _validateForm();
          },
          child: Text('아이디 중복 확인'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // 버튼 텍스트 색상
            backgroundColor: Colors.green, // 버튼 배경색
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // 둥근 모서리
            ),
          ),
        ),
      ),
    );
  }

  // 중복 확인 동작
  Future<bool> _checkDuplicate() async {
    String userId = _idController.text;
    if (userId.trim().isEmpty) {
      return false;
    }

    try {
      String url = "http://172.28.112.1:8000/user/handleEmailCheck";
      Response res = await dio.post(url, data: {'user_id': userId});

      bool isAvailableEmail = res.data['success'];
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isAvailableEmail ? '사용 가능한 아이디입니다.' : '중복된 아이디입니다. 다른 아이디로 설정해주세요.')),
      );

      return isAvailableEmail;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

// 제출 버튼 위젯
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Align(
        alignment: Alignment.center, // 버튼을 가운데 정렬
        child: SizedBox(
          width: 300, // 제출 버튼의 너비 조정
          child: ElevatedButton(
            onPressed: () {
              _submitForm();
            },
            child: Text('제출'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // 버튼 텍스트 색상
              backgroundColor: Colors.green, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 둥근 모서리
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 제출 로직
  void _submitForm() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (!_isAvailablePassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호를 일치시켜주세요.')));
      return;
    }
    if (!_isAvailableId) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디 중복체크 또는 다른 아이디를 작성해주세요.')));
      return;
    }
    if (_isFormValid) {
      try {
        String userName = _nameController.text;
        String userId = _idController.text;
        String userPw = _passwordController.text;
        String userPhone = _phoneController.text;
        String userBirthdate = _birthdateController.text;

        String url = "http://172.28.112.1:8000/user/handleJoin";
        Response res = await dio.post(url, data: {
          'user_name': userName,
          'user_id': userId,
          'user_pw': userPw,
          'user_phone': userPhone,
          'user_birthdate': userBirthdate,
          'user_gender': _selectedGender,
        });

        bool isSubmitted = res.data['success'];
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (isSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('회원가입 완료', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 실패'), backgroundColor: Colors.redAccent),
          );
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패'), backgroundColor: Colors.redAccent),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 올바르게 입력해주세요.')));
      return;
    }
  }
}
