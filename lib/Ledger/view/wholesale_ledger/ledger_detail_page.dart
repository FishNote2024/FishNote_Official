import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LedgerDetailPage extends StatefulWidget {
  final DateTime selectedDate;
  const LedgerDetailPage({super.key, required this.selectedDate});

  @override
  State<LedgerDetailPage> createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends State<LedgerDetailPage> {
  List<Map<String, dynamic>> revenueEntries = [
    {'어종': '', '위판량': '', '위판 수익': ''}
  ];
  List<Map<String, dynamic>> expenseEntries = [
    {'구분': '', '비용': ''}
  ];

  void _addRevenueEntry() {
    setState(() {
      revenueEntries.add({
        '어종': '',
        '위판량': '',
        '위판 수익': '',
      });
    });
  }

  void _deleteRevenueEntry(int index) {
    setState(() {
      revenueEntries.removeAt(index);
    });
  }

  void _addExpenseEntry() {
    setState(() {
      expenseEntries.add({
        '구분': '',
        '비용': '',
      });
    });
  }

  void _deleteExpenseEntry(int index) {
    setState(() {
      expenseEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM월 dd일').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        centerTitle: true,
        title: Text(formattedDate, style: body2(textBlack)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: gray7),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {},
              child: Text("수정하기", style: body2(primaryBlue500)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [_buildRevenue(), _buildExpense()],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenue() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.0, right: 4, top: 5, bottom: 24),
          child: Row(
            children: [
              Text("매출", style: body1(gray5)),
              const Spacer(),
              Text("0원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: gray1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [Text("위판", style: header4(gray8)), Spacer()],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: revenueEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildRevenueEntryForm(index),
                      if (index != revenueEntries.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Divider(color: gray1),
                        ),
                      Divider(color: gray1),
                      _buildRevenueEntryForm(index),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueEntryForm(int index) {
    return Column(
      children: [
        _buildRevenueFormRow(
          index: index,
          label: "어종",
          child: Container(child: Text("광어")),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판량",
          child: Container(child: Text("10kg")),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판 수익",
          child: Container(child: Text("100,000원")),
        ),
      ],
    );
  }

  Widget _buildRevenueFormRow(
      {required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: EdgeInsets.fromLTRB(0, 6, 10, 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // 지출
  Widget _buildExpense() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.0, right: 4, top: 40, bottom: 24),
          child: Row(
            children: [
              Text("지출", style: body1(gray5)),
              const Spacer(),
              Text("0원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: gray1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("지출 내역", style: header4(gray8)),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: expenseEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildExpenseEntryForm(index),
                      if (index != expenseEntries.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Divider(color: gray1),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseEntryForm(int index) {
    return Column(
      children: [
        _buildExpenseFormRow(
          index: index,
          label: "구분",
          child: Text("연료비"),
        ),
        _buildExpenseFormRow(
          index: index,
          label: "비용",
          child: Container(child: Text("100,000원")),
        ),
      ],
    );
  }

  Widget _buildExpenseFormRow(
      {required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: EdgeInsets.fromLTRB(0, 6, 10, 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
