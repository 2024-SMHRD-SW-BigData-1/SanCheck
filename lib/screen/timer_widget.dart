import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:sancheck/screen/weather.dart';
import 'package:sancheck/screen/hike_record.dart'; // HikeRecodeModal 정의 파일
import 'custom_bottom_nav_bar.dart'; // CustomBottomNavBar 정의 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
    clientId: '119m2j9zpj',
    onAuthFailed: (ex) {
      print("********* 네이버맵 인증오류 : $ex *********");
    },
  );

  Location location = Location();
  if (!await location.serviceEnabled() && !await location.requestService()) {
    return;
  }

  if (await location.hasPermission() == PermissionStatus.denied &&
      await location.requestPermission() != PermissionStatus.granted) {
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Hike(),
    );
  }
}

class Hike extends StatefulWidget {
  const Hike({super.key});

  @override
  _HikeState createState() => _HikeState();
}

class _HikeState extends State<Hike> {
  static const goIconUrl = 'https://img.icons8.com/fluency/96/go.png';
  static const pauseIconUrl = 'https://img.icons8.com/ios-filled/100/40C057/circled-pause.png';
  static const stopIconUrl = 'https://img.icons8.com/flat-round/64/stop.png';
  static const weatherIconUrl = 'https://img.icons8.com/fluency/96/weather.png';
  static const clockIconUrl = 'https://img.icons8.com/color/96/clock-pokemon.png';

  String _selectedItem = '등산하기';
  NLatLng? _currentPosition;
  NCameraPosition _cameraPosition = const NCameraPosition(
    target: NLatLng(37.5665, 126.978),
    zoom: 10,
    bearing: 0,
    tilt: 0,
  );

  bool _isTracking = false;
  Timer? _timer;
  ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(0);

  Future<void> _initializeNaverMapSdk() async {
    await NaverMapSdk.instance.initialize(clientId: '119m2j9zpj');
  }

  void getLoc() async {
    Location location = Location();
    var loc = await location.getLocation();
    var lat = loc.latitude;
    var lon = loc.longitude;

    setState(() {
      _currentPosition = NLatLng(lat!, lon!);
      _cameraPosition = NCameraPosition(
        target: _currentPosition!,
        zoom: 15,
      );
    });
  }

  void _onNavItemSelected(String value) {
    setState(() {
      _selectedItem = value;
    });
  }

  void _showWeatherModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeatherModal();
      },
    );
  }

  void _showHikeRecodeModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HikeRecordModal();
      },
    );
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;

      if (_isTracking) {
        _startTimer();
      } else {
        _pauseTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _secondsNotifier.value++;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
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
    return FutureBuilder<void>(
      future: _initializeNaverMapSdk(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('등산하기'),
                  Row(
                    children: [
                      Text(
                        '경과 시간: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: _secondsNotifier,
                        builder: (context, seconds, child) {
                          return Text(
                            _formatTime(seconds),
                            style: TextStyle(fontSize: 16),
                          );
                        },
                      ),
                      if (!_isTracking) // Tracking이 중지된 상태에서만 stop 아이콘 표시
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.network(
                            stopIconUrl,
                            width: 32,
                            height: 32,
                          ),
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
                NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: _cameraPosition,
                    consumeSymbolTapEvents: false,
                  ),
                  onMapReady: (controller) {
                    NLocationTrackingMode mode = NLocationTrackingMode.follow;
                    print("맵 로딩 완료");
                    controller.setLocationTrackingMode(mode);
                    if (_currentPosition != null) {
                      var marker = NMarker(
                        id: "currentLoc",
                        position: _currentPosition!,
                      );
                      controller.addOverlay(marker);
                    }
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      icon: Image.network(
                        _isTracking ? pauseIconUrl : goIconUrl,
                        width: 48,
                        height: 48,
                      ),
                      onPressed: _toggleTracking,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 20,
                  child: IconButton(
                    icon: Image.network(
                      weatherIconUrl,
                      width: 48,
                      height: 48,
                    ),
                    onPressed: _showWeatherModal,
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: IconButton(
                    icon: Image.network(
                      clockIconUrl,
                      width: 48,
                      height: 48,
                    ),
                    onPressed: _showHikeRecodeModal,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              selectedItem: _selectedItem,
              onItemSelected: _onNavItemSelected,
            ),
          );
        }
      },
    );
  }
}
