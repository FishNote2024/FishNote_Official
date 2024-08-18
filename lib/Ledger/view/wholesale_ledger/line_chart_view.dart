import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/font.dart';

// 현재는 월간 기준입니다.
class LineChartView extends StatefulWidget {
  const LineChartView({super.key});

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
        child: Container(
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
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: bottomTitles)),
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  VerticalLine(x: 0, color: gray1, strokeWidth: 1),
                  VerticalLine(x: 1, color: gray1, strokeWidth: 1),
                  VerticalLine(x: 2, color: gray1, strokeWidth: 1),
                  VerticalLine(x: 3, color: gray1, strokeWidth: 1),
                  VerticalLine(x: 4, color: gray1, strokeWidth: 1),
                  VerticalLine(x: 5, color: gray1, strokeWidth: 1)
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
      ),
    );
  }

  // 주간
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = caption2(gray4);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('5월 4주차', style: style);
        break;
      case 2:
        text = Text('6월 1주차', style: style);
        break;
      case 3:
        text = Text('6월 2주차', style: style);
        break;
      case 4:
        text = Text('6월 3주차', style: style);
        break;
      default:
        text = Text('5월 3주차', style: style);
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
