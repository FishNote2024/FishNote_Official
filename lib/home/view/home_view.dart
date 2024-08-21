import 'package:fish_note/home/view/net_wait_card.dart';
import 'package:fish_note/home/view/vertical_outlined_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/weather_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ApiService apiService = ApiService();
    weatherData = apiService.fetchData(nx: 36.190, ny: 129.358);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
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
                  Text(
                      '${currentDate.year}.${currentDate.month}.${currentDate.day}',
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
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: gray2)),
                child: FutureBuilder<Map<String, dynamic>>(
                    future: weatherData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data available'));
                      }

                      Map<String, dynamic> data = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 가로 스크롤
                        child: Row(
                          children: data.entries.map((entry) {
                            String time = entry.key.substring(8, 10) +
                                ":" +
                                entry.key.substring(10, 12);
                            Map<String, dynamic> weatherInfo = entry.value;

                            String direction = _convertVecToDirection(
                                int.parse(weatherInfo['VEC']));
                            IconData icon =
                                _getWeatherIcon(int.parse(weatherInfo['SKY']));

                            return Padding(
                              padding: const EdgeInsets.all(14.0),
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
                      );
                    }),
              ),
              const SizedBox(height: 16.0),
              Row(children: [
                VerticalOutlinedButton(
                    iconPath: 'assets/icons/buttonIcon_star.svg',
                    text: "즐겨찾기",
                    onPressed: () {}),
                SizedBox(width: 12),
                VerticalOutlinedButton(
                    iconPath: 'assets/icons/buttonIcon_note.svg',
                    text: "일지",
                    onPressed: () {}),
                SizedBox(width: 12),
                VerticalOutlinedButton(
                    iconPath: 'assets/icons/buttonIcon_calculate.svg',
                    text: "장부",
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/ledger1')}),
                SizedBox(width: 12),
                VerticalOutlinedButton(
                    iconPath: 'assets/icons/buttonIcon_price.svg',
                    text: "시세",
                    onPressed: () => {Navigator.pushNamed(context, '/ledger2')})
              ]),
              const SizedBox(height: 16.0),
              writeFishingLogCard(),
            ],
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

  Widget weatherColumn(String time, IconData icon, String windSpeed,
      String direction, String waveHeight) {
    return Column(
      children: [
        Text(time),
        Icon(icon),
        Text(windSpeed),
        Text(direction),
        Text(waveHeight),
      ],
    );
  }

  Widget writeFishingLogCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Container(
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primaryBlue500),
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
        SizedBox(height: 16),
        Row(
          children: [
            IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: primaryBlue500,
                    width: 2.0,
                  ),
                )),
                padding: EdgeInsets.only(bottom: 4),
                alignment: Alignment.topLeft,
                child: Text(" 양망대기 ", style: header4(primaryBlue500)),
              ),
            ),
            Spacer()
          ],
        ),
        SizedBox(height: 8),
        NetWaitCard()
      ],
    );
  }

// 나중에 사용될 수 있는 코드입니다.
//   Widget fishingLedgerCard() {
//     return SingleChildScrollView(
//       child: Container(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('매출 ', style: body3(gray4)),
//                 Text('15,145,070원', style: header4(primaryBlue300)),
//                 const SizedBox(width: 20),
//                 Text('지출 ', style: body3(gray4)),
//                 Text('5,000,000원', style: header4(primaryYellow900)),
//               ],
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 Text('합계 ', style: body3(gray4)),
//                 Text('10,145,070원', style: header3B(primaryBlue500)),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             SizedBox(
//               height: 150,
//               child: LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: true),
//                   titlesData: const FlTitlesData(show: false),
//                   borderData: FlBorderData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         const FlSpot(0, 1),
//                         const FlSpot(1, 1.5),
//                         const FlSpot(2, 1.4),
//                         const FlSpot(3, 3.4),
//                         const FlSpot(4, 2),
//                         const FlSpot(5, 2.2),
//                         const FlSpot(6, 1.8),
//                       ],
//                       isCurved: false,
//                       color: primaryBlue500,
//                       barWidth: 1,
//                       isStrokeCapRound: true,
//                       belowBarData: BarAreaData(show: false),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: OutlinedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   side: const BorderSide(color: primaryBlue500),
//                   backgroundColor: primaryBlue500,
//                   foregroundColor: primaryBlue500,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                 ),
//                 child: Text('조업 장부 자세히 보기', style: header4(Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
