import 'dart:ffi';

import 'package:flutter/material.dart';

class NetRecord {
  final DateTime date;
  final String locationName;
  final int daysSince;
  final Set<String> species;
  final double amount;

  NetRecord({
    required this.date,
    required this.locationName,
    required this.daysSince,
    this.species = const {},
    this.amount = 0,
  });
}

// 예시 데이터
List<NetRecord> netRecords = [
  NetRecord(
      date: DateTime(2024, 6, 29, 6, 0),
      locationName: '문어대가리',
      daysSince: 10,
      species: {'고등어'}),
  NetRecord(
      date: DateTime(2024, 6, 30, 6, 0),
      locationName: '하얀부표',
      daysSince: 10,
      species: {'갈치'}),
];

class NetRecordProvider with ChangeNotifier {
  final int _id = 0;
  final Map<String, Object> _location = {
    'latlon': [],
    'name': '',
  };
  String _locationName = '';
  DateTime _throwTime = DateTime.now();
  DateTime _getNetTime = DateTime.now();
  String _waveHeight = '';
  final double _waterTemperature = 0.0;
  final bool _isGet = false;
  final Set<String> _species = {};
  final List<String> _technique = [];
  double _amount = 0.0;
  final int _daysSince = 0;

  String get locationName => _locationName;
  DateTime get throwTime => _throwTime;
  DateTime get getNetTime => _getNetTime;
  String get waveHeight => _waveHeight;
  double get waterTemperature => _waterTemperature;
  bool get isGet => _isGet;
  Set<String> get species => _species;
  List<String> get technique => _technique;
  double get amount => _amount;
  Map<String, Object> get location => _location;
  Map<String, double> fishData = {};

  void addFish(String species, double weight) {
    fishData[species] = weight;
  }

  void setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void setThrowTime(DateTime throwTime) {
    _throwTime = throwTime;
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

  void setLocation(List<double> latlon, String name) {
    _location['latlon'] = latlon;
    _location['name'] = name;
    notifyListeners();
  }
}
