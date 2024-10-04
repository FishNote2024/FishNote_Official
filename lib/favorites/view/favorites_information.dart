import 'package:fish_note/home/model/weatherAPITimeSync.dart';
import 'package:fish_note/home/model/weather_api.dart';
import 'package:fish_note/signUp/model/location.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesInformation extends StatefulWidget {
  const FavoritesInformation({super.key, required this.location});

  final LocationInfo location;

  @override
  State<FavoritesInformation> createState() => _FavoritesInformationState();
}

class _FavoritesInformationState extends State<FavoritesInformation> {
  final ScrollController _scrollController = ScrollController();
  late Future<Map<String, dynamic>> weatherData;
  late Map<String, dynamic> data;
  late DateTime _currentTime;
  late DateTime _initialTime;
  bool _hasJumped = false;
  int differenceInMinutes = 0;

  @override
  void initState() {
    super.initState();
    _initialTime = DateTime.now();
    _currentTime = _initialTime;

    ApiService apiService = ApiService();
    WeatherAPITimeSync closestForecastTime = WeatherAPITimeSync();
    String closestTime = closestForecastTime.getClosestTime(
        DateTime.now()); //'0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300'
    String formattedDate = closestForecastTime.getFormattedDate(DateTime.now()); //'20240809'
    weatherData = apiService.fetchData(
        nx: widget.location.latlon.latitude,
        ny: widget.location.latlon.longitude,
        closestTime: closestTime,
        formattedDate: formattedDate);

// 날짜 문자열을 DateTime 객체로 변환
    int year = int.parse(formattedDate.substring(0, 4));
    int month = int.parse(formattedDate.substring(4, 6));
    int day = int.parse(formattedDate.substring(6, 8));

// 시간 문자열을 시간과 분으로 분리하여 정수로 변환
    int hour = int.parse(closestTime.substring(0, 2));
    int minute = int.parse(closestTime.substring(2, 4));

// DateTime 객체 생성
    DateTime dateTime = DateTime(year, month, day, hour, minute);

    Duration difference = _initialTime.difference(dateTime);
    differenceInMinutes = difference.inMinutes;

    _scrollController.addListener(() {
      setState(() {
        double scrollPosition = _scrollController.position.pixels - differenceInMinutes + 88;
        _currentTime = _initialTime.add(Duration(minutes: (scrollPosition / 1).round()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        actions: const [SizedBox(width: 50)],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 24, color: primaryBlue300),
            Text(
                widget.location.name == ''
                    ? '위도 ${widget.location.latlon.latitude} 경도 ${widget.location.latlon.longitude}'
                    : widget.location.name,
                style: body2()),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: alertRedDefault,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/noti.svg'),
                const SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      const url = 'https://www.weatheri.co.kr/special/special01.php'; // 이동할 링크
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      '기상특보 확인하기',
                      style: body3(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: gray2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "날씨 및 해양정보",
                      style: caption1(gray8),
                      textAlign: TextAlign.left,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                        future: weatherData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No data available'));
                          }

                          data = snapshot.data!;

                          if (!_hasJumped) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollController.jumpTo(differenceInMinutes.toDouble() - 88);
                            });
                            _hasJumped = true;
                          }

                          return Row(
                            children: [
                              Column(
                                children: [
                                  Text('시간', style: caption2(gray4)),
                                  const SizedBox(height: 13.0),
                                  Text('날씨', style: caption2(gray4)),
                                  const SizedBox(height: 13.0),
                                  Text('온도', style: caption2(gray4)),
                                  const SizedBox(height: 7.0),
                                  Text('강수\n확률', style: caption2(gray4)),
                                  const SizedBox(height: 7.0),
                                  Text('풍속', style: caption2(gray4)),
                                  const SizedBox(height: 13.0),
                                  Text('풍향', style: caption2(gray4)),
                                  const SizedBox(height: 13.0),
                                  Text('강수량', style: caption2(gray4)),
                                  const SizedBox(height: 13.0),
                                  Text('파고', style: caption2(gray4)),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal, // 가로 스크롤
                                  controller: _scrollController,

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      children: data.entries.map((entry) {
                                        String time =
                                            "${entry.key.substring(8, 10)}:${entry.key.substring(10, 12)}";
                                        Map<String, dynamic> weatherInfo = entry.value;
                                        String rain = (weatherInfo['PCP'] == "강수없음")
                                            ? "0mm"
                                            : weatherInfo['PCP'];

                                        String direction =
                                            _convertVecToDirection(int.parse(weatherInfo['VEC']));
                                        IconData icon =
                                            _getWeatherIcon(int.parse(weatherInfo['SKY']));

                                        return weatherColumn(
                                            time,
                                            icon,
                                            '${weatherInfo['TMP']}°C',
                                            '${weatherInfo['POP']}%',
                                            '${weatherInfo['WSD']}m/s',
                                            direction,
                                            rain,
                                            '${weatherInfo['WAV']}m');
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
              const Positioned(
                left: 90,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    indent: 70,
                    color: primaryBlue500,
                    thickness: 2,
                    width: 20,
                  ),
                ),
              ),
              Positioned(
                left: 53,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: primaryBlue500,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '현재 ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _convertVecToDirection(int vec) {
    if (vec >= 0 && vec < 45) return '↑';
    if (vec >= 45 && vec < 135) return '→';
    if (vec >= 135 && vec < 225) return '↓';
    if (vec >= 225 && vec < 315) return '←';
    return '↑';
  }

  IconData _getWeatherIcon(int sky) {
    switch (sky) {
      case 1:
        return Icons.wb_sunny;
      case 2:
        return Icons.cloud;
      case 3:
        return Icons.cloud_queue;
      case 4:
        return Icons.grain; // 비 또는 눈 아이콘으로 변경 가능
      default:
        return Icons.wb_sunny;
    }
  }

  Widget weatherColumn(String time, IconData icon, String temp, String rainPercent,
      String windSpeed, String direction, String rain, String waveHeight) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Text(time),
          const SizedBox(height: 8),
          Icon(icon),
          const SizedBox(height: 8),
          Text(temp),
          const SizedBox(height: 8),
          Text(rainPercent),
          const SizedBox(height: 8),
          Text(windSpeed),
          const SizedBox(height: 8),
          Text(direction),
          const SizedBox(height: 8),
          Text(rain),
          const SizedBox(height: 8),
          Text(waveHeight),
        ],
      ),
    );
  }
}
