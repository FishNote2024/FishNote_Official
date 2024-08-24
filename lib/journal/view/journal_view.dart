import 'package:flutter/material.dart';
import '../components/DetailButton.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../theme/font.dart';
import '../../../../theme/colors.dart';
import 'package:fish_note/journal/model/fish_daily.dart';

import 'journal_detail_view.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late final ValueNotifier<List<FishDaily>> _selectedEvents;
  final DateTime _today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final PanelController _panelController = PanelController();
  DateTime? _selectedPanelDate;

  bool hasEventsOnDay(DateTime day) {
    return _events.any((event) => isSameDay(event.datetime, day));
  }
  // 이벤트 데이터 (예시)
  final List<FishDaily> _events = [
    FishDaily(DateTime.utc(2024, 8, 18, 7, 30), true, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "하얀부표"),
    FishDaily(DateTime.utc(2024, 8, 18, 19, 0), false, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "문어대가리"),
    FishDaily(DateTime.utc(2024, 8, 19, 8, 0), false, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "빨간부표"),
    FishDaily(DateTime.utc(2024, 8, 20, 9, 0), true, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "말머리"),
    FishDaily(DateTime.utc(2024, 8, 20, 12, 0), false, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "오징어클럽"),
    FishDaily(DateTime.utc(2024, 8, 20, 13, 0), false, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "광어핫플"),
    FishDaily(DateTime.utc(2024, 8, 20, 16, 30), true, {'lat': 37.7749, 'lng': -122.4194}, '2.2m', "닉네임"),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedPanelDate = _today;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _panelController.hide(); // 앱 시작 시 패널을 숨김
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<FishDaily> _getEventsForDay(DateTime day) {
    return _events.where((event) => isSameDay(event.datetime, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        centerTitle: true,
        title: const Text("조업 일지"),
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
                child: TableCalendar<FishDaily>(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
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
                  calendarFormat: CalendarFormat.month,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      // 오늘 날짜나 선택된 날짜에서는 마커를 표시하지 않음
                      if (events.isNotEmpty &&
                          !isSameDay(day, _focusedDay) &&
                          !isSameDay(day, _selectedDay) &&
                          !isSameDay(day, _today)) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: events.map((event) {
                            if ((event as FishDaily).tooMang) {
                              return Container(
                                margin: const EdgeInsets.only(top: 40, right: 2),
                                child: const Icon(
                                  size: 5,
                                  Icons.circle,
                                  color: primaryBlue500,
                                ),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(top: 40, right: 2),
                                child: const Icon(
                                  size: 5,
                                  Icons.circle,
                                  color: primaryYellow700,
                                ),
                              );
                            }
                          }).toList(),
                        );
                      }
                      return SizedBox.shrink(); // 조건에 맞지 않으면 빈 공간 반환
                    },
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: body2(primaryBlue400),
                    weekendStyle: body2(primaryBlue400),
                    dowTextFormatter: (date, locale) {
                      return ['일', '월', '화', '수', '목', '금', '토'][date.weekday % 7];
                    },
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextFormatter: (date, locale) =>
                        DateFormat('yyyy.MM', locale).format(date),
                    headerPadding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12),
                    leftChevronIcon: const Icon(Icons.arrow_back_ios, size: 15.0),
                    rightChevronIcon: const Icon(Icons.arrow_forward_ios, size: 15.0),
                  ),
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  daysOfWeekHeight: 25,
                  eventLoader: _getEventsForDay,
                  calendarStyle: CalendarStyle(
                    outsideTextStyle: body2(gray3),
                    defaultTextStyle: body2(gray8),
                    todayTextStyle: body2(Colors.white),
                    selectedTextStyle: body2(gray8),
                    todayDecoration: const BoxDecoration(
                      color: primaryBlue500,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: primaryYellow500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
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
      padding: const EdgeInsets.all(33),
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
            ? ValueListenableBuilder<List<FishDaily>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final event = value[index];
                final action = event.tooMang ? "투망" : "양망";
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(event.datetime) + ' ${event.locationName}',
                          style: header3B(primaryBlue500),
                        ),
                        SizedBox(height: 16),
                        Text('투망 시간 : ' + DateFormat('MM.dd(E) HH시 mm분', 'ko_KR').format(event.datetime),
                              style: body2(gray8)
                            ),
                        SizedBox(height: 4),
                        Text(
                              '투망 위치 : 위도 ${event.location['lat']} 경도 ${event.location['lng']}',
                              style: TextStyle(fontSize: 14),
                            ),
                        SizedBox(height: 16.5),
                        Text(
                          '해상 기록',
                          style: header4(gray8),
                        ),
                        SizedBox(height: 16.5),
                        Text(
                          '파고: ${event.wav}',
                          style: body1(gray8),
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
              Text(
                "이미지",
                style: body1(gray8),
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
}
