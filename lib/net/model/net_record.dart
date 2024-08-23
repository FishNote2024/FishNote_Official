class NetRecord {
  final DateTime date;
  final String locationName;
  final int daysSince;

  NetRecord({
    required this.date,
    required this.locationName,
    required this.daysSince,
  });
}

// 예시 데이터
List<NetRecord> netRecords = [
  NetRecord(
      date: DateTime(2024, 6, 29, 6, 0), locationName: '문어대가리', daysSince: 10),
  NetRecord(
      date: DateTime(2024, 6, 29, 6, 0), locationName: '하얀부표', daysSince: 10),
  // 더 많은 데이터 추가 가능
];
