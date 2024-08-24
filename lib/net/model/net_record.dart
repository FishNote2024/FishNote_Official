class NetRecord {
  final DateTime date;
  final String locationName;
  final int daysSince;
  final List<String> species;
  final double amount;

  NetRecord({
    required this.date,
    required this.locationName,
    required this.daysSince,
    this.species = const [],
    this.amount = 0,
  });
}

// 예시 데이터
List<NetRecord> netRecords = [
  NetRecord(
      date: DateTime(2024, 6, 29, 6, 0),
      locationName: '문어대가리',
      daysSince: 10,
      species: ['고등어']),
  NetRecord(
      date: DateTime(2024, 6, 30, 6, 0),
      locationName: '하얀부표',
      daysSince: 10,
      species: ['갈치']),
];
