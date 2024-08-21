import 'package:flutter/material.dart';

/// 각 수입 또는 지출 항목을 나타내는 클래스
class LedgerEntry {
  final String category; // 예: '어종', '구분'
  final String description; // 예: '광어', '값을 입력해주세요'
  final double amount; // 수입/지출 금액 (수입이면 양수, 지출이면 음수)

  LedgerEntry({
    required this.category,
    required this.description,
    required this.amount,
  });
}

/// 날짜별로 수입과 지출을 관리하는 클래스
class DailyLedger {
  final DateTime date; // 날짜
  final List<LedgerEntry> incomes; // 수입 내역
  final List<LedgerEntry> expenses; // 지출 내역

  DailyLedger({
    required this.date,
    this.incomes = const [],
    this.expenses = const [],
  });

  // 총 수입 계산
  double get totalIncome =>
      incomes.fold(0.0, (sum, entry) => sum + entry.amount);

  // 총 지출 계산
  double get totalExpense =>
      expenses.fold(0.0, (sum, entry) => sum + entry.amount);

  // 순이익 계산
  double get netIncome => totalIncome - totalExpense;
}

/// 앱 전체에서 여러 날짜의 장부 데이터를 관리하는 모델
class LedgerModel with ChangeNotifier {
  final Map<DateTime, DailyLedger> _ledgerData = {};

  // 특정 날짜에 대한 장부 데이터를 반환
  DailyLedger getLedger(DateTime date) {
    return _ledgerData.putIfAbsent(
      DateTime(date.year, date.month, date.day),
      () => DailyLedger(date: date),
    );
  }

  // 특정 날짜에 수입을 추가
  void addIncome(DateTime date, LedgerEntry income) {
    final ledger = getLedger(date);
    ledger.incomes.add(income);
    notifyListeners();
  }

  // 특정 날짜에 지출을 추가
  void addExpense(DateTime date, LedgerEntry expense) {
    final ledger = getLedger(date);
    ledger.expenses.add(expense);
    notifyListeners();
  }

  // 특정 날짜의 데이터를 업데이트
  void updateLedger(DateTime date, DailyLedger ledger) {
    _ledgerData[DateTime(date.year, date.month, date.day)] = ledger;
    notifyListeners();
  }

  // 특정 날짜의 데이터를 삭제
  void removeLedger(DateTime date) {
    _ledgerData.remove(DateTime(date.year, date.month, date.day));
    notifyListeners();
  }
}
