import 'package:dio/dio.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:xml/xml.dart' as xml;

class LedgerPage extends StatefulWidget {
  final int initialTabIndex;
  const LedgerPage({super.key, required this.initialTabIndex});

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _dropdownValue = '월간';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조업 장부'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '위판장부'),
            Tab(text: '경락시세'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: _dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                      });
                    },
                    items: <String>['월간', '주간']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '30,245,070원',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '매출 50,245,070원',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        '지출 20,000,000원',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        '합계 30,245,070원',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text('매출 추이'),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
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
                            isCurved: true,
                            // backg: [Colors.blue],
                            color: Colors.red,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('매출 통계'),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.orange,
                            value: 44,
                            title: '유류비 44%',
                          ),
                          PieChartSectionData(
                            color: Colors.yellow,
                            value: 30,
                            title: '인건비 30%',
                          ),
                          PieChartSectionData(
                            color: Colors.amber,
                            value: 19,
                            title: '어구 19%',
                          ),
                          PieChartSectionData(
                            color: Colors.brown,
                            value: 7,
                            title: '기타 7%',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Center(child: MarketPriceTable()),
          ],
        ),
      ),
    );
  }
}

class MarketPriceTable extends StatefulWidget {
  const MarketPriceTable({Key? key}) : super(key: key);

  @override
  _MarketPriceTableState createState() => _MarketPriceTableState();
}

class _MarketPriceTableState extends State<MarketPriceTable> {
  final Dio dio = Dio();
  final String apiUrl =
      'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  final String apiKey =
      'P9snIt2gDleusE4uaQ9a1Tyx6/QaQRBJjRzr9H4ELGzbp263NM0Fvprpu1mr6Qqu6Efxqu35tgxg0JeKZtRnHA==';
  String baseDt = '20240816';

  // 등록된 어종 목록
  final List<String> registeredSpecies = ['문어', '전복', '방어', '소라'];
  // 등록된 조합명
  final String mxtrNm = '거제수산업협동조합';

  Map<String, Map<String, dynamic>> groupedData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // 기존 데이터 제거
      groupedData.clear();

      // String requestUrl =
      //     '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&fromDt=$baseDt&toDt=$baseDt&type=xml';
      // String requestUrl =
      //     '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=%EA%B1%B0%EC%A0%9C%EC%88%98%EC%82%B0%EC%97%85%ED%98%91%EB%8F%99%EC%A1%B0%ED%95%A9&fshrNm=%EB%82%98%EC%9E%A0%EC%96%B4%EC%97%85&fromDt=$baseDt&toDt=$baseDt&type=xml';
      String requestUrl =
          '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=$mxtrNm&fromDt=$baseDt&toDt=$baseDt&type=xml';
      var response = await dio.get(requestUrl);
      if (response.statusCode == 200) {
        var document = xml.XmlDocument.parse(response.data);
        final items = document.findAllElements('item');

        // 어종(mprcStdCodeNm)을 기준으로 그룹화 및 평균 계산
        for (var item in items) {
          String mprcStdCodeNm = item.findElements('mprcStdCodeNm').single.text;

          // 등록된 어종만 필터링
          if (registeredSpecies.contains(mprcStdCodeNm)) {
            double csmtUntpc =
                double.parse(item.findElements('csmtUntpc').single.text);

            if (groupedData.containsKey(mprcStdCodeNm)) {
              groupedData[mprcStdCodeNm]!['totalUntpc'] += csmtUntpc;
              groupedData[mprcStdCodeNm]!['count'] += 1;
            } else {
              groupedData[mprcStdCodeNm] = {
                'mprcStdCodeNm': mprcStdCodeNm,
                'totalUntpc': csmtUntpc,
                'count': 1,
              };
            }
          }
        }

        setState(() {}); // 상태 갱신
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mxtrNm,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("최근 경락시세",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Table(
              border: TableBorder.all(color: Colors.grey),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '주요 어종',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '최근 시세 (1kg당)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...groupedData.entries.map((entry) {
                  final avgUntpc =
                      (entry.value['totalUntpc'] / entry.value['count'])
                          .toStringAsFixed(2);
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(entry.value['mprcStdCodeNm']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$avgUntpc원'),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
