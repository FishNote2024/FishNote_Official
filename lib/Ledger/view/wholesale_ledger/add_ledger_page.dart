import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

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

  void _saveLedger(BuildContext context) {
    final loginModelProvider = Provider.of<LoginModelProvider>(context, listen: false);

    List<SaleModel> sales = revenueEntries.map((entry) {
      return SaleModel(
        species: entry['어종'],
        weight: double.tryParse(entry['위판량']) ?? 0.0,
        price: int.tryParse(entry['위판 수익']) ?? 0,
      );
    }).toList();

    List<PayModel> pays = expenseEntries.map((entry) {
      return PayModel(
        category: entry['구분'],
        amount: int.tryParse(entry['비용']) ?? 0,
      );
    }).toList();

    LedgerModel newLedger = LedgerModel(
      date: widget.selectedDate,
      totalSales: getTotalRevenue(),
      totalPays: getTotalExpense(),
      sales: sales,
      pays: pays,
    );

    Provider.of<LedgerProvider>(context, listen: false)
        .addLedger(newLedger, loginModelProvider.kakaoId);

    // 저장 후 이전 화면으로 이동
    Navigator.pop(context);
  }

  int getTotalRevenue() {
    return revenueEntries.fold(0, (sum, entry) {
      int price = int.tryParse(entry['위판 수익']) ?? 0;
      double weight = double.tryParse(entry['위판량']) ?? 0.0;
      return sum + (price * weight).round();
    });
  }

  int getTotalExpense() {
    return expenseEntries.fold(0, (sum, entry) {
      int price = int.tryParse(entry['비용']) ?? 0;
      return sum + price;
    });
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd('ko_KR').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        centerTitle: true,
        title: Text(formattedDate, style: body2(textBlack)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: gray7),
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // revenueEntries에 ''이 있는 경우 저장하지 않음
                if (revenueEntries.any(
                    (entry) => entry['어종'] == '' || entry['위판량'] == '' || entry['위판 수익'] == '')) {
                  showSnackBar(context, '위판 정보를 모두 입력해주세요');
                  return;
                }
                _saveLedger(context);
              },
              child: Text("저장", style: body2(primaryYellow900)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [_buildRevenue(context), _buildExpense()],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "페이지에서 나가시겠습니까?",
            style: header3B(textBlack),
          ),
          content: Text("작성한 내용이 저장되지 않고 사라집니다.\n정말 페이지에서 나가시겠습니까?", style: body2(gray6)),
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
  }

  Widget _buildRevenue(BuildContext context) {
    int totalRevenue = getTotalRevenue(); // 합계 계산
    String formattedTotalRevenue = formatNumber(totalRevenue); // 합계 형식화

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5, bottom: 24),
          child: Row(
            children: [
              Text("매출", style: body1(gray5)),
              const Spacer(),
              Text("$formattedTotalRevenue원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
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
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _addRevenueEntry,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('위판 추가하기 ', style: body2(gray4)),
                        const Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: revenueEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildRevenueEntryForm(context, index),
                      if (index != revenueEntries.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
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

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제"),
          content: const Text("위판을 삭제하시겠습니까?"),
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
  }

  Widget _buildRevenueFormRow({required String label, required Widget child, required int index}) {
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
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
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
    int totalExpense = getTotalExpense(); // 합계 계산
    String formattedTotalExpense = formatNumber(totalExpense); // 합계 형식화

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 40, bottom: 24),
          child: Row(
            children: [
              Text("지출", style: body1(gray5)),
              const Spacer(),
              Text("$formattedTotalExpense원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
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
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _addExpenseEntry,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('지출 추가하기 ', style: body2(gray4)),
                        const Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenseEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildExpenseEntryForm(index),
                      if (index != expenseEntries.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
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

  Widget _buildRevenueEntryForm(BuildContext context, int index) {
    return Column(
      children: [
        _buildRevenueFormRow(
          index: index,
          label: "어종",
          child: Consumer<NetRecordProvider>(
            builder: (context, netRecordProvider, child) {
              // 선택된 날짜에 해당하는 어종을 가져옴
              List<String> speciesList = netRecordProvider.netRecords
                  .where((record) => record.isGet && isSameDay(record.getDate, widget.selectedDate))
                  .expand((record) => record.species)
                  .toSet()
                  .toList();

              // 어종이 없을 때 userInfoProvider에서 species 가져오기
              if (speciesList.isEmpty) {
                final userInfoProvider =
                    Provider.of<UserInformationProvider>(context, listen: false);
                speciesList = userInfoProvider.species.toList();
              }

              return DropdownButton<String>(
                isExpanded: true,
                value: revenueEntries[index]['어종']?.isEmpty ?? true
                    ? null
                    : revenueEntries[index]['어종'],
                hint: Text("어종을 선택해주세요", style: body2(gray4)),
                onChanged: (value) {
                  if (speciesList.length == 1 && speciesList[0] == '해당 날짜에 양망한 어종이 없어요') {
                    // 어종이 없을 때는 선택하지 않음
                    return;
                  }
                  setState(() {
                    revenueEntries[index]['어종'] = value;
                  });
                },
                items: speciesList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    enabled: !(speciesList.length == 1 && speciesList[0] == '해당 날짜에 양망한 어종이 없어요'),
                    child: Text(value, style: body2(textBlack)), // 비활성화 설정
                  );
                }).toList(),
                underline: const SizedBox.shrink(),
              );
            },
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판량",
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
              const SizedBox(width: 8),
              Text("kg", style: body2(gray4)),
            ],
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판 수익",
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
              const SizedBox(width: 8),
              Text("원", style: body2(gray4)),
            ],
          ),
        ),
        Row(
          children: [
            const Spacer(),
            if (revenueEntries.length > 1) // 리스트 길이가 1 초과인 경우에만 삭제 버튼 표시
              OutlinedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, index);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.transparent),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('삭제하기 ', style: body2(alertRedBackground)),
                    const Icon(Icons.delete_forever_outlined, color: alertRedBackground),
                  ],
                ),
              ),
          ],
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
          child: DropdownButton<String>(
            isExpanded: true,
            value:
                expenseEntries[index]['구분']?.isEmpty ?? true ? null : expenseEntries[index]['구분'],
            hint: Text("지출 구분을 선택해주세요", style: body2(gray4)),
            onChanged: (value) {
              setState(() {
                expenseEntries[index]['구분'] = value;
              });
            },
            items: <String>['유류비', '인건비', '어구', '기타'].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: body2(textBlack)),
                );
              },
            ).toList(),
            underline: const SizedBox.shrink(),
          ),
        ),
        _buildExpenseFormRow(
          index: index,
          label: "비용",
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
              const SizedBox(width: 8),
              Text("원", style: body2(gray4)),
            ],
          ),
        ),
        Row(
          children: [
            const Spacer(),
            if (expenseEntries.length > 1) // 리스트 길이가 1 초과인 경우에만 삭제 버튼 표시
              OutlinedButton(
                onPressed: () {
                  _showDeleteExpenseConfirmationDialog(context, index);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.transparent),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('삭제하기 ', style: body2(alertRedBackground)),
                    const Icon(Icons.delete_forever_outlined, color: alertRedBackground),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showDeleteExpenseConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제"),
          content: const Text("지출 내역을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소", style: body2(primaryYellow900)),
            ),
            TextButton(
              onPressed: () {
                _deleteExpenseEntry(index);
                Navigator.pop(context);
              },
              child: Text("삭제", style: body2(primaryYellow900)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpenseFormRow({required String label, required Widget child, required int index}) {
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
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
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
