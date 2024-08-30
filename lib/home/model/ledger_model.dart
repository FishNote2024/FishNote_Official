import 'package:flutter/material.dart';

class LedgerModel {
  final DateTime date;
  List<SaleModel> sales = [];
  List<PayModel> pays = [];

  LedgerModel(
      {required this.date, this.sales = const [], this.pays = const []});
}

class SaleModel {
  final String species;
  final double weight;
  final int price;

  SaleModel({required this.species, required this.weight, required this.price});
}

class PayModel {
  final String category;
  final int amount;

  PayModel({required this.category, required this.amount});
}

class LedgerProvider with ChangeNotifier {
  List<LedgerModel> _ledgers = [];
  List<LedgerModel> get ledgers => _ledgers;

  void addLedger(LedgerModel ledger) {
    _ledgers.add(ledger);
    notifyListeners();
  }

  void removeLedger(LedgerModel ledger) {
    _ledgers.remove(ledger);
    notifyListeners();
  }

  void updateLedger(LedgerModel ledger, int index) {
    _ledgers[index] = ledger;
    notifyListeners();
  }
}
