import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/colors.dart';
import '../../../theme/font.dart';

class LineChartView extends StatefulWidget {
  final DateTime time;

  const LineChartView({super.key, required this.time});

  @override
  State<LineChartView> createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 5, 35, 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: gray1)),
        height: 200,
        child: LineChart(
          LineChartData(
            minY: 0, // Y축의 최소값
            maxY: 3.5,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: leftTitles(),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: bottomTitles),
            ),
            extraLinesData: ExtraLinesData(
              verticalLines: [
                VerticalLine(x: 0, color: gray1, strokeWidth: 1),
                VerticalLine(x: 1, color: gray1, strokeWidth: 1),
                VerticalLine(x: 2, color: gray1, strokeWidth: 1),
                VerticalLine(x: 3, color: gray1, strokeWidth: 1),
                VerticalLine(x: 4, color: gray1, strokeWidth: 1),
                VerticalLine(x: 5, color: gray1, strokeWidth: 1),
              ],
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 0),
                  FlSpot(1, 2.4),
                  FlSpot(2, 1),
                  FlSpot(3, 3),
                  FlSpot(4, 2),
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
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = caption2(gray4);
    Widget text;
    DateTime baseDate = widget.time;
    DateFormat dateFormat = DateFormat('MM.dd');

    // 현재 날짜 기준으로 2주 전부터 2주 후까지의 날짜 계산
    switch (value.toInt()) {
      case 0:
        text = Text(dateFormat.format(baseDate.subtract(Duration(days: 14))), style: style);
        break;
      case 1:
        text = Text(dateFormat.format(baseDate.subtract(Duration(days: 7))), style: style);
        break;
      case 2:
        text = Text(dateFormat.format(baseDate), style: style);
        break;
      case 3:
        text = Text(dateFormat.format(baseDate.add(Duration(days: 7))), style: style);
        break;
      default:
        text = Text(dateFormat.format(baseDate.add(Duration(days: 14))), style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: text,
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
    String text;
    switch (value) {
      case 0:
        text = '0.5';
        break;
      case 0.5:
        text = '1';
        break;
      case 1:
        text = '1.5';
        break;
      case 1.5:
        text = '2';
        break;
      case 2:
        text = '2.5';
        break;
      case 2.5:
        text = '3';
        break;
      case 3:
        text = '3.5';
        break;
      default:
        return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(text, style: style, textAlign: TextAlign.end),
    );
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 0.5,
    reservedSize: 30,
  );
}
