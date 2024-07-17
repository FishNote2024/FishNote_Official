import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

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
    _tabController = TabController(length: 2, vsync: this);
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

class MarketPriceTable extends StatelessWidget {
  const MarketPriceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("양양수산업협동조합", style: header3B),
        Text("최근 경락시세", style: header3B),
        SizedBox(height: 40),
        Table(
          border: TableBorder.all(color: Colors.grey),
          children: const [
            TableRow(
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
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('아귀'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('7,666원'),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('청어'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('13,333원'),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('정어리'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('111원'),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('골뱅이'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('180원'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
