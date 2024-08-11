import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/font.dart';

class LineChartView extends StatefulWidget {
  const LineChartView({super.key});

  @override
  State<LineChartView> createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 37),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: gray1)),
      height: 200,
      child: Container(
        child: LineChart(
          LineChartData(
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
                  FlSpot(0, 1),
                  FlSpot(1, 5),
                  FlSpot(2, 2),
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

  // 주간
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = caption2(gray4);
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text('SEPT', style: style);
        break;
      case 7:
        text = Text('OCT', style: style);
        break;
      case 12:
        text = Text('DEC', style: style);
        break;
      default:
        text = Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
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
    switch (value.toInt()) {
      case 1:
        text = '0.5';
        break;
      case 2:
        text = '1';
        break;
      case 3:
        text = '1.5';
        break;
      case 4:
        text = '2';
        break;
      case 5:
        text = '2.5';
      case 6:
        text = '3';
      case 7:
        text = '3.5';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 30,
      );
}
