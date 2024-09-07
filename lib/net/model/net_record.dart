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
  final String? wave;

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
      this.wave,
      this.fishData = const {}});
}

class NetRecordProvider with ChangeNotifier {
  final Uuid uuid = const Uuid();
  final List<NetRecord> _netRecords = [];
  List<NetRecord> get netRecords => _netRecords;
  final List<double> _location = [];
  String _locationName = '';
  DateTime _throwTime = DateTime.now();
  DateTime _getNetTime = DateTime.now();
  final String _waveHeight = '';
  final double _waterTemperature = 0.0;
  bool _isGet = false;
  final Set<String> _species = {};
  final List<String> _technique = [];
  List<double> _amount = [];
  int _daysSince = 0;
  String _memo = '';
  final String _wave = " ";

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
  String get wave => _wave;

  final db = FirebaseFirestore.instance;

  Future<void> init(String userId) async {
    final db = FirebaseFirestore.instance;

    try {
      // "journal" 컬렉션의 모든 문서를 가져옴
      final journalRef =
          db.collection("users").doc(userId).collection("journal");

      // Firestore에서 "journal" 컬렉션의 모든 문서 가져오기
      final querySnapshot = await journalRef.get();

      // 문서가 존재할 경우 처리
      if (querySnapshot.docs.isNotEmpty) {
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();

          // 각 필드에 대해 null 체크 추가하기 (null이면 기본값으로 설정)
          _netRecords.add(
            NetRecord(
              id: docSnapshot.id, // 문서의 ID를 사용
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
              wave: data["wave"] ?? '',
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

  Future<void> _addRecordToFirestore(
      NetRecord record, String userId, String recordId) async {
    final docRef =
        db.collection("users").doc(userId).collection("journal").doc();

    try {
      await docRef.set({
        'id': recordId,
        'throwDate': record.throwDate,
        'getDate': record.getDate,
        'locationName': record.locationName,
        'daysSince': record.daysSince,
        'isGet': record.isGet,
        'location': record.location,
        'species': record.species.toList(),
        'amount': record.amount,
        'memo': record.memo,
        'wave': record.wave,
        'fishData': record.fishData,
      });

      // 로컬 상태 업데이트
      _netRecords[_netRecords.indexOf(record)] = NetRecord(
        id: recordId,
        throwDate: record.throwDate,
        getDate: record.getDate,
        locationName: record.locationName,
        daysSince: record.daysSince,
        isGet: record.isGet,
        location: record.location,
        species: record.species,
        amount: record.amount,
        memo: record.memo,
        wave: record.wave,
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
    String? wave,
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
      wave: wave ?? '',
    );

    // 로컬 상태에 추가
    _netRecords.add(newRecord);
    notifyListeners();

    // Firestore에 추가
    _addRecordToFirestore(newRecord, userId, newId);
  }

  // 기록 업데이트
  Future<void> updateRecord(String id, String userId,
      {Set<String>? species,
      List<double>? amount,
      String? memo,
      bool? isGet,
      String? locationName,
      List<double>? location,
      DateTime? throwTime,
      DateTime? getTime}) async {
    // 로컬 리스트에서 해당 레코드의 인덱스를 찾음
    final recordIndex = _netRecords.indexWhere((record) => record.id == id);
    if (recordIndex != -1) {
      final existingRecord = _netRecords[recordIndex];

      // 로컬 레코드 업데이트
      _netRecords[recordIndex] = NetRecord(
        id: existingRecord.id,
        locationName: locationName ?? existingRecord.locationName,
        location: location ?? existingRecord.location,
        throwDate: throwTime ?? existingRecord.throwDate,
        getDate: getTime ?? existingRecord.getDate,
        daysSince: existingRecord.daysSince,
        isGet: isGet ?? existingRecord.isGet,
        species: species ?? existingRecord.species,
        amount: amount ?? existingRecord.amount,
        memo: memo ?? existingRecord.memo,
        fishData: existingRecord.fishData,
      );
      notifyListeners();

      print("-> id = $id");
      print("-> userId = $userId");

      try {
        // Firestore 문서 참조
        final db = FirebaseFirestore.instance;
        final docRef = db
            .collection("users")
            .doc(userId)
            .collection("journal")
            .doc(id); // 자동 생성된 ID 사용

        // Firestore에서 문서 업데이트
        await docRef.update({
          if (isGet != null) 'isGet': isGet,
          if (species != null && species.isNotEmpty)
            'species': species.toList(),
          if (amount != null && amount.isNotEmpty) 'amount': amount,
          if (memo != null) 'memo': memo,
          if (throwTime != null) 'throwDate': throwTime,
          if (getTime != null) 'getDate': getTime,
          if (locationName != null) 'locationName': locationName,
          if (location != null) 'location': location,
        });

        print("Document path: ${docRef.path}");
        print("--> isGet = $isGet");
        print(
            "throwTime= $throwTime, getTime= $getTime, locationName= $locationName, location= $location");
        print("species=  $species, amount= $amount, memo= $memo");
        print('Record updated in Firestore successfully!');
      } catch (e) {
        print('Failed to update record in Firestore: $e');
      }
    } else {
      print('Record with ID $id not found in local records.');
    }
  }

  // 기록 삭제
  Future<void> deleteRecord(String userId, String recordId) async {
    // 로컬 상태에서 레코드 제거
    removeRecord(recordId);

    // Firestore에서 레코드 제거
    await deleteRecordFromFirestore(userId, recordId);
  }

  void removeRecord(String id) {
    final recordIndex = _netRecords.indexWhere((record) => record.id == id);
    if (recordIndex != -1) {
      _netRecords.removeAt(recordIndex);
      notifyListeners();
    }
  }

  Future<void> deleteRecordFromFirestore(String id, String userId) async {
    // Firestore 인스턴스 초기화
    final db = FirebaseFirestore.instance;

    // 로컬 리스트에서 해당 레코드의 인덱스를 찾음
    final recordIndex = _netRecords.indexWhere((record) => record.id == id);

    if (recordIndex != -1) {
      try {
        // Firestore 문서 참조
        final docRef = db
            .collection("users")
            .doc(userId)
            .collection("journal")
            .doc(id); // 자동 생성된 ID 사용

        // Firestore에서 문서 삭제
        await docRef.delete();

        // 로컬 리스트에서 레코드 삭제
        _netRecords.removeAt(recordIndex);
        notifyListeners();

        print("Document with ID $id deleted successfully from Firestore.");
      } catch (e) {
        print('Failed to delete record from Firestore: $e');
      }
    } else {
      print('Record with ID $id not found in local records.');
    }
  }

  // 삭제 코드 사용 법 : await provider.deleteRecord(userId, recordId);

  NetRecord? getRecordById(String id) {
    try {
      return _netRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null; // 해당 ID의 기록이 없을 경우 null 반환
    }
  }

  void setDaysSince(DateTime today) {
    final diff = today.difference(_throwTime).inDays;
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

  Future<void> withDrawal(String id) async {
    _netRecords.clear();
    final docRef = db.collection("users").doc(id).collection("journal");
    // docRef의 하위 컬렉션 모두 가져오기
    await docRef.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.collection("record").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      }
    });
    notifyListeners();
  }
}
