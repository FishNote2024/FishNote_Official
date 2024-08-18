import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddLedgerPage extends StatefulWidget {
  final DateTime selectedDate;
  const AddLedgerPage({super.key, required this.selectedDate});

  @override
  State<AddLedgerPage> createState() => _AddLedgerPageState();
}

class _AddLedgerPageState extends State<AddLedgerPage> {
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
    String formattedDate =
        DateFormat.yMMMMd('ko_KR').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        centerTitle: true,
        title: Text(formattedDate, style: body2(textBlack)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: gray7),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "페이지에서 나가시겠습니까?",
                    style: header3B(textBlack),
                  ),
                  content: Text("작성한 내용이 저장되지 않고 사라져요.\n정말 페이지에서 나가시겠습니까?",
                      style: body2(gray6)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("머무르기", style: caption1(primaryBlue500)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("나가기", style: caption1(primaryBlue500)),
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {},
              child: Text("수정완료", style: body2(primaryYellow900)),
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
              Row(
                children: [
                  Text("위판", style: header4(gray8)),
                  Spacer(),
                  OutlinedButton(
                    onPressed: _addRevenueEntry,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('위판 추가하기 ', style: body2(gray4)),
                        Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
                ],
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
          child: Container(
            child: DropdownButton<String>(
              isExpanded: true,
              value: revenueEntries[index]['어종']?.isEmpty ?? true
                  ? null
                  : revenueEntries[index]['어종'],
              hint: Text("어종을 선택해주세요", style: body2(gray4)),
              onChanged: (value) {
                setState(() {
                  revenueEntries[index]['어종'] = value;
                });
              },
              items: <String>['광어', '아귀', '문어'].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: body2(textBlack)),
                  );
                },
              ).toList(),
              underline: SizedBox.shrink(),
            ),
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판량",
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        revenueEntries[index]['위판량'] = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "무게를 입력해주세요",
                      hintStyle: body2(gray4),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Text("kg", style: body2(gray4)),
              ],
            ),
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판 수익",
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        revenueEntries[index]['위판 수익'] = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "수입 금액을 입력해주세요",
                      hintStyle: body2(gray4),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Text("원", style: body2(gray4)),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("삭제"),
                      content: Text("위판을 삭제하시겠습니까?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("취소", style: body2(primaryYellow900)),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteRevenueEntry(index);
                            Navigator.pop(context);
                          },
                          child: Text("삭제", style: body2(primaryYellow900)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.transparent),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('삭제하기 ', style: body2(alertRedBackground)),
                  Icon(Icons.delete_forever_outlined,
                      color: alertRedBackground),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueFormRow(
      {required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                border: Border.all(color: gray4, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
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
              Row(
                children: [
                  Text("지출 내역", style: header4(gray8)),
                  Spacer(),
                  OutlinedButton(
                    onPressed: _addExpenseEntry,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('지출 추가하기 ', style: body2(gray4)),
                        Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
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
          child: Container(
            child: DropdownButton<String>(
              isExpanded: true,
              value: expenseEntries[index]['어종']?.isEmpty ?? true
                  ? null
                  : expenseEntries[index]['어종'],
              hint: Text("지출 구분을 선택해주세요", style: body2(gray4)),
              onChanged: (value) {
                setState(() {
                  expenseEntries[index]['어종'] = value;
                });
              },
              items: <String>['유류비', '인건비', '어구', '기타']
                  .map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: body2(textBlack)),
                  );
                },
              ).toList(),
              underline: SizedBox.shrink(),
            ),
          ),
        ),
        _buildExpenseFormRow(
          index: index,
          label: "비용",
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        expenseEntries[index]['비용'] = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "지출 금액을 입력해주세요",
                      hintStyle: body2(gray4),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Text("원", style: body2(gray4)),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("삭제"),
                      content: Text("지출 내역을 삭제하시겠습니까?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("취소", style: body2(primaryYellow900)),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteRevenueEntry(index);
                            Navigator.pop(context);
                          },
                          child: Text("삭제", style: body2(primaryYellow900)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.transparent),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('삭제하기 ', style: body2(alertRedBackground)),
                  Icon(Icons.delete_forever_outlined,
                      color: alertRedBackground),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseFormRow(
      {required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                border: Border.all(color: gray4, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
