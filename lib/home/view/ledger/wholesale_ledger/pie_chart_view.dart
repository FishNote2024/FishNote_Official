import 'package:fish_note/theme/font.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';

class PieChartView extends StatefulWidget {
  const PieChartView({super.key});

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  int touchedIndex = 0;

  // 데이터를 저장하는 리스트
  final List<ChartData> data = [
    ChartData(title: '기타', value: 40, color: primaryYellow100),
    ChartData(title: '항목1', value: 30, color: primaryYellow300),
    ChartData(title: '항목2', value: 16, color: primaryYellow500),
    ChartData(title: '항목3', value: 15, color: primaryYellow700),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final radius = 120.0;

    return data.map((ChartData data) {
      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: '${data.title}\n${data.value}%',
        radius: radius,
        titleStyle: caption1(gray8),
      );
    }).toList();
  }
}

class ChartData {
  final String title;
  final double value;
  final Color color;

  ChartData({
    required this.title,
    required this.value,
    required this.color,
  });
}
