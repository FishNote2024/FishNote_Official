import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LedgerModel {
  final DateTime date;
  final List<SaleModel> sales;
  final List<PayModel> pays;
  final int totalSales;
  final int totalPays;

  LedgerModel({
    required this.date,
    required this.totalSales,
    required this.totalPays,
    List<SaleModel>? sales,
    List<PayModel>? pays,
  })  : sales = sales ?? [],
        pays = pays ?? [];
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
  final List<LedgerModel> _ledgers = [];

  List<LedgerModel> get ledgers => _ledgers;

  final db = FirebaseFirestore.instance;

  Future<void> init(String userId) async {
    try {
      // "journal" 컬렉션의 "record" 문서에 접근
      final colRef = db.collection("users").doc(userId).collection("ledger");
      // 각 날짜별로 하위 컬렉션 접근
      final dateSnapshot = await colRef.get();

      if (dateSnapshot.docs.isNotEmpty) {
        for (var dateDoc in dateSnapshot.docs) {
          final data = dateDoc.data();

          // 각 필드에 대해 null 체크 추가하기 (null이면 기본값으로 설정)
          _ledgers.add(
            LedgerModel(
              date: (data['date'] as Timestamp).toDate(),
              totalPays: data['totalPays'] as int,
              totalSales: data['totalSales'] as int,
              sales: (data['sales'] as List<dynamic>).map((item) {
                return SaleModel(
                  species: item['species'] as String,
                  weight: (item['weight'] as num).toDouble(), // double로 변환
                  price: item['price'] as int,
                );
              }).toList(),
              pays: (data['pays'] as List<dynamic>).map((item) {
                return PayModel(
                  category: item['category'] as String,
                  amount: item['amount'] as int,
                );
              }).toList(),
            ),
          );
        }
        notifyListeners();
      } else {
        print('No records found in Firestore');
      }
    } catch (e) {
      print("Error getting records: $e");
    }
  }

  Future<void> _addLedgerToFirestore(LedgerModel record, String userId) async {
    String dateFormatted = DateFormat('yyyy-MM-dd').format(record.date);
    final docRef = db.collection("users").doc(userId).collection("ledger").doc(dateFormatted);

    try {
      await docRef.set({
        'date': record.date,
        'totalSales': record.totalSales,
        'totalPays': record.totalPays,
        'sales': record.sales
            .map((sale) => {
                  'species': sale.species,
                  'weight': sale.weight,
                  'price': sale.price,
                })
            .toList(),
        'pays': record.pays
            .map((pay) => {
                  'category': pay.category,
                  'amount': pay.amount,
                })
            .toList(),
      });

      _ledgers[_ledgers.indexOf(record)] = LedgerModel(
        date: record.date,
        totalSales: record.totalSales,
        totalPays: record.totalPays,
        sales: record.sales,
        pays: record.pays,
      );

      notifyListeners();
    } catch (e) {
      print('Failed to add record to Firestore: $e');
    }
  }

  void addLedger(LedgerModel ledger, String userId) {
    _ledgers.add(ledger);
    _addLedgerToFirestore(ledger, userId);
    notifyListeners();
  }

  void removeLedger(LedgerModel ledger) {
    _ledgers.remove(ledger);
    notifyListeners();
  }

  Future<void> updateLedger(LedgerModel ledger, int index, String userId) async {
    try {
      String dateFormatted = DateFormat('yyyy-MM-dd').format(ledger.date);
      final docRef = db.collection("users").doc(userId).collection("ledger").doc(dateFormatted);

      await docRef.update({
        'totalSales': ledger.totalSales,
        'totalPays': ledger.totalPays,
        'sales': ledger.sales
            .map((sale) => {
                  'species': sale.species,
                  'weight': sale.weight,
                  'price': sale.price,
                })
            .toList(),
        'pays': ledger.pays
            .map((pay) => {
                  'category': pay.category,
                  'amount': pay.amount,
                })
            .toList(),
      });
    } catch (e) {
      print('Failed to update record to Firestore: $e');
    }

    _ledgers[index] = ledger;
    notifyListeners();
  }
}
