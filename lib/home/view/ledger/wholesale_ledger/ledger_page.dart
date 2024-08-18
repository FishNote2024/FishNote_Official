import 'package:fish_note/home/view/ledger/wholesale_ledger/add_ledger_page.dart';
import 'package:fish_note/home/view/ledger/wholesale_ledger/ledger_model.dart';
import 'package:fish_note/home/view/ledger/wholesale_ledger/line_chart_view.dart';
import 'package:fish_note/home/view/ledger/wholesale_ledger/pie_chart_view.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  final PanelController _panelController = PanelController();

  // 임시로 데이터를 저장하는 Map
  final Map<DateTime, IncomeExpense> _incomeExpenseData = {
    DateTime.utc(2024, 8, 19): IncomeExpense(
        date: DateTime.utc(2024, 8, 19), income: 5000, expense: 2000),
    DateTime.utc(2024, 8, 15): IncomeExpense(
        date: DateTime.utc(2024, 8, 15), income: 10000, expense: 8000),
  };

  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_panelController.isAttached) {
        _panelController.hide();
      }
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      print('🗓 Selected Day: $selectedDay');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_panelController.isAttached) {
          _panelController.show();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_panelController.isPanelShown) {
                _panelController.hide();
              }
            },
            child: SingleChildScrollView(
              child: Container(
                color: backgroundBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    _buildTableCalendar(),
                    const SizedBox(height: 40.0),
                    _buildTableLedger(),
                    _buildLineChart(),
                    const SizedBox(height: 40.0),
                    _buildPieChart(),
                  ],
                ),
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            panel: _buildSlidingUpPanelContent(),
            minHeight: 330,
            maxHeight: 1000,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return Column(
      children: [
        Stack(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              onDaySelected: (selectedDay, focusedDay) {
                _onDaySelected(selectedDay, focusedDay);
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
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
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('2024년 6월'),
          content: SizedBox(
            height: 200,
            width: 283,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, index + 1);
                        },
                        child: Center(child: Text('${index + 1}월')),
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index + 1}주차'),
                        onTap: () {
                          Navigator.pop(context, index + 1);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          _focusedDay = DateTime(2024, selectedValue, 1);
        });
      }
    });
  }

  Widget _buildSlidingUpPanelContent() {
    if (_selectedDay == null) {
      return Center(
        child: Text("선택된 날짜가 없습니다.", style: body1(Colors.black)),
      );
    }

    final DateTime selectedDateOnly = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );

    final incomeExpense = _incomeExpenseData.keys.firstWhere(
      (date) =>
          date.year == selectedDateOnly.year &&
          date.month == selectedDateOnly.month &&
          date.day == selectedDateOnly.day,
      orElse: () => DateTime(0),
    );

    final hasData = incomeExpense != DateTime(0);

    return Container(
      padding: const EdgeInsets.only(left: 18.0, right: 50, bottom: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: !hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Column(children: [
                            Image.asset('assets/icons/ledgerIcon.png',
                                width: 130),
                            Text("오늘의 수입과 지출을 기록하세요!", style: body1(textBlack)),
                          ]),
                        ),
                        const SizedBox(height: 80),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddLedgerPage(
                                    selectedDate: _selectedDay!.toLocal(),
                                  ),
                                ),
                              )
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue500,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('장부 추가', style: header4(Colors.white)),
                          ),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            '${DateFormat('yyyy.MM.dd').format(_selectedDay!.toLocal())}',
                            style: header3B(gray8)),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 33,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddLedgerPage(
                                    selectedDate: _selectedDay!.toLocal(),
                                  ),
                                ),
                              )
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: primaryBlue500),
                              ),
                            ),
                            child:
                                Text('자세히 보기', style: header4(primaryBlue500)),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text('매출', style: body1(gray4)),
                            const SizedBox(width: 12),
                            Text(
                                '${_incomeExpenseData[selectedDateOnly]?..toString()}원',
                                style: header4(primaryBlue300))
                          ],
                        ),
                        SizedBox(height: 16),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text('어획량', style: caption1(gray4)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child:
                                      Text('단가 (1kg)', style: caption1(gray4)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text('총합', style: caption1(gray4)),
                                ),
                              ],
                            ),
                            _buildTableRow('우럭 120kg', '2,000', '240,000원'),
                            _buildTableRow('도다리 183kg', '988', '642,000원'),
                            _buildTableRow('아귀 133kg', '1,230', '231,070원'),
                          ],
                        ),
                        Divider(color: gray1, thickness: 1, endIndent: 156),
                        Row(
                          children: [
                            Text('지출', style: body1(gray4)),
                            const SizedBox(width: 12),
                            Text(
                                '${_incomeExpenseData[selectedDateOnly]?.expense.toString()}원',
                                style: header4(primaryYellow900))
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String item, String price, String total) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(item, style: body2(black)),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text('× $price', style: body2(black)),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text('=', style: body2(black)),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(total, style: body2(black)),
        ),
      ],
    );
  }

  Widget _buildTableLedger() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.zero,
          child: Row(children: [
            DropdownButton<int>(
                value: _selectedValue,
                items: [
                  DropdownMenuItem(
                      child: Text('월간 총 이익', style: body1(gray5)), value: 0),
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
            const Spacer(),
            Text("계좌연동 기능 준비중", style: body3(gray3))
          ]),
        ),
        Text("10,145,070원", style: header1B(primaryBlue500)),
        const SizedBox(height: 20),
        Column(
          children: [
            Row(
              children: [
                Text('매출', style: body1(gray4)),
                const SizedBox(width: 12),
                Text('50,245,070원', style: header4(primaryBlue300))
              ],
            ),
            Divider(color: gray1, thickness: 1, endIndent: 156),
            Row(
              children: [
                Text('지출', style: body1(gray4)),
                const SizedBox(width: 12),
                Text('5,000,000원', style: header4(primaryYellow900))
              ],
            ),
            Divider(color: gray1, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('합계', style: body1(gray4)),
                const SizedBox(width: 12),
                Text('10,145,070원', style: header4(primaryBlue500))
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return Column(
      children: [
        Row(
          children: [
            Text('매출 추이', style: body1(gray8)),
            const Spacer(),
            Text("단위 1백만", style: body3(gray4))
          ],
        ),
        const SizedBox(height: 13.0),
        LineChartView(),
      ],
    );
  }

  Widget _buildPieChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<int>(
            value: _selectedValue,
            items: [
              DropdownMenuItem(
                  child: Text('매출 통계', style: body1(gray8)), value: 0),
              DropdownMenuItem(
                  child: Text('지출 통계', style: body1(gray8)), value: 1)
            ],
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
            dropdownColor: Colors.white,
            style: body2(gray8),
            underline: Container(height: 0, color: Colors.transparent)),
        const SizedBox(height: 20.0),
        PieChartView(),
        const SizedBox(height: 30)
      ],
    );
  }
}
