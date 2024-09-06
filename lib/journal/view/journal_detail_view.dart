import 'package:fish_note/journal/view/journal_edit_view.dart';
import 'package:fish_note/journal/view/journal_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/net/model/net_record.dart'; // NetRecord를 가져옴
import 'package:intl/intl.dart';

class JournalDetailView extends StatelessWidget {
  final List<NetRecord> events;

  const JournalDetailView({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/journal'); // 또는 다른 라우트로 이동
      });
    }
    final DateTime date = events.first.throwDate; // NetRecord의 throwDate 사용

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JournalView(),
              ),
            );
          },
        ),
        title: Text(DateFormat('MM.dd (E)', 'ko_KR').format(date)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEditView(
                      recordId: events.first.id, events: events),
                ),
              );
            },
            child: Text(
              '수정하기',
              style: body2(primaryBlue500),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final action = "투망"; // 투망(throw)을 표시
          final locationName = event.locationName;

          if (!event.isGet) {
            print(event.wave);
            // isGet이 true일 때 반환할 Card
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(event.throwDate) +
                          ' ${locationName}', // throwDate 사용
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${action}시간: ',
                            style: body2(gray5), // "투망시간:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                .format(event.throwDate), // throwDate 사용
                            style: body2(black), // 날짜 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${action}위치: ',
                            style: body2(gray5), // "투망위치:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text:
                                '위도 ${event.location[0]} 경도 ${event.location[1]}', // 위치 정보 사용
                            style: body2(black), // 위치 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5),
                    Text(
                      '해상 기록',
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16.5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '파고: ',
                            style: body2(gray5), // "파고:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text: '${event.wave}m', // 파고 정보 사용
                            style: body2(black), // 파고 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // isGet이 false일 때 반환할 Card
            return Card(
              color: Colors.white, // 다른 카드와 구분을 위해 약간의 배경색을 추가
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(event.throwDate) +
                          ' ${locationName}', // throwDate 사용
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${action}시간: ',
                            style: body2(gray5), // "투망시간:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                .format(event.throwDate), // throwDate 사용
                            style: body2(black), // 날짜 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${action}위치: ',
                            style: body2(gray5), // "투망위치:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text:
                                '위도 ${event.location[0]} 경도 ${event.location[1]}', // 위치 정보 사용
                            style: body2(black), // 위치 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5),
                    Text(
                      '해상기록',
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16.5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '파고: ',
                            style: body2(gray5), // "파고:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text: '${event.wave}', // 파고 정보 사용
                            style: body2(black), // 파고 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5),
                    Text(
                      '양망기록',
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16.5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '양망시간: ',
                            style: body2(gray5), // "파고:" 텍스트의 스타일
                          ),
                          TextSpan(
                            text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                .format(event.getDate), // throwDate 사용
                            style: body2(black), // 날짜 부분의 스타일
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5),
                    Text(
                      '어획',
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16.5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(event.species.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // 간격 조정
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '어종             ',
                                      style: body2(gray5),
                                    ),
                                    TextSpan(
                                      text:
                                          '${event.species.elementAt(index)}\n', // species의 인덱스에 해당하는 값 가져오기
                                      style: body2(black),
                                    ),
                                    TextSpan(
                                      text: '어획량         ',
                                      style: body2(gray5),
                                    ),
                                    TextSpan(
                                      text:
                                          '${event.amount[index]} kg', // amount의 인덱스에 해당하는 값 가져오기
                                      style: body2(black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Divider(), // 항목들 사이에 구분선을 추가
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.5),
                    Text(
                      '메모',
                      style: header3B(gray8),
                    ),
                    SizedBox(height: 16.5),
                    Container(
                      padding: EdgeInsets.all(8.0), // 내부 여백을 추가
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // 회색 테두리 추가
                        borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게
                      ),
                      constraints: const BoxConstraints(
                        minWidth: double.infinity, // 가로로 꽉 차도록 설정 (필요에 따라 사용)
                        minHeight: 100.0, // 최소 높이를 100으로 설정
                      ),
                      child: Text(
                        event.memo ?? "",
                        style: body2(black), // 원하는 텍스트 스타일
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
