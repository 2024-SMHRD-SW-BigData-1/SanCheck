import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sancheck/screen/phone_formatter.dart';
import 'package:sancheck/service/auth_service.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final AuthService _authService = AuthService(); // 서비스 인스턴스 생성

  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool _isAvailableId = false;
  bool _isAvailablePassword = false;
  bool _isFormValid = false;
  String _selectedGender = '남성';

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

  Future<void> _checkDuplicate() async {
    final userId = _idController.text;
    if (userId.trim().isEmpty) {
      return;
    }
    final isAvailable = await _authService.checkDuplicate(userId);
    setState(() {
      _isAvailableId = isAvailable;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAvailable ? '사용 가능한 아이디입니다.' : '중복된 아이디입니다. 다른 아이디로 설정해주세요.'),
      ),
    );
  }

  Future<void> _submitForm() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (!_isAvailablePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호를 일치시켜주세요.')),
      );
      return;
    }
    if (!_isAvailableId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 중복체크 또는 다른 아이디를 작성해주세요.')),
      );
      return;
    }
    if (_isFormValid) {
      try {
        final isSubmitted = await _authService.submitForm(
          userName: _nameController.text,
          userId: _idController.text,
          userPw: _passwordController.text,
          userPhone: _phoneController.text,
          userBirthdate: _birthdateController.text,
          userGender: _selectedGender,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSubmitted ? '회원가입 완료' : '회원가입 실패'),
            backgroundColor: isSubmitted ? Colors.lightBlueAccent : Colors.redAccent,
          ),
        );
        if (isSubmitted) {
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패'), backgroundColor: Colors.redAccent),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 올바르게 입력해주세요.')),
      );
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
          ],
        ),
      ),
    );
  }

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
              _buildCheckDuplicateButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildPasswordField('비밀번호', '비밀번호를 입력해 주세요.', true, controller: _passwordController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildPasswordField('비밀번호 확인', '비밀번호를 다시 입력해주세요', false, controller: _confirmPasswordController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              _buildTextField('전화번호', '전화번호를 입력해 주세요.', controller: _phoneController, isPhoneNumber: true),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '생년월일',
                style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthdateController,
                    decoration: InputDecoration(
                      hintText: '생년월일을 선택해 주세요.',
                      hintStyle: TextStyle(color: Color(0xFFB1B1B1)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                '성별',
                style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
              ),
              _buildGenderRadioButtons(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: ElevatedButton(
                  onPressed: _isFormValid ? _submitForm : null,
                  child: Text('가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {TextEditingController? controller, bool isPhoneNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFFB1B1B1)),
            border: OutlineInputBorder(),
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

  Widget _buildCheckDuplicateButton() {
    return ElevatedButton(
      onPressed: _checkDuplicate,
      child: Text('아이디 중복 확인'),
    );
  }

  Widget _buildGenderRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio<String>(
              value: '남성',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            Text('남성'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: '여성',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            Text('여성'),
          ],
        ),
      ],
    );
  }
}
