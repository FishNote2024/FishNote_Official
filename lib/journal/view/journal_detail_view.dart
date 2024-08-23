import 'package:fish_note/journal/view/journal_edit_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/journal/model/fish_daily.dart';
import 'package:intl/intl.dart';

class JournalDetailView extends StatelessWidget {
  final List<FishDaily> events;

  const JournalDetailView({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming the date is the same for all events, we take the date from the first event
    final DateTime date = events.first.datetime;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                  builder: (context) => JournalEditView(events: events),
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
          final action = event.tooMang ? "투망" : "양망";
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('HH:mm').format(event.datetime) + ' ${action} 기록',
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
                          text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR').format(event.datetime),
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
                          style: body2(gray5), // "투망시간:" 텍스트의 스타일
                        ),
                        TextSpan(
                          text: '위도 ${event.location['lat']} 경도 ${event.location['lng']}',
                          style: body2(black), // 날짜 부분의 스타일
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
                          style: body2(gray5), // "투망시간:" 텍스트의 스타일
                        ),
                        TextSpan(
                          text: '${event.wav}',
                          style: body2(black), // 날짜 부분의 스타일
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
