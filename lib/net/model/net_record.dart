import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NetRecord {
  final DateTime throwDate;
  final DateTime getDate;
  final String locationName;
  final int daysSince;
  final String id;
  final Set<String> species;
  final List<double> amount;
  final bool isGet;
  final String? memo;
  final List<double> location; // location을 위도, 경도로 저장
  Map<String, double> fishData;

  NetRecord(
      {required this.throwDate,
      required this.getDate,
      required this.locationName,
      required this.daysSince,
      required this.id,
      required this.isGet,
      required this.location,
      this.species = const {},
      this.amount = const [],
      this.memo,
      this.fishData = const {}});
}

class NetRecordProvider with ChangeNotifier {
  final Uuid uuid = Uuid();
  List<NetRecord> _netRecords = [];
  List<NetRecord> get netRecords => _netRecords;
  List<double> _location = [];
  String _locationName = '';
  DateTime _throwTime = DateTime.now();
  DateTime _getNetTime = DateTime.now();
  String _waveHeight = '';
  final double _waterTemperature = 0.0;
  bool _isGet = false;
  final Set<String> _species = {};
  final List<String> _technique = [];
  List<double> _amount = [];
  int _daysSince = 0;
  String _memo = '';

  String get locationName => _locationName;
  DateTime get throwTime => _throwTime;
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

  final db = FirebaseFirestore.instance;

  Future<void> init(String userId) async {
    final db = FirebaseFirestore.instance;

    try {
      // "journal" 컬렉션의 "record" 문서에 접근
      final journalRef = db
          .collection("users")
          .doc(userId)
          .collection("journal")
          .doc("record");

      // 각 날짜별로 하위 컬렉션 접근
      final datesSnapshot = await journalRef.collection("2024-09-02").get();

      if (datesSnapshot.docs.isNotEmpty) {
        for (var dateDoc in datesSnapshot.docs) {
          final data = dateDoc.data();

          // 각 필드에 대해 null 체크를 추가
          _netRecords.add(
            NetRecord(
              id: data['id'] ?? 0,
              throwDate:
                  (data['throwDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              getDate:
                  (data['getDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              locationName: data['locationName'] ?? '',
              daysSince: data['daysSince'] ?? 0,
              isGet: data['isGet'] ?? false,
              location: List<double>.from(data['location'] ?? [0.0, 0.0]),
              species: Set<String>.from(data['species'] ?? <String>{}),
              amount: List<double>.from(data['amount'] ?? <double>[]),
              memo: data['memo'] ?? '',
              fishData: Map<String, double>.from(
                  data['fishData'] ?? <String, double>{}),
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

  Future<void> _addRecordToFirestore(NetRecord record, String userId) async {
    String throwDateFormatted =
        DateFormat('yyyy-MM-dd').format(record.throwDate);
    final collectionRef = db
        .collection("users")
        .doc(userId)
        .collection("journal")
        .doc("record")
        .collection(throwDateFormatted);

    try {
      DocumentReference docRef = await collectionRef.add({
        'id': record.id,
        'throwDate': record.throwDate,
        'getDate': record.getDate,
        'locationName': record.locationName,
        'daysSince': record.daysSince,
        'isGet': record.isGet,
        'location': record.location,
        'species': record.species.toList(),
        'amount': record.amount,
        'memo': record.memo,
        'fishData': record.fishData,
      });

      _netRecords[_netRecords.indexOf(record)] = NetRecord(
        id: record.id,
        throwDate: record.throwDate,
        getDate: record.getDate,
        locationName: record.locationName,
        daysSince: record.daysSince,
        isGet: record.isGet,
        location: record.location,
        species: record.species,
        amount: record.amount,
        memo: record.memo,
        fishData: record.fishData,
      );

      notifyListeners();
    } catch (e) {
      print('Failed to add record to Firestore: $e');
    }
  }

  void addNewRecord(
    String name,
    List<double> location,
    DateTime throwTime,
    bool isGet, {
    String? memo,
    Set<String>? species,
    DateTime? getNetTime,
    List<double>? amount,
    required String userId,
  }) {
    final newId = uuid.v4();
    final newRecord = NetRecord(
      id: newId,
      throwDate: throwTime,
      location: location,
      getDate: getNetTime ?? DateTime.now(),
      locationName: name,
      daysSince: 0,
      isGet: isGet,
      species: species ?? {},
      amount: amount ?? [],
      memo: memo ?? '',
    );

    // 로컬 상태에 추가
    _netRecords.add(newRecord);
    notifyListeners();

    // Firestore에 추가
    _addRecordToFirestore(newRecord, userId);
  }

  void updateRecord(String id,
      {Set<String>? species,
      List<double>? amount,
      String? memo,
      bool? isGet,
      DateTime? throwTime,
      DateTime? getTime}) {
    print("Updating record $id with throwTime: $throwTime, getTime: $getTime");
    final recordIndex = _netRecords.indexWhere((record) => record.id == id);
    if (recordIndex != -1) {
      final existingRecord = _netRecords[recordIndex];
      _netRecords[recordIndex] = NetRecord(
        id: existingRecord.id,
        locationName: existingRecord.locationName,
        location: existingRecord.location,
        throwDate: throwTime ?? existingRecord.throwDate,
        getDate: getTime ?? existingRecord.getDate,
        daysSince: existingRecord.daysSince,
        isGet: isGet ?? existingRecord.isGet,
        species: species ?? existingRecord.species,
        amount: amount ?? existingRecord.amount,
        memo: memo ?? existingRecord.memo,
      );
      notifyListeners();
    }
  }

  NetRecord? getRecordById(String id) {
    try {
      return _netRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null; // 해당 ID의 기록이 없을 경우 null 반환
    }
  }

  void setDaysSince(DateTime today) {
    final diff = today.difference(_throwTime as DateTime).inDays;
    _daysSince = diff;
    notifyListeners();
  }

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

  void setIsGet(bool bool) {
    _isGet = bool;
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

  void setAmount(List<double> amount) {
    _amount = amount;
    notifyListeners();
  }

  void setMemo(String memo) {
    _memo = memo;
    notifyListeners();
  }
}
