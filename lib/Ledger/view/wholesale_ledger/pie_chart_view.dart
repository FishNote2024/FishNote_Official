import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/theme/font.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class PieChartView extends StatefulWidget {
  const PieChartView({super.key, required this.value, required this.ledgers});

  final int value;
  final List<LedgerModel> ledgers;

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  int touchedIndex = 0;
  List<Color> blues = [
    primaryBlue600,
    primaryBlue500,
    primaryBlue400,
    primaryBlue300,
    primaryBlue200
  ];
  List<Color> yellows = [primaryYellow900, primaryYellow800, primaryYellow700, primaryYellow600];

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
    const radius = 120.0;
    List<String> payCategoryList = [];
    List<double> payAmountList = [];
    List<String> saleSpeciesList = [];
    List<double> salePriceList = [];
    int totalPay = 0;
    int totalSale = 0;
    // 데이터를 저장하는 리스트

    for (final ledger in widget.ledgers) {
      totalPay += ledger.totalPays;
      for (final pay in ledger.pays) {
        if (payCategoryList.contains(pay.category)) {
          payAmountList[payCategoryList.indexOf(pay.category)] += pay.amount;
        } else {
          payCategoryList.add(pay.category);
          payAmountList.add(pay.amount.toDouble());
        }
      }
    }

    for (final ledger in widget.ledgers) {
      totalSale += ledger.totalSales;
      for (final sale in ledger.sales) {
        if (saleSpeciesList.contains(sale.species)) {
          salePriceList[saleSpeciesList.indexOf(sale.species)] +=
              (sale.price * sale.weight).round().toDouble();
        } else {
          saleSpeciesList.add(sale.species);
          salePriceList.add((sale.price * sale.weight).round().toDouble());
        }
      }
    }

    // payAmountList, salePriceList를 내림차순으로 정렬, payCategoryList, saleSpeciesList도 동시에 정렬, bubble sort 사용 금지, selection sort 사용 금지, insertion sort 사용 금지
    // for (int i = 0; i < payAmountList.length - 1; i++) {
    //   int maxIndex = i;
    //   for (int j = i + 1; j < payAmountList.length; j++) {
    //     if (payAmountList[j] > payAmountList[maxIndex]) {
    //       maxIndex = j;
    //     }
    //   }
    //   double temp = payAmountList[i];
    //   payAmountList[i] = payAmountList[maxIndex];
    //   payAmountList[maxIndex] = temp;
    //   String temp2 = payCategoryList[i];
    //   payCategoryList[i] = payCategoryList[maxIndex];
    //   payCategoryList[maxIndex] = temp2;
    // }

    final List<ChartData> data = widget.value == 0
        ? List.generate(payCategoryList.length, (index) {
            return ChartData(
              title: payCategoryList[index],
              value: payAmountList[index],
              color: yellows[index],
            );
          })
        : List.generate(saleSpeciesList.length, (index) {
            return ChartData(
              title: saleSpeciesList[index],
              value: salePriceList[index],
              color: blues[index],
            );
          });

    return data.map((ChartData data) {
      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: widget.value == 0
            ? '${data.title}\n${(data.value / totalPay * 100).toStringAsFixed(1)}%'
            : '${data.title}\n${(data.value / totalSale * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: caption1(widget.value == 0 ? gray8 : backgroundWhite),
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
