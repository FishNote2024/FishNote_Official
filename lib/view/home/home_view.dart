import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            iconSize: 51,
            icon: SvgPicture.asset('assets/icons/logo.svg'),
            onPressed: () {
              print("butto pressed");
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
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/location.svg')),
                      SizedBox(width: 4),
                      Text('서해 바다 50KM', style: body2),
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
                        style: body3,
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
              ElevatedButton(
                onPressed: () {},
                child: Text('통합 해상정보'),
                style: ElevatedButton.styleFrom(
                  iconColor: primaryBlue200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: '조업일지'),
                        Tab(text: '조업장부'),
                      ],
                    ),
                    Container(
                      height: 200, // 적절한 높이 설정
                      child: TabBarView(
                        children: [
                          Center(child: writeFishingLogCard()),
                          Center(child: fishingLedgerCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('조업일지 작성하기'),
            SizedBox(height: 8.0),
            Text('오늘도 만선을 위해 조업일지를 작성하세요!'),
          ],
        ),
      ),
    );
  }

  Widget fishingLedgerCard() {
    var data = [
      SalesData('6.12', 1.5),
      SalesData('6.13', 2.5),
      SalesData('6.14', 3.0),
      SalesData('6.15', 2.0),
      SalesData('6.16', 3.5),
      SalesData('6.17', 2.5),
      SalesData('6.18', 2.8),
    ];

    // var series = [
    //   charts.Series(
    //     id: 'Sales',
    //     data: data,
    //     domainFn: (SalesData sales, _) => sales.date,
    //     measureFn: (SalesData sales, _) => sales.sales,
    //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    //   )
    // ];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '매출 ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '15,145,070원',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '지출 ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '5,000,000원',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            Text(
              '합계 ',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              '10,145,070원',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            // Container(
            //   height: 150,
            //   child: charts.LineChart(
            //     series,
            //     animate: true,
            //   ),
            // ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('조업 장부 자세히 보기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String date;
  final double sales;

  SalesData(this.date, this.sales);
}
