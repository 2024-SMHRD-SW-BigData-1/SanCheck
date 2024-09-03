import 'package:flutter/material.dart';

class WeatherModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '날씨 정보',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 24,
                    fontWeight: FontWeight.bold, // 볼드체로 설정
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.black54,
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/hygrometer.png',
                  title: '습도',
                  value: '40%',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/color/96/cold.png',
                  title: '일 최저 기온 (˚C)',
                  value: '24 ˚C',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/color/96/hot.png',
                  title: '일 최고 기온 (˚C)',
                  value: '31 ˚C',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/thermometer.png',
                  title: '1시간 기온 (˚C)',
                  value: '27 ˚C',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/wind.png',
                  title: '풍속 (m/s)',
                  value: '0.5 m/s',
                  hasDivider: true,
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios/50/rainy-weather.png',
                  title: '강수 확률',
                  value: '40%',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/umbrella.png',
                  title: '강수 형태',
                  value: '비',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/rain.png',
                  title: '1시간 강수량 (mm)',
                  value: '5 mm',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/snow.png',
                  title: '1시간 신적설 (cm)',
                  value: '0 cm',
                ),
                _buildWeatherInfo(
                  iconUrl: 'https://img.icons8.com/ios-filled/100/cloud.png',
                  title: '하늘 상태',
                  value: '구름많음',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo({
    required String iconUrl,
    required String title,
    required String value,
    bool hasDivider = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            iconUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red); // 대체 아이콘
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 16,
                fontWeight: FontWeight.bold, // 볼드체로 설정
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 16,
              fontWeight: FontWeight.bold, // 볼드체로 설정
            ),
          ),
        ],
      ),
    );
  }
}
