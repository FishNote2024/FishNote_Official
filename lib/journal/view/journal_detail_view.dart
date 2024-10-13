import 'package:fish_note/journal/view/journal_edit_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/net/model/net_record.dart'; // NetRecord를 가져옴
import 'package:intl/intl.dart';

class JournalDetailView extends StatefulWidget {
  final List<NetRecord> events;

  const JournalDetailView({super.key, required this.events});

  @override
  _JournalDetailViewState createState() => _JournalDetailViewState();
}

class _JournalDetailViewState extends State<JournalDetailView> with RouteAware {
  List<NetRecord> _events = [];

  @override
  void initState() {
    super.initState();
    _events = widget.events;
    if (_events.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, ModalRoute.withName('/journal'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = _events.isNotEmpty ? _events.first.throwDate : DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(DateFormat('MM.dd (E)', 'ko_KR').format(date), style: body2(textBlack),),
        centerTitle: true,
        actions: [
          if (_events.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JournalEditView(
                            recordId: _events.first.id, events: _events),
                  ),
                ).then((value) {
                  setState(() {
                    _events = value;
                  });
                });
              },
              child: Text(
                '수정하기',
                style: body2(primaryBlue500),
              ),
            ),
        ],
      ),
      body: _events.isEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          const action = "투망";
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
                    '${DateFormat('HH:mm').format(event.throwDate)} $locationName',
                    style: header4(gray8),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$action시간  ',
                          style: body3(gray5),
                        ),
                        TextSpan(
                          text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                              .format(event.throwDate),
                          style: body1(black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$action위치  ',
                          style: body3(gray5),
                        ),
                        TextSpan(
                          text:
                          '위도 ${event.location.latitude} 경도 ${event.location.longitude}',
                          style: body1(black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.5),
                  Text(
                    '해상 기록',
                    style: header4(gray8),
                  ),
                  const SizedBox(height: 16.5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '파고  ',
                          style: body3(gray5),
                        ),
                        TextSpan(
                          text: '${event.wave}m',
                          style: body1(black),
                        ),
                      ],
                    ),
                  ),
                  if (event.isGet) ...[
                    const SizedBox(height: 16.5),
                    Text(
                      '양망기록',
                      style: header4(gray8),
                    ),
                    const SizedBox(height: 16.5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '양망시간  ',
                            style: body3(gray5),
                          ),
                          TextSpan(
                            text: DateFormat('MM.dd(E) HH시 mm분', 'ko_KR')
                                .format(event.getDate),
                            style: body1(black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.5),
                    Text(
                      '어획',
                      style: header4(gray8),
                    ),
                    const SizedBox(height: 16.5),
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
                                      style: body3(gray5),
                                    ),
                                    TextSpan(
                                      text:
                                      '${event.species.elementAt(index)}',
                                      style: body1(black),
                                    ),
                              ]),
                              ),
                              const SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '어획량         ',
                                        style: body3(gray5),
                                      ),
                                      TextSpan(
                                        text:
                                        '${event.amount[index]} kg',
                                        style: body1(black),
                                      ),
                                    ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(
                                color: gray1,
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.5),
                    Text(
                      '메모',
                      style: header4(gray8),
                    ),
                    const SizedBox(height: 16.5),
                    Container(
                      padding: const EdgeInsets.all(8.0),
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
