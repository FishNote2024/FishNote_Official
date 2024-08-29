import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetRecord {
  final DateTime date;
  final String locationName;
  final int daysSince;
  final int id;
  final Set<String> species;
  final List<double> amount;
  final bool isGet;
  final String? memo;
  Map<String, double> fishData;

  NetRecord(
      {required this.date,
      required this.locationName,
      required this.daysSince,
      required this.id,
      required this.isGet,
      this.species = const {},
      this.amount = const [],
      this.memo,
      this.fishData = const {}});

  // get memo => null;
}

class NetRecordProvider with ChangeNotifier {
  List<NetRecord> _netRecords = [];
  int _nextId = 1; // 다음에 사용할 ID 값
  List<NetRecord> get netRecords => _netRecords;

  final int _id = 0;
  List<double> _location = [];
  String _locationName = '';
  String _throwTime = '';
  DateTime _getNetTime = DateTime.now();
  String _waveHeight = '';
  final double _waterTemperature = 0.0;
  final bool _isGet = false;
  final Set<String> _species = {};
  final List<String> _technique = [];
  List<double> _amount = [];
  int _daysSince = 0;
  String _memo = '';

  String get locationName => _locationName;
  String get throwTime => _throwTime;
  DateTime get getNetTime => _getNetTime;
  String get waveHeight => _waveHeight;
  double get waterTemperature => _waterTemperature;
  bool get isGet => _isGet;
  Set<String> get species => _species;
  List<String> get technique => _technique;
  List<double> get amount => _amount;
  List<double> get location => _location;
  Map<String, double> fishData = {};
  String get memo => _memo;

  void addFish(String species, double weight) {
    fishData[species] = weight;
  }

  void setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void setThrowTime(DateTime throwTime) {
    _throwTime = DateFormat('MM.dd(E) HH시 mm분', 'ko_KR').format(throwTime);
    notifyListeners();
  }

  void setGetNetTime(DateTime getNetTime) {
    _getNetTime = getNetTime;
    notifyListeners();
  }

  void setSpecies(Set<String> species) {
    _species.addAll(species);
    notifyListeners();
  }

  void setTechnique(List<String> technique) {
    _technique.addAll(technique);
    notifyListeners();
  }

  void setAmount(List<double> amount) {
    _amount = amount;
    notifyListeners();
  }

  void setMemo(String memo) {
    _memo = memo;
    notifyListeners();
  }

  void addNewRecord(
      String name, List<double> location, DateTime throwTime, bool isGet,
      {String? memo, Set<String>? species, List<double>? amount}) {
    _netRecords.add(NetRecord(
      id: _nextId++,
      date: throwTime,
      locationName: name,
      daysSince: 0,
      isGet: isGet,
      species: species ?? {},
      amount: amount ?? [],
      memo: memo ?? '',
    ));
    notifyListeners();
  }

  void updateRecord(int id,
      {Set<String>? species, List<double>? amount, String? memo}) {
    final recordIndex = _netRecords.indexWhere((record) => record.id == id);
    if (recordIndex != -1) {
      final existingRecord = _netRecords[recordIndex];
      _netRecords[recordIndex] = NetRecord(
        id: existingRecord.id,
        date: existingRecord.date,
        locationName: existingRecord.locationName,
        daysSince: existingRecord.daysSince,
        isGet: existingRecord.isGet,
        species: species ?? existingRecord.species,
        amount: amount ?? existingRecord.amount,
        memo: memo ?? existingRecord.memo,
      );
      notifyListeners();
    }
  }

  NetRecord? getRecordById(int id) {
    try {
      return _netRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null; // 해당 ID의 기록이 없을 경우 null 반환
    }
  }

  void setDaysSince(DateTime today) {
    final diff = today.difference(_getNetTime).inDays;
    _daysSince = diff;
    notifyListeners();
  }
}
