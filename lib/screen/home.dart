import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'gpx_navigation.dart'; // GpxNavigation 클래스를 포함한 파일을 import
import 'home_mt_detail.dart'; // Import the detail page
import 'level_mt.dart'; // 난이도별 코스 상세 페이지 import

Dio dio = Dio();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        'https://img.icons8.com/pastel-glyph/64/location--v3.png',
                        width: screenWidth * 0.06,
                        height: screenHeight * 0.03,
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '산 검색하기',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.network(
                          'https://img.icons8.com/metro/52/search.png',
                          width: screenWidth * 0.06,
                          height: screenHeight * 0.03,
                        ),
                        onPressed: () => {_search()},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  height: screenHeight * 0.4,
                  child: GpxNavigation(),
                ),
                SizedBox(height: screenHeight * 0.02),
                ExpandableButtonList(
                  title: '인기있는 산',
                  items: ["북한산", "남산"],
                  buttonColor: Colors.blue,
                  iconUrl:
                  'https://img.icons8.com/3d-fluency/94/fire-element--v2.png',
                  isNavigable: true,
                  showStarIcon: true, // 별 아이콘 표시 설정
                  navigateToPage: (selectedItem) => HomeMtDetail(
                    mountainName: selectedItem,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                ExpandableButtonList(
                  title: "관심있는 산",
                  items: ["북한산", "남산", "지리산"],
                  buttonColor: Colors.green,
                  iconUrl:
                  'https://img.icons8.com/emoji/96/sparkling-heart.png',
                  isNavigable: true,
                  showStarIcon: true,
                  navigateToPage: (selectedItem) => HomeMtDetail(
                    mountainName: selectedItem,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                ExpandableButtonList(
                  title: "난이도별 코스",
                  items: ["쉬움", "보통", "어려움"],
                  buttonColor: Colors.orange,
                  iconUrl: 'https://img.icons8.com/color/96/sparkling.png',
                  isNavigable: true,
                  showStarIcon: false, // 별 아이콘 숨기기
                  navigateToPage: (selectedItem) =>
                      LevelMt(level: selectedItem),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    String queryText = _searchController.text;

    if (queryText.isEmpty) {
      return;
    }

    try {
      String url = "http://192.168.219.200:8000/mountain/searchMountain";
      Response res = await dio.get(url, queryParameters: {
        'queryText': queryText,
      });
      print('Request URL: ${res.realUri}');
      print('Status Code: ${res.statusCode}');
      print('Response Data: ${res.data}');
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('검색 실패'), backgroundColor: Colors.redAccent));
    }
  }
}

class ExpandableButtonList extends StatefulWidget {
  final String title;
  final List<String> items;
  final Color buttonColor;
  final String? iconUrl;
  final bool isNavigable;
  final bool showStarIcon; // 별 아이콘 표시 여부 플래그 추가
  final Widget Function(String)? navigateToPage;

  ExpandableButtonList({
    required this.title,
    required this.items,
    this.buttonColor = Colors.blue,
    this.iconUrl,
    this.isNavigable = true,
    this.showStarIcon = true, // 기본값으로 별 아이콘을 표시하도록 설정
    this.navigateToPage,
  });

  @override
  _ExpandableButtonListState createState() => _ExpandableButtonListState();
}

class _ExpandableButtonListState extends State<ExpandableButtonList> {
  bool _isExpanded = false;
  Set<String> favoriteItems = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStyledButton(widget.title, iconUrl: widget.iconUrl, onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded ? 200 : 0,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                  child: _buildStyledButton(
                    widget.items[index],
                    onPressed: () {
                      if (widget.isNavigable && widget.navigateToPage != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                widget.navigateToPage!(widget.items[index]),
                          ),
                        );
                      }
                    },
                    trailingIcon: widget.showStarIcon &&
                        favoriteItems.contains(widget.items[index])
                        ? Icons.star
                        : widget.showStarIcon
                        ? Icons.star_border
                        : null, // 별 아이콘 표시 여부 조건 추가
                    onTrailingIconPressed: () {
                      setState(() {
                        if (favoriteItems.contains(widget.items[index])) {
                          favoriteItems.remove(widget.items[index]);
                        } else {
                          favoriteItems.add(widget.items[index]);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(String text,
      {String? iconUrl,
        required VoidCallback onPressed,
        IconData? trailingIcon,
        VoidCallback? onTrailingIconPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
                vertical: screenWidth * 0.04, horizontal: screenWidth * 0.06)),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (iconUrl != null) ...[
                Image.network(iconUrl,
                    width: screenWidth * 0.06, height: screenWidth * 0.06),
                SizedBox(width: screenWidth * 0.02),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (trailingIcon != null)
            IconButton(
              icon: Icon(trailingIcon, color: Colors.yellow[700]),
              onPressed: onTrailingIconPressed,
            ),
        ],
      ),
    );
  }
}
