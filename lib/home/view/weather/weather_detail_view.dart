import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
        double scrollPosition = _scrollController.position.pixels - widget.differenceInMinutes + 46;
        _currentTime = _initialTime.add(Duration(minutes: (scrollPosition / 1).round()));
      });
    });
    if (!_hasJumped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(widget.differenceInMinutes.toDouble() - 46);
      });
      _hasJumped = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInformationProvider = Provider.of<UserInformationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/favorites'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 24, color: primaryBlue500),
              Text(userInformationProvider.location.name),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                    child: Text(
                      '기상특보 6.28 18:00 서해 앞바다 풍랑주의보',
                      style: body3(Colors.white),
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
                            style: caption1(gray8),
                            textAlign: TextAlign.left,
                          )),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 가로 스크롤
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                          child: Row(
                            children: [
                              // 제목 Row 추가
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
                              const SizedBox(
                                width: 1,
                                child: Divider(
                                  color: gray1,
                                  height: 158,
                                  thickness: 300,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Row(
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

                                  String direction =
                                      _convertVecToDirection(int.parse(weatherInfo['VEC']));
                                  IconData icon = _getWeatherIcon(int.parse(weatherInfo['SKY']));

                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: weatherColumn(
                                        time,
                                        icon,
                                        '${weatherInfo['TMP']}°C',
                                        '${weatherInfo['POP']}%',
                                        '${weatherInfo['WSD']}m/s',
                                        direction,
                                        rain,
                                        '${weatherInfo['WAV']}m'),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 65,
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
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28),
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
