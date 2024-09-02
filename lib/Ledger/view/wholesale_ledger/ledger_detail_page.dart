import 'package:fish_note/Ledger/view/wholesale_ledger/update_ledger.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:intl/intl.dart';

class LedgerDetailPage extends StatefulWidget {
  final DateTime selectedDate;
  const LedgerDetailPage({super.key, required this.selectedDate});

  @override
  State<LedgerDetailPage> createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends State<LedgerDetailPage> {
  @override
  Widget build(BuildContext context) {
    final ledgerProvider = Provider.of<LedgerProvider>(context);
    final LedgerModel? ledger = _getLedgerForDate(widget.selectedDate, ledgerProvider.ledgers);

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
              onPressed: () {
                if (ledger != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateLedgerPage(
                        selectedDate: widget.selectedDate,
                        ledger: ledger,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('해당 날짜에 대한 장부가 없습니다.'),
                    ),
                  );
                }
              },
              child: Text("수정하기", style: body2(primaryBlue500)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildRevenue(ledger?.sales ?? []), // 매출 정보
              _buildExpense(ledger?.pays ?? []), // 지출 정보
            ],
          ),
        ),
      ),
    );
  }

  LedgerModel? _getLedgerForDate(DateTime date, List<LedgerModel> ledgers) {
    try {
      return ledgers.firstWhere(
        (ledger) => ledger.date == date,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildRevenue(List<SaleModel> sales) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5, bottom: 24),
          child: Row(
            children: [
              Text("매출", style: body1(gray5)),
              const Spacer(),
              Text("${NumberFormat("#,###").format(_calculateTotalRevenue(sales))}원",
                  style: header3B(textBlack)),
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
              const SizedBox(height: 8),
              Row(
                children: [Text("위판", style: header4(gray8)), const Spacer()],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildRevenueEntryForm(sales[index]),
                      if (index != sales.length - 1)
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

  Widget _buildRevenueEntryForm(SaleModel sale) {
    return Column(
      children: [
        _buildRevenueFormRow(
          label: "어종",
          child: Container(child: Text(sale.species)),
        ),
        _buildRevenueFormRow(
          label: "위판량",
          child: Container(child: Text("${sale.weight}kg")),
        ),
        _buildRevenueFormRow(
          label: "위판 수익",
          child: Container(child: Text("${NumberFormat("#,###").format(sale.price)}원")),
        ),
      ],
    );
  }

  Widget _buildRevenueFormRow({required String label, required Widget child}) {
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
              padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpense(List<PayModel> pays) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 40, bottom: 24),
          child: Row(
            children: [
              Text("지출", style: body1(gray5)),
              const Spacer(),
              Text("${NumberFormat("#,###").format(_calculateTotalExpense(pays))}원",
                  style: header3B(textBlack)),
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pays.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildExpenseEntryForm(pays[index]),
                      if (index != pays.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
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

  Widget _buildExpenseEntryForm(PayModel pay) {
    return Column(
      children: [
        _buildExpenseFormRow(
          label: "구분",
          child: Text(pay.category),
        ),
        _buildExpenseFormRow(
          label: "비용",
          child: Container(child: Text("${NumberFormat("#,###").format(pay.amount)}원")),
        ),
      ],
    );
  }

  Widget _buildExpenseFormRow({required String label, required Widget child}) {
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
              padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // 총 매출 계산
  int _calculateTotalRevenue(List<SaleModel> sales) {
    return sales.fold(0, (total, sale) => total + (sale.price * sale.weight).round());
  }

  // 총 지출 계산
  int _calculateTotalExpense(List<PayModel> pays) {
    return pays.fold(0, (total, pay) => total + pay.amount);
  }
}
