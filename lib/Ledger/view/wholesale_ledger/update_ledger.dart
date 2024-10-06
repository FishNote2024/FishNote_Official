import 'package:fish_note/favorites/components/alert_dialog.dart';
import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateLedgerPage extends StatefulWidget {
  final DateTime selectedDate;
  final LedgerModel ledger;

  const UpdateLedgerPage({
    super.key,
    required this.selectedDate,
    required this.ledger,
  });

  @override
  _UpdateLedgerPageState createState() => _UpdateLedgerPageState();
}

class _UpdateLedgerPageState extends State<UpdateLedgerPage> {
  late List<Map<String, dynamic>> revenueEntries;
  late List<Map<String, dynamic>> expenseEntries;
  late List<TextEditingController> revenueWeightControllers;
  late List<TextEditingController> revenuePriceControllers;
  late List<TextEditingController> expenseControllers;
  Set<String> registeredSpecies = {};

  @override
  void initState() {
    super.initState();
    final userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    registeredSpecies = userInformationProvider.species;
    // Initialize the revenue and expense entries based on the ledger passed
    revenueEntries = widget.ledger.sales.map((sale) {
      return {
        '어종': sale.species,
        '위판량': sale.weight.toString(),
        '단위': sale.unit,
        '위판단가': sale.price.toString(),
      };
    }).toList();

    expenseEntries = widget.ledger.pays.map((pay) {
      return {
        '구분': pay.category,
        '비용': pay.amount.toString(),
      };
    }).toList();

    // Initialize controllers
    revenueWeightControllers = List.generate(
      revenueEntries.length,
      (index) => TextEditingController(text: revenueEntries[index]['위판량']),
    );
    revenuePriceControllers = List.generate(
      revenueEntries.length,
      (index) => TextEditingController(text: revenueEntries[index]['위판단가']),
    );
    expenseControllers = List.generate(
      expenseEntries.length,
      (index) => TextEditingController(text: expenseEntries[index]['비용']),
    );

    if (revenueEntries.isEmpty) {
      revenueEntries.add({'어종': '', '위판량': '', '단위': 'KG', '위판단가': ''} as Map<String, dynamic>);
      revenueWeightControllers.add(TextEditingController());
      revenuePriceControllers.add(TextEditingController());
    }

    if (expenseEntries.isEmpty) {
      expenseEntries.add({'구분': '', '비용': ''} as Map<String, dynamic>);
      expenseControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    for (var controller in revenueWeightControllers) {
      controller.dispose();
    }
    for (var controller in revenuePriceControllers) {
      controller.dispose();
    }
    for (var controller in expenseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateLedger(BuildContext context) {
    final loginModelProvider = Provider.of<LoginModelProvider>(context, listen: false);

    // Create updated sales and pays lists from the form entries
    List<SaleModel> updatedSales = revenueEntries.map((entry) {
      return SaleModel(
        species: entry['어종'],
        weight: double.tryParse(entry['위판량']) ?? 0.0,
        unit: entry['단위'],
        price: int.tryParse(entry['위판단가']) ?? 0,
      );
    }).toList();

    List<PayModel> updatedPays = expenseEntries.map((entry) {
      return PayModel(
        category: entry['구분'],
        amount: int.tryParse(entry['비용']) ?? 0,
      );
    }).toList();

    // Update the existing ledger with new sales and pays
    final updatedLedger = LedgerModel(
      date: widget.selectedDate,
      totalSales: getTotalRevenue(),
      totalPays: getTotalExpense(),
      sales: updatedSales,
      pays: updatedPays,
    );

    // Notify the provider that the ledger has been updated
    final provider = Provider.of<LedgerProvider>(context, listen: false);
    final ledgerIndex = provider.ledgers.indexWhere((ledger) => ledger.date == widget.selectedDate);

    if (ledgerIndex != -1) {
      provider.updateLedger(updatedLedger, ledgerIndex, loginModelProvider.kakaoId);
    }

    // Navigate back after saving
    Navigator.pop(context);
  }

  int getTotalRevenue() {
    return revenueEntries.fold(0, (sum, entry) {
      int price = int.tryParse(entry['위판단가']) ?? 0;
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        showDialog(context: context, builder: (context) => buildOutDialog(context));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundBlue,
          centerTitle: true,
          title: Text(formattedDate, style: body2(textBlack)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: gray7),
              onPressed: () {
                showDialog(context: context, builder: (context) => buildOutDialog(context));
              }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  if (revenueEntries.length == 1 &&
                      expenseEntries.length == 1 &&
                      revenueEntries[0]['어종'] == '' &&
                      revenueEntries[0]['위판량'] == '' &&
                      revenueEntries[0]['위판단가'] == '' &&
                      expenseEntries[0]['구분'] == '' &&
                      expenseEntries[0]['비용'] == '') {
                    showSnackBar(context, '위판 정보나 지출 정보를 입력해주세요');
                    return;
                  }

// 위판 정보가 입력되지 않은 경우
                  if (revenueEntries.isNotEmpty &&
                      revenueEntries.any((entry) =>
                          entry['어종'] == '' || entry['위판량'] == '' || entry['위판단가'] == '')) {
                    showSnackBar(context, '위판 정보를 모두 입력해주세요');
                    return;
                  } else if (expenseEntries.length == 1 &&
                      expenseEntries[0]['구분'] == '' &&
                      expenseEntries[0]['비용'] == '') {
                    expenseEntries.removeAt(0);
                  }

// 지출 정보가 입력되지 않은 경우
                  if (expenseEntries.isNotEmpty &&
                      expenseEntries.any((entry) => entry['구분'] == '' || entry['비용'] == '')) {
                    showSnackBar(context, '지출 정보를 모두 입력해주세요');
                    return;
                  } else if (revenueEntries.length == 1 &&
                      revenueEntries[0]['어종'] == '' &&
                      revenueEntries[0]['위판량'] == '' &&
                      revenueEntries[0]['위판단가'] == '') {
                    revenueEntries.removeAt(0);
                  }

// 조건을 만족하는 경우에만 삭제

                  _updateLedger(context);
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
              children: [_buildRevenue(), _buildExpense()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenue() {
    int totalRevenue = getTotalRevenue();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5, bottom: 24),
          child: Row(
            children: [
              Text("매출", style: body1(gray5)),
              const Spacer(),
              Text("${formatNumber(totalRevenue)}원", style: header3B(textBlack)),
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

  Widget _buildRevenueEntryForm(BuildContext context, int index) {
    return Column(
      children: [
        _buildRevenueFormRow(
          index: index,
          label: "어종",
          child: DropdownButton<String>(
            isExpanded: true,
            value: revenueEntries[index]['어종'].isEmpty ? null : revenueEntries[index]['어종'],
            hint: Text("어종을 선택해주세요", style: body2(gray4)),
            onChanged: (value) {
              setState(() {
                revenueEntries[index]['어종'] = value;
              });
            },
            items: registeredSpecies.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: body2(textBlack)), // 비활성화 설정
              );
            }).toList(),
            underline: const SizedBox.shrink(),
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
                    hintText: "무게/개수를 입력해주세요",
                    hintStyle: body2(gray4),
                  ),
                  keyboardType: TextInputType.number,
                  controller: revenueWeightControllers[index],
                ),
              ),
            ],
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "단위",
          child: DropdownButton<String>(
            isExpanded: true,
            value:
                revenueEntries[index]['단위']?.isEmpty ?? true ? null : revenueEntries[index]['단위'],
            hint: Text("단위를 선택해주세요", style: body2(gray4)),
            onChanged: (value) {
              setState(() {
                revenueEntries[index]['단위'] = value;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'KG',
                child: Text('KG', style: body2(textBlack)), // 비활성화 설정
              ),
              DropdownMenuItem<String>(
                value: '상자(C/S)',
                child: Text('상자(C/S)', style: body2(textBlack)), // 비활성화 설정
              )
            ],
            underline: const SizedBox.shrink(),
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판단가",
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      revenueEntries[index]['위판단가'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "단가 금액을 입력해주세요",
                    hintStyle: body2(gray4),
                  ),
                  keyboardType: TextInputType.number,
                  controller: revenuePriceControllers[index],
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
    int totalExpense = getTotalExpense();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 40, bottom: 24),
          child: Row(
            children: [
              Text("지출", style: body1(gray5)),
              const Spacer(),
              Text("${formatNumber(totalExpense)}원", style: header3B(textBlack)),
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
        const SizedBox(
          height: 30,
        )
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
                  controller: expenseControllers[index],
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

  void _addRevenueEntry() {
    setState(() {
      revenueEntries.add({
        '어종': '',
        '위판량': '',
        '단위': 'KG',
        '위판단가': '',
      } as Map<String, dynamic>);

      revenueWeightControllers.add(TextEditingController());
      revenuePriceControllers.add(TextEditingController());
    });
  }

  void _deleteRevenueEntry(int index) {
    revenueWeightControllers[index].dispose();
    revenuePriceControllers[index].dispose();

    setState(() {
      revenueEntries.removeAt(index);
      revenueWeightControllers.removeAt(index);
      revenuePriceControllers.removeAt(index);
    });
  }

  void _addExpenseEntry() {
    setState(() {
      expenseEntries.add({
        '구분': '',
        '비용': '',
      } as Map<String, dynamic>);
    });

    expenseControllers.add(TextEditingController());
  }

  void _deleteExpenseEntry(int index) {
    expenseControllers[index].dispose();

    setState(() {
      expenseEntries.removeAt(index);
      expenseControllers.removeAt(index);
    });
  }
}
