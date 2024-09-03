import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GpxNavigation extends StatefulWidget {
  @override
  _GpxNavigationState createState() => _GpxNavigationState();
}

class _GpxNavigationState extends State<GpxNavigation> {

  // NaverMap loding
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async{
    WidgetsFlutterBinding.ensureInitialized();

    // 네이버 앱 인증
    await NaverMapSdk.instance.initialize(
      clientId: '119m2j9zpj',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      },
    );

    // 위치 서비스 확인 및 요청
    Location location = Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // 위치 권한 확인 및 요청
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  // 값 초기화
  NLatLng? _currentPosition;
  NCameraPosition _cameraPosition = const NCameraPosition(
    target: NLatLng(37.5665, 126.978), // 서울 시청
    zoom: 20,
    bearing: 0,
    tilt: 0,
  );

  // Naver Map SDK 초기화
  Future<void> _initializeNaverMapSdk() async {
    await NaverMapSdk.instance.initialize(clientId: '119m2j9zpj');
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
            body: NaverMap(
              forceGesture: true,
              options: NaverMapViewOptions(
                initialCameraPosition: _cameraPosition,
                consumeSymbolTapEvents: false,
                locationButtonEnable: true,
                logoClickEnable: false,
                minZoom: 5, // default is 0
                maxZoom: 17, // default is 21
                extent: const NLatLngBounds(
                  southWest: NLatLng(31.43, 122.37),
                  northEast: NLatLng(44.35, 132.0),
                ),
              ),

              onMapReady: (controller) {
                print("맵 로딩 완료");
                final marker = NMarker(id: "test", position: NLatLng(34.43, 125.37));

                NLocationTrackingMode mode = NLocationTrackingMode.follow;
                controller.setLocationTrackingMode(mode);

                controller.addOverlay(marker);
              },


            ),
          );
        }
      },
    );
  }
}
