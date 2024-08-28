import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetRecord {
  final DateTime date;
  final String locationName;
  final int daysSince;
  final Set<String> species;
  final double amount;
  final bool isGet;

  NetRecord({
    required this.date,
    required this.locationName,
    required this.daysSince,
    this.isGet = false,
    this.species = const {},
    this.amount = 0,
    required String memo,
  });
}

class NetRecordProvider with ChangeNotifier {
  List<NetRecord> _netRecords = [];

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
  double _amount = 0.0;
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
  double get amount => _amount;
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

  void setWaveHeight(String waveHeight) {
    _waveHeight = waveHeight;
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

  void setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  void setMemo(String memo) {
    _memo = memo;
    notifyListeners();
  }

  void addNewRecord(String name, List<double> location, DateTime throwTime,
      {String? memo}) {
    _netRecords.add(NetRecord(
      date: throwTime,
      locationName: name,
      daysSince: 0,
      isGet: false,
      species: {},
      amount: 0,
      memo: memo ?? '',
    ));
    notifyListeners();
  }

  void setDaysSince(DateTime today) {
    final diff = today.difference(_getNetTime).inDays;
    _daysSince = diff;
    notifyListeners();
  }
}
