import 'package:flutter/material.dart';
import 'mypage.dart'; // 'MyPage' 클래스를 가져오는 경우

class CustomBottomNavBar extends StatelessWidget {
  final String selectedItem;

  CustomBottomNavBar({required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(16),
        ), // 상하단 모서리 모두 둥글게
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('등산하기', () {
            // '등산하기' 클릭 시 다른 페이지로 이동하는 기능 추가
          }, selected: selectedItem == '등산하기'),
          _buildNavItem('HOME', () {
            // 'HOME' 클릭 시 다른 페이지로 이동하는 기능 추가
          }, selected: selectedItem == 'HOME'),
          _buildNavItem('커뮤니티', () {
            // '커뮤니티' 클릭 시 다른 페이지로 이동하는 기능 추가
          }, selected: selectedItem == '커뮤니티'),
          _buildNavItem('마이페이지', () {
            // '마이페이지' 클릭 시 다른 페이지로 이동하는 기능 추가
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          }, selected: selectedItem == '마이페이지'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap, {required bool selected}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.black : Colors.black,
          fontSize: 16,
          fontWeight: selected ? FontWeight.w900 : FontWeight.w400,
        ),
      ),
    );
  }
}
