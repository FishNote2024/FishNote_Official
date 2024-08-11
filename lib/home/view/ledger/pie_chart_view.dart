import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartView extends StatefulWidget {
  const PieChartView({super.key});

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
