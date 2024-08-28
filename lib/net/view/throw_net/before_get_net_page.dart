import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_view.dart';
import 'package:fish_note/net/view/throw_net/add_throw_net_page.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BeforeGetNetPage extends StatefulWidget {
  const BeforeGetNetPage({super.key});

  @override
  State<BeforeGetNetPage> createState() => _BeforeGetNetPageState();
}

class _BeforeGetNetPageState extends State<BeforeGetNetPage> {
  List<double>? latlon;
  List<NetRecord> netRecords = [
    NetRecord(
        date: DateTime(2024, 8, 28, 6, 0),
        locationName: '문어대가리',
        daysSince: 10,
        isGet: false,
        species: {}),
  ];

  Future<void> _navigateToAddThrowNetPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddThrowNetPage(),
      ),
    );

    if (result != null) {
      final String name = result['name'];
      final List<double> location = result['location'];
      final DateTime throwTime = result['throwTime'];

      setState(() {
        netRecords.add(
          NetRecord(
            date: throwTime,
            locationName: name,
            daysSince: 0, // 새로운 기록이므로 0일째로 설정
            isGet: false,
            species: {}, // 빈 종 목록으로 초기화
          ),
        );
      });
    }
  }

  List<NetRecord> getRecordsForDate(bool isGetNet) {
    return netRecords.where((record) {
      return record.isGet == isGetNet;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<NetRecord> records = getRecordsForDate(false);

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
                            child: Text('${record.daysSince}일째 투망 중',
                                style: header4(primaryBlue500)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('투망시간', style: body3(gray5)),
                              const SizedBox(width: 16),
                              Text(
                                  DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                      .format(record.date),
                                  style: body1(textBlack)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('위치별명', style: body3(gray5)),
                              const SizedBox(width: 16),
                              Text(record.locationName,
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
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primaryYellow500,
                                shape: RoundedRectangleBorder(
                                  side:
                                      const BorderSide(color: primaryYellow600),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('양망하기', style: header3B(textBlack)),
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
                  const SizedBox(height: 8),
                  Text("오늘도 만선하세요!", style: header3R(textBlack))
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: OutlinedButton(
          onPressed: _navigateToAddThrowNetPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue500,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("기록하기", style: header1B(Colors.white)),
        ),
      ),
    );
  }
}
