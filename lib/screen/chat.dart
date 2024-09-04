import 'dart:async';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text,
          'isAutoReply': false,
        });
        _controller.clear();
      });

      Timer(Duration(seconds: 1), _sendAutoReply);
    }
  }

  void _sendAutoReply() {
    setState(() {
      _messages.add({
        'text': '답장: 여기 자동 응답 메시지가 나타납니다!',
        'isAutoReply': true,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInitialMessage(),
                  SizedBox(height: 16),
                  ..._messages.map((message) => _buildMessage(
                    message['text'],
                    message['isAutoReply'],
                  )),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, -2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF87B85C)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isAutoReply) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isAutoReply ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAutoReply) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.network(
                'https://img.icons8.com/doodle/96/retro-robot.png',
                width: 32,
                height: 32,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isAutoReply ? Colors.grey[200] : Color(0xFF87B85C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isAutoReply ? 0 : 16),
                  bottomRight: Radius.circular(isAutoReply ? 16 : 0),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isAutoReply ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://img.icons8.com/doodle/96/retro-robot.png',
          width: 32,
          height: 32,
        ),
        SizedBox(width: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '무엇이든 물어보세요',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.2,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // 배경 투명 설정
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24), // 팝업 위치 조정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 팝업 전체 둥글게
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // 내부 테두리 둥글게 설정
            child: Container(
              color: Colors.white, // 배경색 설정
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // 이미지 둥글게
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // 버튼 색상 설정
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // 버튼 테두리 둥글게 설정
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        '닫기',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
