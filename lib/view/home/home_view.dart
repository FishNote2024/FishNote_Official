import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              iconSize: 51,
              icon: SvgPicture.asset('assets/icons/logo.svg'),
              onPressed: () {
                print("button pressed");
              },
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset('assets/icons/map.svg'),
                onPressed: () {},
              ),
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
                        SizedBox(width: 4.0),
                        Text('서해 바다 50KM', style: body2()),
                      ],
                    ),
                    Text('2024.06.29'),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 40,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/noti.svg'),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '기상특보 6.28 18:00 서해 앞바다 풍랑주의보',
                          style: body3(alertRedDefault),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          weatherColumn(
                              '14:00', Icons.wb_sunny, '1m/s', '→', '0.5m'),
                          weatherColumn(
                              '15:00', Icons.grain, '2m/s', '→', '0.5m'),
                          weatherColumn(
                              '16:00', Icons.cloud, '4m/s', '↗', '0.5m'),
                          weatherColumn(
                              '17:00', Icons.wb_sunny, '6m/s', '↗', '0.5m'),
                          weatherColumn(
                              '18:00', Icons.wb_sunny, '5m/s', '→', '0.5m'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text('통합 해상정보', style: header4(primaryBlue500)),
                        Spacer(),
                        SvgPicture.asset('assets/icons/arrow.svg'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: primaryBlue500),
                      backgroundColor: Colors.white,
                      foregroundColor: primaryBlue500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 180,
                  child: TabBar.secondary(
                    labelColor: primaryBlue500,
                    unselectedLabelColor: gray5,
                    indicatorColor: primaryBlue500,
                    labelStyle: header4(),
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(text: '조업일지'),
                      Tab(text: '조업장부'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      writeFishingLogCard(),
                      fishingLedgerCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                    SizedBox(width: 30),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("조업일지 작성하기", style: header3B(Colors.white)),
                          SizedBox(height: 8),
                          Text("오늘도 만선을 위해\n조업일지를 작성하세요!",
                              style: body3(Colors.white))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget fishingLedgerCard() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('매출 ', style: body3(gray4)),
                Text('15,145,070원', style: header4(primaryBlue300)),
                SizedBox(width: 20),
                Text('지출 ', style: body3(gray4)),
                Text('5,000,000원', style: header4(primaryYellow900)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text('합계 ', style: body3(gray4)),
                Text('10,145,070원', style: header3B(primaryBlue500)),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 1.5),
                        FlSpot(2, 1.4),
                        FlSpot(3, 3.4),
                        FlSpot(4, 2),
                        FlSpot(5, 2.2),
                        FlSpot(6, 1.8),
                      ],
                      isCurved: false,
                      color: primaryBlue500,
                      barWidth: 1,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                child: Text('조업 장부 자세히 보기', style: header4(Colors.white)),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: primaryBlue500),
                  backgroundColor: primaryBlue500,
                  foregroundColor: primaryBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
