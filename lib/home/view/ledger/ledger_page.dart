import 'package:fish_note/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../theme/font.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.week,
            locale: 'ko_KR',
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMMd(locale).format(date),
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
              leftChevronIcon: const Icon(
                Icons.arrow_back_ios,
                size: 15.0,
              ),
              rightChevronIcon: const Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '매출 50,245,070원dd',
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
    );
  }
}
