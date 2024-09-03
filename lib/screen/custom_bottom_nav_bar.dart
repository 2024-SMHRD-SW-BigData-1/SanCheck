import 'package:flutter/material.dart';
import 'hike.dart'; // 'Hike' 클래스를 포함한 파일을 import
import 'home.dart'; // 'Home' 클래스를 포함하는 파일을 import
import 'community.dart'; // 'Community' 클래스를 포함하는 파일을 import
import 'mypage.dart'; // 'MyPage' 클래스를 포함하는 파일을 import

class CustomBottomNavBar extends StatelessWidget {
  final String selectedItem;
  final ValueChanged<String> onItemSelected;

  CustomBottomNavBar({
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF), // 네비게이션 바 배경 색상
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(16),
        ), // 상하단 모서리 모두 둥글게
        border: Border.all(
          color: Colors.black26, // 테두리 색상
          width: 1, // 테두리 두께
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            '등산하기',
            'https://img.icons8.com/pulsar-color/96/mission-of-a-company.png',
            'https://img.icons8.com/pulsar-line/96/mission-of-a-company.png',
            '등산하기',
            context,
          ),
          _buildNavItem(
            'HOME',
            'https://img.icons8.com/pulsar-color/96/home.png',
            'https://img.icons8.com/pulsar-line/96/home.png',
            'HOME',
            context,
          ),
          _buildNavItem(
            '커뮤니티',
            'https://img.icons8.com/pulsar-color/96/groups.png',
            'https://img.icons8.com/pulsar-line/96/groups.png',
            '커뮤니티',
            context,
          ),
          _buildNavItem(
            '마이페이지',
            'https://img.icons8.com/pulsar-color/96/user-male-circle.png',
            'https://img.icons8.com/pulsar-line/96/user-male-circle.png',
            '마이페이지',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      String title,
      String selectedImageUrl,
      String unselectedImageUrl,
      String value,
      BuildContext context,
      ) {
    bool isSelected = selectedItem == value;
    return GestureDetector(
      onTap: () {
        onItemSelected(value);
        // 페이지 이동 로직 추가
        if (value == '등산하기') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Hike()), // hike.dart에서 Hike 페이지로 이동
          );
        } else if (value == 'HOME') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // home.dart에서 Home 페이지로 이동
          );
        } else if (value == '커뮤니티') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Community()), // community.dart에서 Community 페이지로 이동
          );
        } else if (value == '마이페이지') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPage()), // 현재 페이지 유지
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            isSelected ? selectedImageUrl : unselectedImageUrl,
            width: 24, // 아이콘의 크기를 조정합니다.
            height: 24,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, // 선택된 아이템과 아닌 아이템의 두께 조절
              decoration: TextDecoration.none, // 텍스트 아래에 밑줄 제거
            ),
          ),
        ],
      ),
    );
  }
}
