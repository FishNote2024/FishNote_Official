import 'package:fish_note/home/view/ledger/wholesale_ledger/line_chart_view.dart';
import 'package:fish_note/home/view/ledger/wholesale_ledger/pie_chart_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../theme/font.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedValue = 0;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              onDaySelected: _onDaySelected,
              locale: 'ko_KR',
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextFormatter: (date, locale) =>
                    DateFormat.yMMMMd(locale).format(date),
                formatButtonVisible: false,
                titleTextStyle: body1(gray6),
                headerPadding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12),
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
            const SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.zero,
              child: Row(children: [
                DropdownButton<int>(
                    value: _selectedValue,
                    items: [
                      DropdownMenuItem(
                          child: Text('월간 총 이익', style: body1(gray5)),
                          value: 0),
                      DropdownMenuItem(
                          child: Text('주간 총 이익', style: body1(gray5)), value: 1)
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                    dropdownColor: Colors.white,
                    style: body2(gray8),
                    underline: Container(height: 0, color: Colors.transparent)),
                Spacer(),
                Text("계좌연동 기능 준비중", style: body3(gray3))
              ]),
            ),
            Text("10,145,070원", style: header1B(primaryBlue500)),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    Text('매출', style: body1(gray4)),
                    SizedBox(width: 12),
                    Text('50,245,070원', style: header4(primaryBlue300))
                  ],
                ),
                Divider(color: gray1, thickness: 1, endIndent: 156),
                Row(
                  children: [
                    Text('지출', style: body1(gray4)),
                    SizedBox(width: 12),
                    Text('5,000,000원', style: header4(primaryYellow900))
                  ],
                ),
                Divider(color: gray1, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('합계', style: body1(gray4)),
                    SizedBox(width: 12),
                    Text('10,145,070원', style: header4(primaryBlue500))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                Text('매출 추이', style: body1(gray8)),
                const Spacer(),
                Text("단위 1백만", style: body3(gray4))
              ],
            ),
            const SizedBox(height: 13.0),
            LineChartView(),
            SizedBox(height: 40.0),
            Text('매출 통계', style: body1(gray8)),
            SizedBox(height: 24.0),
            PieChartView()
          ],
        ),
      ),
    );
  }
}
