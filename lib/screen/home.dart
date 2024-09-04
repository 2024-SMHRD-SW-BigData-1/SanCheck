import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sancheck/provider/mountain_provider.dart';
import 'package:sancheck/screen/home_mt_detail.dart';
import 'gpx_navigation.dart'; // GpxNavigation 클래스를 포함한 파일을 import

Dio dio = Dio();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Provider 초기화
    _searchController.dispose(); // TextController를 dispose
  }

  @override
  Widget build(BuildContext context) {
    final mountainProvider = Provider.of<MountainProvider>(context); // Provider 접근

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // 배경색 설정
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 검색 텍스트 필드
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // 코너 반경을 20으로 설정
                  border: Border.all(color: Colors.black), // 테두리를 검정색으로 설정
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
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 16),
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
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        await mountainProvider.searchMountain(_searchController.text); // 검색 실행
                        if(mountainProvider.mountain == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('검색된 산이 없습니다.'), backgroundColor: Colors.redAccent),
                          );
                        }
                      }, // Call the search method
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 지도 표시 및 현재 위치 버튼
              Container(
                height: 300, // 적당한 높이 설정 (필요에 따라 조정 가능)
                child: GpxNavigation(), // GPX 네비게이션 지도 표시
              ),
              SizedBox(height: 20),

              // 첫 번째 ExpandableButtonList에 매개변수 전달
              ExpandableButtonList(
                title: '인기있는 산',
                items: ["북한산", "남산"],
                buttonColor: Colors.blue,
                iconUrl: 'https://img.icons8.com/3d-fluency/94/fire-element--v2.png', // 아이콘 추가
              ),
              SizedBox(height: 20),
              // 두 번째 ExpandableButtonList에 다른 매개변수 전달
              ExpandableButtonList(
                title: "관심있는 산",
                items: ["북한산", "남산", "지리산"],
                buttonColor: Colors.green,
                iconUrl: 'https://img.icons8.com/emoji/96/sparkling-heart.png', // 아이콘 추가
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ExpandableButtonList extends StatefulWidget {
  final String title;
  final List<String> items;
  final Color buttonColor;
  final String? iconUrl; // 아이콘 URL을 추가

  // 생성자에 매개변수 추가
  ExpandableButtonList({
    required this.title,
    required this.items,
    this.buttonColor = Colors.blue, // 기본 색상 지정 가능
    this.iconUrl, // 아이콘 URL을 받음
  });

  @override
  _ExpandableButtonListState createState() => _ExpandableButtonListState();
}

class _ExpandableButtonListState extends State<ExpandableButtonList> {
  // 리스트의 가시성을 관리하는 변수
  bool _isExpanded = false;

  // 관심있는 산을 저장하는 Set
  Set<String> favoriteItems = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildStyledButton(
                    widget.items[index],
                    onPressed: () {
                      print("${widget.items[index]} 버튼이 눌렸습니다.");
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeMtDetail(mountainName: 'name')));
                    },
                    trailingIcon: favoriteItems.contains(widget.items[index])
                        ? Icons.star // 채워진 별
                        : Icons.star_border, // 빈 별
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

  // 아이폰 건강 앱 스타일의 버튼 생성 함수
  Widget _buildStyledButton(String text,
      {String? iconUrl, required VoidCallback onPressed, IconData? trailingIcon, VoidCallback? onTrailingIconPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Color(0x3F000000); // 눌렀을 때의 색상
            }
            return null; // 기본 상태에서는 색상을 설정하지 않음
          },
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (iconUrl != null) ...[
                Image.network(iconUrl, width: 24, height: 24), // 아이콘 추가
                SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
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
