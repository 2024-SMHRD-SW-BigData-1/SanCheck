import 'package:flutter/material.dart';
import 'package:sancheck/screen/my_info.dart';
import 'package:sancheck/screen/login_page.dart'; // login_page.dart 파일을 import
import 'package:sancheck/service/auth_service.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final AuthService _authService = AuthService(); // AuthService 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // 프로필 정보
              Positioned(
                left: 10,
                top: 69,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 75,
                top: 83,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👶🏻 등린이', style: TextStyle(fontSize: 20, color: Colors.grey)),
                    Text('팜하니', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
                  ],
                ),
              ),
              // 메뉴 버튼들
              Positioned(
                left: 47,
                top: 155,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuButton('내 정보'),
                    SizedBox(height: 10),
                    _buildMenuButton('등산 기록'),
                    SizedBox(height: 10),
                    _buildMenuButton('수집 메달'),
                    SizedBox(height: 10),
                    _buildLogoutButton(context), // 로그아웃 버튼 수정
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 메뉴 버튼 생성 함수
  Widget _buildMenuButton(String title) {
    return SizedBox(
      width: 318,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // 여기에 버튼 클릭 시 실행할 기능을 추가하세요.
          switch (title) {
            case '내 정보':
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MyInfo()));
              break;
            case '등산 기록':
              return;
            case '수집 메달':
              return;
            default:
              return;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // 초록색 버튼
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // 로그아웃 버튼 생성 함수
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: 318,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          handleLogout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '로그아웃',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  void handleLogout() async {
    try {
      await _authService.logout(); // AuthService를 사용하여 로그아웃 처리

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()), // 이동할 페이지
            (Route<dynamic> route) => false, // 모든 이전 화면을 제거
      );
    } catch (e) {
      print('Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그아웃 실패'), backgroundColor: Colors.redAccent));
    }
  }
}
