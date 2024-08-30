import 'package:fish_note/home/view/net_wait_card.dart';
import 'package:fish_note/home/view/vertical_outlined_button.dart';
import 'package:fish_note/home/view/weather/weather_detail_view.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fish_note/home/model/weatherAPITimeSync.dart';
import 'package:provider/provider.dart';
import '../model/weather_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;
  late Future<Map<String, dynamic>> weatherData;
  late Map<String, dynamic> data;
  final ScrollController _scrollController = ScrollController();
  bool _hasJumped = false;
  int differenceInMinutes = 0;
  final DateTime _initialTime = DateTime.now();
  DateTime _currentTime = DateTime.now();
  late UserInformationProvider userInformationProvider;
  late LoginModelProvider loginModelProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ApiService apiService = ApiService();
    WeatherAPITimeSync closestForecastTime = WeatherAPITimeSync();
    String closestTime = closestForecastTime.getClosestTime(
        DateTime.now()); //'0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300'
    String formattedDate = closestForecastTime.getFormattedDate(DateTime.now()); //'20240809'
    weatherData = apiService.fetchData(
        nx: 36.190, ny: 129.358, closestTime: closestTime, formattedDate: formattedDate);

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
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundBlue,
          toolbarHeight: 80,
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: IconButton(
              iconSize: 51,
              icon: SvgPicture.asset('assets/icons/logo.svg'),
              onPressed: () {
                print("button pressed");
              },
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/profile.svg'),
              onPressed: () {
                Navigator.pushNamed(context, '/myPage');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/icons/location.svg'),
                        const SizedBox(width: 4.0),
                        Text('서해 바다 50KM', style: body2()),
                      ],
                    ),
                    Text('${currentDate.year}.${currentDate.month}.${currentDate.day}',
                        style: body2()),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
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
                const SizedBox(height: 16.0),
                Stack(children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: gray2)),
                      child: FutureBuilder<Map<String, dynamic>>(
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

                            return Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal, // 가로 스크롤
                                controller: _scrollController,
                                child: Row(
                                  children: [
                                    // 제목 Row 추가
                                    Column(
                                      children: [
                                        Text('시간', style: caption2(gray4)),
                                        const SizedBox(height: 13.0),
                                        Text('날씨', style: caption2(gray4)),
                                        const SizedBox(height: 13.0),
                                        Text('풍속', style: caption2(gray4)),
                                        const SizedBox(height: 13.0),
                                        Text('풍향', style: caption2(gray4)),
                                        const SizedBox(height: 13.0),
                                        Text('파고', style: caption2(gray4)),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    // const SizedBox(width: 8.0), // 제목과 데이터 간의 간격 추가
                                    const SizedBox(
                                        width: 1,
                                        child: Divider(color: gray1, height: 158, thickness: 300)),
                                    const SizedBox(width: 8.0),
                                    Row(
                                      children: data.entries.map((entry) {
                                        String time =
                                            "${entry.key.substring(8, 10)}:${entry.key.substring(10, 12)}";
                                        Map<String, dynamic> weatherInfo = entry.value;

                                        String direction =
                                            _convertVecToDirection(int.parse(weatherInfo['VEC']));
                                        IconData icon =
                                            _getWeatherIcon(int.parse(weatherInfo['SKY']));

                                        return Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: weatherColumn(
                                            time,
                                            icon,
                                            '${weatherInfo['WSD']}m/s',
                                            direction,
                                            '${weatherInfo['WAV']}m',
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    onTap: () {
                      // Navigator를 통해 다른 페이지로 데이터를 전달하며 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherDetailView(
                              data: data, differenceInMinutes: differenceInMinutes),
                        ),
                      );
                    },
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: weatherData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return const Positioned(
                          left: 65,
                          top: 0,
                          bottom: 0,
                          child: VerticalDivider(
                            indent: 24,
                            color: primaryBlue500,
                            thickness: 2,
                            width: 20,
                          ),
                        );
                      } else {
                        return Container(); // 데이터를 불러오기 전에는 아무것도 그리지 않음
                      }
                    },
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0), // 텍스트 주위의 여백 설정
                    decoration: BoxDecoration(
                      color: primaryBlue500, // 배경 색상
                      borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
                    ),
                    child: Text(
                      '현재 ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white, // 텍스트 색상 설정
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(children: [
                  VerticalOutlinedButton(
                      iconPath: 'assets/icons/buttonIcon_star.svg',
                      text: "즐겨찾기",
                      onPressed: () => {Navigator.pushNamed(context, '/favorites')}),
                  const SizedBox(width: 12),
                  VerticalOutlinedButton(
                      iconPath: 'assets/icons/buttonIcon_note.svg',
                      text: "일지",
                      onPressed: () {
                        Navigator.pushNamed(context, '/journal');
                      }),
                  const SizedBox(width: 12),
                  VerticalOutlinedButton(
                      iconPath: 'assets/icons/buttonIcon_calculate.svg',
                      text: "장부",
                      onPressed: () => {Navigator.pushNamed(context, '/ledger1')}),
                  const SizedBox(width: 12),
                  VerticalOutlinedButton(
                      iconPath: 'assets/icons/buttonIcon_price.svg',
                      text: "시세",
                      onPressed: () => {Navigator.pushNamed(context, '/ledger2')})
                ]),
                const SizedBox(height: 16.0),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/netPage1');
                    },
                    child: writeFishingLogCard()),
              ],
            ),
          ),
        ),
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

  Widget weatherColumn(
      String time, IconData icon, String windSpeed, String direction, String waveHeight) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Text(time),
          const SizedBox(height: 8),
          Icon(icon),
          const SizedBox(height: 8),
          Text(windSpeed),
          const SizedBox(height: 8),
          Text(direction),
          const SizedBox(height: 8),
          Text(waveHeight),
          const Padding(
            padding: EdgeInsets.only(left: 59),
            child: SizedBox(
              width: 1,
              child: Divider(
                color: gray1,
                height: 1,
                thickness: 140,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget writeFishingLogCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Container(
              height: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: primaryBlue500),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset('assets/icons/fishNote.svg'),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("기록하기", style: header1B(Colors.white)),
                          const SizedBox(height: 8),
                          Text("오늘도 만선을 위해\n조업일지를 작성하세요!", style: body3(gray2))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IntrinsicWidth(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: primaryBlue500,
                    width: 2.0,
                  ),
                )),
                padding: const EdgeInsets.only(bottom: 4),
                alignment: Alignment.topLeft,
                child: Text(" 양망대기 ", style: header4(primaryBlue500)),
              ),
            ),
            const Spacer()
          ],
        ),
        const SizedBox(height: 8),
        const NetWaitCard()
      ],
    );
  }
}
