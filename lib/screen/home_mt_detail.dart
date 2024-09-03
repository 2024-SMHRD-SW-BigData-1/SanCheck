import 'package:flutter/material.dart';
import 'package:sancheck/screen/login_success.dart';
import 'hike.dart'; // Hike 클래스를 import

class HomeMtDetail extends StatefulWidget {
  final String mountainName;

  HomeMtDetail({required this.mountainName});

  @override
  _HomeMtDetailState createState() => _HomeMtDetailState();
}

class _HomeMtDetailState extends State<HomeMtDetail> {
  Set<String> favoriteItems = {};
  List<bool> _isOpenList = [];

  final List<Map<String, String>> courseDetails = [
    {'difficulty': '쉬움', 'time': '1시간', 'distance': '2.5km'},
    {'difficulty': '보통', 'time': '1시간 30분', 'distance': '3.0km'},
    {'difficulty': '어려움', 'time': '2시간', 'distance': '4.5km'},
    {'difficulty': '쉬움', 'time': '45분', 'distance': '1.5km'},
    {'difficulty': '보통', 'time': '2시간 30분', 'distance': '5.0km'},
  ];

  final List<List<String>> subCourses = [
    ['1', '2', '3', '4', '5'],
    ['1', '2', '3'],
    ['1', '2', '3', '4'],
    ['1', '2'],
    ['1', '2', '3', '4', '5', '6']
  ];

  @override
  void initState() {
    super.initState();
    _isOpenList = List.generate(courseDetails.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('${widget.mountainName} 코스 리스트'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            _buildStyledButton(
              widget.mountainName,
              trailingIcon: favoriteItems.contains(widget.mountainName)
                  ? Icons.star
                  : Icons.star_border,
              onTrailingIconPressed: () {
                setState(() {
                  if (favoriteItems.contains(widget.mountainName)) {
                    favoriteItems.remove(widget.mountainName);
                  } else {
                    favoriteItems.add(widget.mountainName);
                  }
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: courseDetails.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildStyledButton(
                        '코스 ${index + 1} 상세 보기',
                        trailingIcon: _isOpenList[index]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        courseInfo: courseDetails[index],
                        onPressed: () {
                          setState(() {
                            _isOpenList[index] = !_isOpenList[index];
                          });
                        },
                        hasRouteButton: true, // 길찾기 버튼이 있는지 여부
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: _isOpenList[index] ? subCourses[index].length *
                            120.0 : 0,
                        child: _isOpenList[index]
                            ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: subCourses[index].length,
                          itemBuilder: (context, subIndex) {
                            return _buildSubCourseItem(
                                subCourses[index][subIndex]);
                          },
                        )
                            : SizedBox(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(String text,
      {IconData? trailingIcon,
        Map<String, String>? courseInfo,
        VoidCallback? onTrailingIconPressed,
        VoidCallback? onPressed,
        bool hasRouteButton = false}) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      width: screenWidth * 0.92,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              vertical: screenWidth * 0.04,
              horizontal: screenWidth * 0.06,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Color(0x3F000000);
              }
              return null;
            },
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (courseInfo != null) ...[
                    Row(
                      children: [
                        Text(
                          '🚩 ${courseInfo['difficulty'] ?? ''}',
                          style: TextStyle(fontSize: screenWidth * 0.04,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '⏱ ${courseInfo['time'] ?? ''}',
                          style: TextStyle(fontSize: screenWidth * 0.04,
                              color: Colors.black),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '🏃‍♂️ ${courseInfo['distance'] ?? ''}',
                          style: TextStyle(fontSize: screenWidth * 0.04,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (hasRouteButton)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginSuccess(selectedIndex: 0),
                      ),
                          (Route<dynamic> route) => false, // 모든 이전 화면을 제거
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  child: Text(
                    '길찾기',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (trailingIcon != null)
              IconButton(
                icon: Icon(trailingIcon, color: Colors.black),
                onPressed: onTrailingIconPressed,
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildCourseInfo(Map<String, String> courseInfo) {
    return Row(
      children: [
        _buildInfoItem('🚩', courseInfo['difficulty'] ?? ''),
        SizedBox(width: 10),
        _buildInfoItem('⏱', courseInfo['time'] ?? ''),
        SizedBox(width: 10),
        _buildInfoItem('🏃‍♂️', courseInfo['distance'] ?? ''),
      ],
    );
  }

  Widget _buildInfoItem(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSubCourseItem(String subCourseNumber) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: screenWidth * 0.9,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                _showImagePopup(context,
                    'https://via.placeholder.com/400'),
            child: Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/90'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '세부 코스 $subCourseNumber',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '세부 코스 ${subCourseNumber}의 설명이 여기에 나옵니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // 초록색으로 변경
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    '닫기',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}