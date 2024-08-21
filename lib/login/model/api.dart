import 'package:dio/dio.dart';

class ApiService {
  Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(milliseconds: 100000),
    receiveTimeout: const Duration(milliseconds: 100000),
  ));


  Future<Map<String, dynamic>> fetchData(/*{required String tm, required String stn}*/) async {
    try {
      final response = await dio.get(
        'https://apihub.kma.go.kr/api/typ01/url/sea_obs.php',
        queryParameters: {
          'tm': 202301241200, // 시간 tm
          'stn': 0, //위치 stn
          'help': '0',
          'authKey': "r6zpsnyoT4ys6bJ8qF-MCw",
        },
      );
      print(parseObservationData(response.data));
      return parseObservationData(response.data);
    } catch (e) {
      // 에러 핸들링
      throw Exception('Failed to load data');
    }
  }


  Map<String, dynamic> parseObservationData(String data) {
    final lines = data.trim().split('\n');
    // 필드 헤더를 정의합니다.
    final headers = [
      'TP', 'TM', 'STN_ID', 'STN_KO', 'LON', 'LAT', 'WH', 'WD', 'WS', 'WS_GST',
      'TW', 'TA', 'PA', 'HM'
    ];
    final List<Map<String, String>> parsedData = [];

    // 데이터 시작 부분을 찾아서 파싱 시작
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('#') || line.isEmpty) {
        continue; // 주석이나 빈 줄 건너뜀
      }

      // 데이터를 쉼표로 구분하여 필드로 분리
      final values = line.split(RegExp(r',\s*'));
      if (values.length < headers.length) {
        continue; // 필드 개수가 맞지 않으면 건너뜀
      }

      // 각 필드 값을 헤더에 맞춰 매핑
      final Map<String, String> row = {};
      for (int j = 0; j < headers.length; j++) {
        row[headers[j]] = values[j].trim();
      }
      parsedData.add(row);
    }

    return parsedData[1];
  }

}
