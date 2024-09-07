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
    // 데이터가 비어 있을 때 자동으로 돌아가기
    if (events.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, ModalRoute.withName('/journal'));
      });
    }

    final DateTime date = events.isNotEmpty ? events.first.throwDate : DateTime
        .now();

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
          if (events.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JournalEditView(
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
      body: events.isEmpty
          ? Center(child: Text('No data available'))
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final action = "투망";
          final locationName = event.locationName;

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
                        ' ${locationName}',
                    style: header3B(gray8),
                  ),
                  SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${action}시간: ',
                          style: body2(gray5),
                        ),
                        TextSpan(
                          text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                              .format(event.throwDate),
                          style: body2(black),
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
                          style: body2(gray5),
                        ),
                        TextSpan(
                          text:
                          '위도 ${event.location[0]} 경도 ${event.location[1]}',
                          style: body2(black),
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
                          style: body2(gray5),
                        ),
                        TextSpan(
                          text: '${event.wave}m',
                          style: body2(black),
                        ),
                      ],
                    ),
                  ),
                  if (event.isGet) ...[
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
                            style: body2(gray5),
                          ),
                          TextSpan(
                            text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                .format(event.getDate),
                            style: body2(black),
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
                              vertical: 8.0),
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
                                      '${event.species.elementAt(index)}\n',
                                      style: body2(black),
                                    ),
                                    TextSpan(
                                      text: '어획량         ',
                                      style: body2(gray5),
                                    ),
                                    TextSpan(
                                      text:
                                      '${event.amount[index]} kg',
                                      style: body2(black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Divider(),
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
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 100.0,
                      ),
                      child: Text(
                        event.memo ?? "",
                        style: body2(black),
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}