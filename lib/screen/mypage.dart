import 'package:flutter/material.dart';
import 'login_page.dart'; // login_page.dart 파일을 import
import 'bottom_bar.dart'; // bottom_bar.dart 파일을 import

void main() {
  runApp(const FigmaToCodeApp());
}

// Main application widget
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _currentIndex = 3;

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // 페이지 전환 로직 추가
      switch (index) {
        case 0:
        // '등산하기' 페이지로 이동
          break;
        case 1:
        // 'HOME' 페이지로 이동
          break;
        case 2:
        // '커뮤니티' 페이지로 이동
          break;
        case 3:
        // 현재 페이지는 새로고침
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
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
          // 로그아웃 클릭 시 login_page.dart로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
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
}
