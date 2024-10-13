import 'package:fish_note/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../net/model/net_record.dart';
import '../components/DetailButton.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../theme/font.dart';
import '../../../../theme/colors.dart';

import 'journal_detail_view.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late List<NetRecord> _netRecords;
  late final ValueNotifier<List<NetRecord>> _selectedEvents;
  final DateTime _today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final PanelController _panelController = PanelController();
  DateTime? _selectedPanelDate;
  final firstDay = DateTime.utc(2020, 12, 31);
  final lastDay = DateTime.utc(2031, 1, 1);

  bool hasEventsOnDay(DateTime day) {
    // _netRecords가 초기화되지 않았을 경우 빈 리스트를 반환하도록 방어 코드 추가
    if (_netRecords.isEmpty) return false;

    return _netRecords.any((event) => isSameDay(event.throwDate, day));
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedPanelDate = _today;
    _selectedEvents = ValueNotifier<List<NetRecord>>([]);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _panelController.hide(); // 앱 시작 시 패널을 숨김
    // });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _netRecords = Provider.of<NetRecordProvider>(context).netRecords;
    _initPanelWithData();
  }

  void _initPanelWithData() {
    List<NetRecord> initialEvents =
        _getEventsForDay(_selectedDay ?? DateTime.now());
    if (initialEvents.isNotEmpty) {
      _selectedEvents.value = initialEvents;
    }
  }

// 고쳐보기
  List<NetRecord> _getEventsForDay(DateTime day) {
    return _netRecords
        .where((event) => isSameDay(event.throwDate, day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
        ),
        title: Text("조업 일지", style: body2(textBlack),),
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: 800,
        minHeight: 360,
        panelBuilder: (ScrollController sc) => _buildSlidingPanel(sc),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        body: GestureDetector(
          onTap: () {
            if (_panelController.isPanelShown) {
              _panelController.hide();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: _buildTableCalendar(),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlidingPanel(ScrollController sc) {
    return ListView(
      controller: sc,
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Text(
            DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(_selectedDay!),
            style: body1(gray8),
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: hasEventsOnDay(_selectedDay!)
              ? DetailButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalDetailView(
                          events: _getEventsForDay(_selectedDay!),
                        ),
                      ),
                    );
                  },
                  text: "자세히 보기",
                  color: primaryBlue500,
                )
              : DetailButton(
                  onPressed: () {},
                  text: "자세히 보기",
                  color: gray3,
                ),
        ),
        const SizedBox(height: 16.0),
        hasEventsOnDay(_selectedDay!)
            ? ValueListenableBuilder<List<NetRecord>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final event = value[index];
                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('HH:mm').format(event.throwDate)} ${event.locationName}',
                                style: header4(primaryBlue500),
                              ),
                              SizedBox(height: 16),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '투망시간  ',
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
                              SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '투망위치  ',
                                      style: body3(gray5),
                                    ),
                                    TextSpan(
                                      text: "위도 ${event.location.latitude} 경도 ${event.location.longitude}",
                                      style: body1(black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.5),
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
                                      text: "${event.wave}m",
                                      style: body1(black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Align(
                alignment: Alignment.topCenter, // 세로로 맨 위에, 가로로 중앙에 배치
                child: Column(
                  children: [
                    SizedBox(height: 65),
                    Image.asset(
                      'assets/icons/no_journal.png',
                    ),
                    Text(
                      "오늘도 만선 하세요!",
                      style: body1(gray8),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              top: 60,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 첫 번째 원과 텍스트
                  Row(
                    children: [
                      Container(
                        width: 5.0,
                        height: 5.0,
                        decoration: const BoxDecoration(
                          color: primaryBlue500, // Show blue for today
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4.0), // 원과 텍스트 사이의 간격
                      Text("투망", style: caption1(gray6)), // 첫 번째 텍스트
                    ],
                  ),
                  const SizedBox(width: 16.0), // 두 개의 그룹 사이 간격
                  // 두 번째 원과 텍스트
                  Row(
                    children: [
                      Container(
                        width: 5.0,
                        height: 5.0,
                        decoration: const BoxDecoration(
                          color: primaryYellow700,// Show blue for today
                          shape: BoxShape.circle,
                        )
                      ),
                      const SizedBox(width: 4.0), // 원과 텍스트 사이의 간격
                      Text("양망", style: caption1(gray6)), // 두 번째 텍스트
                    ],
                  ),
                ],
              ),
            ),
            TableCalendar<NetRecord>(
              firstDay: DateTime.utc(2020, 12, 31),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              // 심화 : 값이 바뀔때마다 로직이 따라올 경우 stream, rxdart
              onDaySelected: (selectedDay, focusedDay) {
                //초기 진입시에 이게 되도록 설정
                if (!isSameDay(_selectedDay, selectedDay)) {
                  //함수로 뺀 후 // initState에서 설정해주고 난뒤 한번 돌게끔 설정
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedPanelDate = selectedDay;
                  });

                  _selectedEvents.value = _getEventsForDay(selectedDay);
                  _panelController.show(); // 패널 열기
                } else {
                  if (!_panelController.isPanelShown) {
                    _panelController.show();
                  } else {
                    _panelController.hide();
                  }
                }
              },

              locale: 'ko_KR',
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: body1(gray6),
                headerPadding:
                    const EdgeInsets.only(right: 65, left:65,bottom: 30, top: 17.5),
                leftChevronIcon: const Icon(Icons.arrow_back_ios, size: 15.0),
                rightChevronIcon:
                    const Icon(Icons.arrow_forward_ios, size: 15.0),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: body2(primaryBlue400),
                weekendStyle: body2(primaryBlue400),
              ),
              daysOfWeekHeight: 25,
              calendarStyle: CalendarStyle(
                outsideTextStyle: body2(gray3),
                defaultTextStyle: body2(gray8),
                todayTextStyle: body2(Colors.white),
                selectedTextStyle: (day) {
                  // If the selected day is today, apply a special style
                  if (isSameDay(day, _today)) {
                    return body2(Colors.white); // White text for today when selected
                  }
                  return body2(gray8); // Default style for other selected days
                }(_selectedDay),
                selectedDecoration: (day) {
                  // If the selected day is the same as today, prioritize the todayDecoration (blue)
                  if (isSameDay(day, _today)) {
                    return const BoxDecoration(
                      color: primaryBlue500, // Show blue for today
                      shape: BoxShape.circle,
                    );
                  }
                  return const BoxDecoration(
                    color: primaryYellow500,
                    // Show yellow for other selected days
                    shape: BoxShape.circle,
                  );
                }(_selectedDay),
                todayDecoration: const BoxDecoration(
                  color: primaryBlue500,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, netRecord) {
                  netRecord = Provider.of<NetRecordProvider>(context).netRecords;

                  // 전체 netRecord에서 marker 조건을 처리
                  bool hasThrowDateMarker = netRecord.any((event) => isSameDay(event.throwDate, day));
                  bool hasGetDateMarker = netRecord.any((event) => event.isGet && isSameDay(event.getDate, day));

                  // Marker가 있어야 하는 경우에만 Row 위젯을 반환
                  if (hasThrowDateMarker || hasGetDateMarker) {
                    // 카운터 추가해서 4개 이상은 표시 안되도록 설정
                    int markerCount = 0;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: netRecord.expand((event) {
                        List<Widget> markers = [];

                        if (markerCount >= 4) {
                          return markers; // 더 이상 마커 추가 안함
                        }

                        // throwDate에 해당하는 경우 파란색 마커 추가
                        if (isSameDay(event.throwDate, day) && markerCount < 4) {
                          markers.add(
                            Container(
                              margin: const EdgeInsets.only(top: 40, right: 2),
                              child: const Icon(
                                size: 5,
                                Icons.circle,
                                color: primaryBlue500,
                              ),
                            ),
                          );
                          markerCount++;
                        }

                        // getDate에 해당하는 경우 노란색 마커 추가
                        if (event.isGet && isSameDay(event.getDate, day) && markerCount < 4) {
                          markers.add(
                            Container(
                              margin: const EdgeInsets.only(top: 40, right: 2),
                              child: const Icon(
                                size: 5,
                                Icons.circle,
                                color: primaryYellow700,
                              ),
                            ),
                          );
                          markerCount++;
                        }

                        return markers;
                      }).toList(),
                    );
                  }

                  return const SizedBox.shrink(); // 조건에 맞지 않으면 빈 공간 반환
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showMonthWeekPicker(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.yMMMM('ko_KR').format(_focusedDay),
                      style: body1(Colors.transparent),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMonthWeekPicker(BuildContext context) {
    DateTime tempDay = _focusedDay;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (DateTime(tempDay.year - 1, tempDay.month, 1)
                              .isAfter(firstDay)) {
                            tempDay =
                                DateTime(tempDay.year - 1, tempDay.month, 1);
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios, size: 14)),
                  const Spacer(),
                  Text(
                      DateFormat.y('ko_KR').format(
                          tempDay.year == _focusedDay.year
                              ? _focusedDay
                              : tempDay),
                      style: header4(black)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (DateTime(tempDay.year + 1, tempDay.month, 1)
                              .isBefore(lastDay)) {
                            tempDay =
                                DateTime(tempDay.year + 1, tempDay.month, 1);
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 14)),
                ],
              ),
            ),
            content: SizedBox(
              height: 220,
              width: 283,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, [tempDay.year, index + 1]);
                          },
                          child: Center(
                              child:
                                  Text('${index + 1}월', style: body1(gray6))),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          _focusedDay = DateTime(selectedValue[0], selectedValue[1], 1);
        });
      }
    });
  }
}
