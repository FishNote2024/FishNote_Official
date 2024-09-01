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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _panelController.hide(); // 앱 시작 시 패널을 숨김
    });
  }


  List<NetRecord> _getEventsForDay(DateTime day) {
    return _netRecords.where((event) => isSameDay(event.throwDate, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    _netRecords = Provider.of<NetRecordProvider>(context).netRecords;

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
                child: TableCalendar<NetRecord>(
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
                    markerBuilder: (context, day, netRecord) {
                      // netRecord 리스트가 비어있지 않고, day가 _focusedDay나 _selectedDay가 아닌 경우 마커 생성
                      if (netRecord.isNotEmpty &&
                          !isSameDay(day, _focusedDay) &&
                          !isSameDay(day, _selectedDay)
                          // && !isSameDay(day, _today)
                      ) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: netRecord.expand((event) {
                            // event에 대해 마커 리스트 생성
                            List<Widget> markers = [];

                            if (!event.isGet) {
                              // isGet이 true인 경우
                              // throwDate에 대해 primaryBlue500 색상의 마커 추가
                              if (isSameDay(event.throwDate, day)) {
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
                              }
                              // getDate에 대해 primaryYellow700 색상의 마커 추가
                              if (isSameDay(event.getDate, day)) {
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
                              }
                            } else {
                              // isGet이 false인 경우 throwDate에 대해 primaryBlue500 색상의 마커 추가
                              if (isSameDay(event.throwDate, day)) {
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
                              }
                            }

                            return markers;
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
              ?
          DetailButton(
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
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(event.throwDate) + ' ${event.locationName}',
                          style: header3B(primaryBlue500),
                        ),
                        SizedBox(height: 16),
                        Text('투망 시간 : ' + DateFormat('MM.dd(E) HH시 mm분', 'ko_KR').format(event.throwDate),

                            style: body2(gray8)
                        ),
                        SizedBox(height: 4),
                        Text(
                          '투망 위치 : 위도 ${event.location[0]} 경도 ${event.location[1]}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16.5),
                        Text(
                          '해상 기록',
                          style: header4(gray8),
                        ),
                        SizedBox(height: 16.5),
                        Text(
                          '파고: ${event.locationName}', //파고
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
}
