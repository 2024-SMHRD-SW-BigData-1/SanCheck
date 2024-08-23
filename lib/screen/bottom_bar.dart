import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFFD9D9D9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('등산하기', 0),
          _buildNavItem('HOME', 1),
          _buildNavItem('커뮤니티', 2),
          _buildNavItem('마이페이지', 3, isSelected: currentIndex == 3),
        ],
      ),
    );
  }

  // 내비게이션 아이템 위젯
  Widget _buildNavItem(String title, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.black,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
        ),
      ),
    );
  }
}
