import 'package:dio/dio.dart';
import 'convertGridGps.dart';
import 'weatherAPITimeSync.dart';

class ApiService {
  Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(milliseconds: 100000),
    receiveTimeout: const Duration(milliseconds: 100000),
  ));

  Future<Map<String, dynamic>> fetchData(
      {required double nx,
      required double ny,
      required String closestTime,
      required String formattedDate}) async {
    Map grid = ConvGridGps.gpsToGRID(nx, ny);
    try {
      final response = await dio.get(
        'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst',
        queryParameters: {
          'pageNo': 1,
          'numOfRows': 1000,
          'dataType': 'JSON',
          'base_date': formattedDate,
          'base_time': closestTime,
          'nx': grid["x"],
          'ny': grid["y"],
          'ServiceKey':
              'WV3QZ/dUdCnsFxVfeuEYMjxvg7LmB7NYusrOHeg8jES82fxxPaDjXyXQuzu/Zfz19CXmhShTRb4wTbYpiOskHA=='
        },
      );
      return parseWeatherData(response.data);
    } catch (e) {
      // 에러 핸들링
      throw Exception('Failed to load data');
    }
  }

  Map<String, Map<String, dynamic>> parseWeatherData(Map<String, dynamic> jsonData) {
    final items = jsonData['response']['body']['items']['item'] as List;
    final Map<String, Map<String, dynamic>> resultMap = {};

    for (var item in items) {
      String time = item['fcstDate'] + item['fcstTime'];
      String category = item['category'];
      dynamic value = item['fcstValue'];

      // WAV = 파고, VEC = 풍향, WSD = 풍속, SKY = 하늘상태, PCP =강수량 POP= 강수확률, TMP = 기온
      if (['POP', 'WAV', 'VEC', 'WSD', 'SKY', 'PCP', 'TMP'].contains(category)) {
        if (!resultMap.containsKey(time)) {
          resultMap[time] = {};
        }
        resultMap[time]![category] = value;
      }
    }

    return resultMap;
  }
}
