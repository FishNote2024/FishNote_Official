import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AfterGetNetPage extends StatefulWidget {
  const AfterGetNetPage({super.key});

  @override
  State<AfterGetNetPage> createState() => _AfterGetNetPageState();
}

class _AfterGetNetPageState extends State<AfterGetNetPage> {
  List<double>? latlon;
  List<NetRecord> netRecords = [
    NetRecord(
        date: DateTime(2024, 8, 25, 6, 0),
        locationName: '문어대가리',
        daysSince: 10,
        species: ['고등어'],
        amount: 10),
    NetRecord(
        date: DateTime(2024, 8, 24, 6, 0),
        locationName: '하얀부표',
        daysSince: 10,
        species: ['갈치', '소라'],
        amount: 30),
    NetRecord(
        date: DateTime(2024, 8, 23, 4, 0),
        locationName: '아왕빡세네',
        daysSince: 10,
        species: ['게', '문어'],
        amount: 21),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<NetRecord> records = getRecordsForDate(today);
    return Scaffold(
      backgroundColor: backgroundBlue,
      body: records.isNotEmpty
          ? ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                NetRecord record = records[index];
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child:
                                Text('양망 완료', style: header4(primaryBlue500)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('양망시간', style: body3(gray5)),
                              SizedBox(width: 16),
                              Text(
                                  '${DateFormat('MM.dd(E) HH시 mm분', 'ko_KR').format(record.date)}',
                                  style: body1(textBlack)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('위치별명', style: body3(gray5)),
                              SizedBox(width: 16),
                              Text('${record.locationName}',
                                  style: body1(textBlack)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('어종', style: body3(gray5)),
                              SizedBox(width: 40),
                              Text(
                                  '${record.species.isNotEmpty ? record.species.join(', ') : '없음'}',
                                  style: body1(textBlack)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('어획량', style: body3(gray5)),
                              SizedBox(width: 27),
                              Text(
                                  '${record.amount.isNaN ? record.amount : "없음"}',
                                  style: body1(textBlack)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 51,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GetNetView(record: record),
                                  ),
                                );
                              },
                              child: Text('양망완료', style: header3B(textBlack)),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: gray2,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: gray2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/ledgerIcon.png', width: 130),
                  SizedBox(height: 8),
                  Text("오늘도 만선하세요!", style: header3R(textBlack))
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: OutlinedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const AddThrowNetPage(),
            //   ),
            // );
          },
          child: Text("기록하기", style: header1B(Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue500,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  List<NetRecord> getRecordsForDate(DateTime date) {
    return netRecords.where((record) {
      return record.date.year == date.year &&
          record.date.month == date.month &&
          record.date.day == date.day;
    }).toList();
  }
}
