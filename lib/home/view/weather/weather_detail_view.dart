import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/colors.dart';
import '../../../theme/font.dart';

class WeatherDetailView extends StatefulWidget {
  final Map<String, dynamic> data;
  final int differenceInMinutes;

  const WeatherDetailView({super.key, required this.data, required this.differenceInMinutes});

  @override
  _WeatherDetailViewState createState() => _WeatherDetailViewState();
}

class _WeatherDetailViewState extends State<WeatherDetailView> {
  final ScrollController _scrollController = ScrollController();
  late DateTime _currentTime;
  late DateTime _initialTime;
  bool _hasJumped = false;

  @override
  void initState() {
    super.initState();
    _initialTime = DateTime.now();
    _currentTime = _initialTime;

    _scrollController.addListener(() {
      setState(() {
        double scrollPosition = _scrollController.position.pixels - widget.differenceInMinutes + 90 ;
        _currentTime = _initialTime.add(Duration(minutes: (scrollPosition / 1).round()));
      });
    });
    if (!_hasJumped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(widget.differenceInMinutes.toDouble() - 90);
      });
      _hasJumped = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInformationProvider = Provider.of<UserInformationProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 58),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 24, // 커스텀 앱바 높이 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/favorites'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, size: 24, color: primaryBlue500),
                      Text(userInformationProvider.location.name, style: body2(black)),
                    ],
                  ),
                ),
                const SizedBox(width: 48), // 우측 정렬을 맞추기 위한 여백
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40,
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
                        if (await canLaunch(url)) {
                          await launch(url);
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
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: gray2)),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "날씨 및 해양정보",
                            style: body2(gray8),
                            textAlign: TextAlign.left,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // 고정된 제목 Column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              Text('시간', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              Text('날씨', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              Text('온도', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text('강수\n확률', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text('풍속', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              Text('풍향', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              Text('강수량', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              Text('파고', style: caption2(gray4), textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                            ],
                          ),

                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 1,
                            child: Divider(
                              color: gray1,
                              height: 240,
                              thickness: 240,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          // 스크롤 가능한 데이터 부분
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // 가로 스크롤
                              controller: _scrollController,
                              child: Row(
                                children: widget.data.entries.map((entry) {
                                  String time =
                                      "${entry.key.substring(8, 10)}:${entry.key.substring(10, 12)}";
                                  Map<String, dynamic> weatherInfo = entry.value;
                                  String rain;
                                  if (weatherInfo['PCP'] == "강수없음") {
                                    rain = "0mm";
                                  } else if (weatherInfo['PCP'] == "1mm 미만") {
                                    rain = "1mm";
                                  } else {
                                    rain = weatherInfo['PCP'];
                                  }
                                  String icon = _getWeatherIcon(int.parse(weatherInfo['SKY']));

                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: weatherColumn(
                                        time,
                                        icon,
                                        '${weatherInfo['TMP']}°C',
                                        '${weatherInfo['POP']}%',
                                        '${weatherInfo['WSD']}m/s',
                                        int.parse(weatherInfo['VEC']),
                                        rain,
                                        '${weatherInfo['WAV']}m'),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 94,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  height: 5,
                  child: VerticalDivider(
                    indent: 90,
                    color: primaryBlue500,
                    thickness: 2,
                    width: 20,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 55),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeatherIcon(int sky) {
    switch (sky) {
      case 1:
        return 'assets/icons/sun.svg';
      case 2:
        return ('assets/icons/clouds.svg');
      case 3:
        return  ('assets/icons/cloudSun.svg');
      case 4:
        return ('assets/icons/rain.svg'); // 비 또는 눈 아이콘으로 변경 가능
      default:
        return ('assets/icons/sun.svg');
    }
  }

  Widget weatherColumn(String time, String icon, String temp, String rainPercent,
      String windSpeed, int vec, String rain, String waveHeight) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: caption2(gray4), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          SvgPicture.asset(icon),
          const SizedBox(height: 10),
          Text(temp, style: caption2(gray6), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(rainPercent, style: caption2(gray6), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(windSpeed, style: caption2(gray6), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Transform.rotate(
            angle: vec * (3.14159 / 180), // 각도를 라디안으로 변환
            child: SvgPicture.asset('assets/icons/azimuth.svg'), // 회전시킬 화살표 SVG 파일
          ),
          const SizedBox(height: 10),
          Text(rain, style: caption2(gray6), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(waveHeight, style: caption2(gray6), textAlign: TextAlign.center),
        ],
      ),
    );
  }

}

