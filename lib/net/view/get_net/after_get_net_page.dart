import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AfterGetNetPage extends StatefulWidget {
  const AfterGetNetPage({super.key});

  @override
  State<AfterGetNetPage> createState() => _AfterGetNetPageState();
}

class _AfterGetNetPageState extends State<AfterGetNetPage> {
  @override
  Widget build(BuildContext context) {
    final records = Provider.of<NetRecordProvider>(context);

    // 어획량이 있는 기록만 필터링
    final filteredRecords = records.netRecords
        .where((record) => record.amount != null && record.amount.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: backgroundBlue,
      body: filteredRecords.isNotEmpty
          ? ListView.builder(
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                NetRecord record = filteredRecords[index];
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
                                style: body1(textBlack),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('위치별명', style: body3(gray5)),
                              SizedBox(width: 16),
                              Text(record.locationName,
                                  style: body1(textBlack)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('어종', style: body3(gray5)),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  record.species.isNotEmpty
                                      ? record.species.join(', ')
                                      : "없음",
                                  style: body1(textBlack),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('어획량', style: body3(gray5)),
                              SizedBox(width: 27),
                              // 어종과 무게를 함께 표시
                              Expanded(
                                child: Text(
                                  record.amount.isNotEmpty
                                      ? record.amount
                                          .map((weight) =>
                                              "${weight.toString()} kg")
                                          .join(', ')
                                      : "없음",
                                  style: body1(textBlack),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('메모', style: body3(gray5)),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  record.memo?.isNotEmpty == true
                                      ? record.memo!
                                      : "없음",
                                  style: body1(textBlack),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 51,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button press
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
    );
  }
}
