import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/colors.dart';
import '../../../theme/font.dart';

class LineChartView extends StatefulWidget {
  const LineChartView({super.key, required this.time, required this.ledgers, required this.value});

  final DateTime time;
  final List<LedgerModel> ledgers;
  final int value;

  @override
  State<LineChartView> createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  int weekOfYear(DateTime date) {
    // 해당 연도의 첫 날과 첫 번째 토요일 찾기
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    DateTime firstSaturday = firstDayOfYear;

    // 첫 번째 토요일을 찾기 위해 해당 연도 첫 날부터 토요일을 찾음
    while (firstSaturday.weekday != DateTime.saturday) {
      firstSaturday = firstSaturday.add(const Duration(days: 1));
    }

    // 주어진 날짜와 첫 번째 토요일 사이의 일 수 차이를 계산
    int daysSinceFirstSaturday = date.difference(firstSaturday).inDays;

    // 주 번호를 계산
    int weekNumber = (daysSinceFirstSaturday / 7).ceil() + 1;

    // 첫 번째 주에 포함되지 않는 날짜에 대해 주 번호 조정
    if (weekNumber <= 0) {
      weekNumber = weekOfYear(DateTime(date.year - 1, 12, 31));
    }

    return weekNumber;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> values = widget.value == 0
        ? // widget.ledgers의 weekOfYear(time) ~ weekOfYear(time)-5 기간 동안의 weekOfYear(widget.ledgers.date)가 같은 것들의 totalSales의 합계 리스트, weekOfYear(time) ~ weekOfYear(time)-5 기간 중 값이 없는 경우 0으로 처리, reverse로 정렬
        List.generate(5, (index) {
            int week = weekOfYear(widget.time) - 4 + index;
            return widget.ledgers
                    .where((ledger) => weekOfYear(ledger.date) == week)
                    .fold<int>(0, (previousValue, element) => previousValue + element.totalSales) /
                1000000;
          })
        : // widget.ledgers의 같은 weekOfYear(time) 각 items의 totalSales 리스트, 값이 없는 경우 0으로 처리
        List.generate(7, (index) {
            DateTime date = widget.time.subtract(Duration(days: 6 - index));
            return widget.ledgers
                    .where((ledger) => ledger.date.day == date.day)
                    .fold<int>(0, (previousValue, element) => previousValue + element.totalSales) /
                1000000;
          });

    final maxY = values.reduce((value, element) => value > element ? value : element) + 0.3;

    return SizedBox(
      height: 250,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 5, 35, 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: gray1)),
        height: 200,
        child: LineChart(
          LineChartData(
            minX: 0, // X축의 최소값
            maxX: values.length.toDouble() - 1, // Y축의 최소값
            minY: 0, // Y축의 최소값
            maxY: maxY,
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: leftTitles(maxY),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: bottomTitles),
            ),
            extraLinesData: ExtraLinesData(
              extraLinesOnTop: false,
              verticalLines: List.generate(values.length, (index) {
                return VerticalLine(
                  x: index.toDouble(),
                  color: gray1,
                  strokeWidth: 1,
                );
              }),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(values.length, (index) {
                  return FlSpot(index.toDouble(), values[index]);
                }),
                color: primaryBlue500,
                barWidth: 1,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = caption2(gray4);
    String text;
    DateTime baseDate = widget.time;
    DateFormat dateFormat = DateFormat('MM.dd');

    int daysOffset;
    if (widget.value == 0) {
      // 주간 차트를 위한 daysOffset 설정
      daysOffset = 7 * (4 - value.toInt());
      // daysOffset을 사용하여 계산된 날짜로 텍스트 설정
      text = '~${dateFormat.format(baseDate.subtract(Duration(days: daysOffset)))}';
    } else {
      // 일간 차트를 위한 daysOffset 설정
      daysOffset = 6 - value.toInt();
      text = dateFormat.format(baseDate.subtract(Duration(days: daysOffset)));
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: Text(text, style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = caption2(gray4);
    String? text;

    // 0에서 10까지 0.5 간격으로 값을 반복
    for (double i = 0; i <= 100; i += 0.5) {
      if (value % 1 == 0) {
        text = value.toInt().toString();
      } else if (value == i) {
        text = value.toString();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(text ?? '', style: style, textAlign: TextAlign.end),
    );
  }

  SideTitles leftTitles(double maxY) => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: calculateInterval(maxY),
        reservedSize: 32,
      );

  // interval 계산 함수
  double calculateInterval(double maxY) {
    if (maxY <= 1) {
      return 0.1; // maxY가 작을 때는 0.1 단위로 설정
    } else if (maxY <= 5) {
      return 0.5; // maxY가 5 이하일 때는 0.5 단위
    } else if (maxY <= 10) {
      return 1; // maxY가 10 이하일 때는 1 단위
    } else if (maxY <= 50) {
      return 5; // maxY가 50 이하일 때는 5 단위
    } else if (maxY <= 100) {
      return 10; // maxY가 클 경우 10 단위
    } else {
      return 50; // maxY가 100 이상일 경우 50 단위
    }
  }
}
