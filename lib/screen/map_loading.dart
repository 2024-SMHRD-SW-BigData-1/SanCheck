import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hike extends StatefulWidget {
  const Hike({super.key});

  @override
  _HikeState createState() => _HikeState();
}

class _HikeState extends State<Hike> {
  bool _isTracking = false;
  bool _isPaused = false;
  Timer? _timer;
  ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadTimerValue(); // 앱 시작 시 저장된 타이머 값 불러오기
  }

  Future<void> _saveTimerValue(int seconds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timer_value', seconds);
  }

  Future<void> _loadTimerValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedSeconds = prefs.getInt('timer_value') ?? 0;
    _secondsNotifier.value = savedSeconds;
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;

      if (_isTracking) {
        _startTimer();
        _isPaused = false;
      } else {
        _pauseTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _secondsNotifier.value++;
      _saveTimerValue(_secondsNotifier.value); // 타이머 값 저장
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _isTracking = false;
      _isPaused = false;
      _secondsNotifier.value = 0;
      _saveTimerValue(0); // 타이머 값 초기화 후 저장
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsNotifier.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    final int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('등산하기'),
            if (_isTracking)
              Row(
                children: [
                  Text('경과 시간: ', style: TextStyle(fontSize: 16)),
                  ValueListenableBuilder<int>(
                    valueListenable: _secondsNotifier,
                    builder: (context, seconds, child) {
                      return Text(
                        _formatTime(seconds),
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // MapLoading을 별도의 위젯으로 분리하여 새로고침 문제를 방지합니다.
          MapLoading(),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isTracking)
                  IconButton(
                    icon: Image.network('https://img.icons8.com/ios-glyphs/90/40C057/go.png'),
                    onPressed: _toggleTracking,
                  ),
                if (_isTracking)
                  Row(
                    children: [
                      IconButton(
                        icon: Image.network(
                          _isPaused
                              ? 'https://img.icons8.com/ios-glyphs/90/40C057/circled-play.png'
                              : 'https://img.icons8.com/ios-filled/100/40C057/circled-pause.png',
                        ),
                        onPressed: () {
                          setState(() {
                            if (_isPaused) {
                              _startTimer();
                            } else {
                              _pauseTimer();
                            }
                            _isPaused = !_isPaused;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 지도만 관리하는 위젯을 별도로 분리하여 새로고침 문제를 방지합니다.
class MapLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(37.5665, 126.978),
          zoom: 10,
          bearing: 0,
          tilt: 0,
        ),
        consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) {
        NLocationTrackingMode mode = NLocationTrackingMode.follow;
        controller.setLocationTrackingMode(mode);
        print("맵 로딩 완료");
      },
    );
  }
}
