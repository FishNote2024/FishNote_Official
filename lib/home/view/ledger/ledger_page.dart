import 'package:fish_note/Ledger/view/wholesale_ledger/add_ledger_page.dart';
import 'package:fish_note/Ledger/view/wholesale_ledger/ledger_detail_page.dart';
import 'package:fish_note/Ledger/view/wholesale_ledger/line_chart_view.dart';
import 'package:fish_note/Ledger/view/wholesale_ledger/pie_chart_view.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key, required int initialTabIndex});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedValue = 0;
  int _pieChartSelectedValue = 0;
  final PanelController _panelController = PanelController();
  final firstDay = DateTime.utc(2020, 12, 31);
  final lastDay = DateTime.utc(2031, 1, 1);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    setState(() {
      _selectedDay = now;
      _focusedDay = now;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_panelController.isAttached) {
        _panelController.show();
      }
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_panelController.isAttached) {
          _panelController.show();
        }
      });
    }
  }

  // 총 매출 계산
  int _calculateTotalRevenue(List<LedgerModel> ledgers) {
    return ledgers.fold(0, (total, ledger) => total + ledger.totalSales);
  }

  // 총 지출 계산
  int _calculateTotalExpense(List<LedgerModel> ledgers) {
    return ledgers.fold(0, (total, ledger) => total + ledger.totalPays);
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
            panel: _buildSlidingUpPanelContent(context),
            minHeight: 460,
            maxHeight: 1000,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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
            TableCalendar<LedgerModel>(
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                final today = DateTime.now();
                final normalizedSelectedDay =
                    DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                final normalizedToday = DateTime(today.year, today.month, today.day);

                if (normalizedSelectedDay.isAfter(normalizedToday)) {
                  return;
                }

                _onDaySelected(selectedDay, focusedDay);
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _panelController.show();
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
                headerPadding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12),
                leftChevronIcon: const Icon(Icons.arrow_back_ios, size: 15.0),
                rightChevronIcon: const Icon(Icons.arrow_forward_ios, size: 15.0),
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, ledgers) {
                  ledgers = Provider.of<LedgerProvider>(context).ledgers;
                  // netRecord 리스트가 비어있지 않고, day가 _focusedDay나 _selectedDay가 아닌 경우 마커 생성
                  if (ledgers.isNotEmpty &&
                          !isSameDay(day, _focusedDay) &&
                          !isSameDay(day, _selectedDay)
                      // && !isSameDay(day, _today)
                      ) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ledgers.expand((event) {
                        // event에 대해 마커 리스트 생성
                        List<Widget> markers = [];

                        // isGet이 true인 경우
                        // throwDate에 대해 primaryBlue500 색상의 마커 추가
                        if (isSameDay(event.date, day)) {
                          if (event.totalSales > 0) {
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
                          if (event.totalPays > 0) {
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
                          if (DateTime(tempDay.year - 1, tempDay.month, 1).isAfter(firstDay)) {
                            tempDay = DateTime(tempDay.year - 1, tempDay.month, 1);
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios, size: 14)),
                  const Spacer(),
                  Text(
                      DateFormat.y('ko_KR')
                          .format(tempDay.year == _focusedDay.year ? _focusedDay : tempDay),
                      style: header4(black)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (DateTime(tempDay.year + 1, tempDay.month, 1).isBefore(lastDay)) {
                            tempDay = DateTime(tempDay.year + 1, tempDay.month, 1);
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, [tempDay.year, index + 1]);
                          },
                          child: Center(child: Text('${index + 1}월', style: body1(gray6))),
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
          _focusedDay =
              DateTime(selectedValue[0], selectedValue[1] + 1, 1).subtract(const Duration(days: 1));
          if (_focusedDay.isBefore(DateTime.now())) {
            _onDaySelected(_focusedDay, _focusedDay);
          }
        });
      }
    });
  }

  Widget _buildSlidingUpPanelContent(BuildContext context) {
    if (_selectedDay == null) {
      return Center(
        child: Text("선택된 날짜가 없습니다.", style: body1(Colors.black)),
      );
    }

    return Consumer<LedgerProvider>(
      builder: (context, ledgerProvider, child) {
        final ledger = ledgerProvider.ledgers.firstWhere(
          (l) => isSameDay(l.date, _selectedDay),
          orElse: () =>
              LedgerModel(date: _selectedDay!, sales: [], pays: [], totalPays: 0, totalSales: 0),
        );

        final hasData = ledgerProvider.ledgers.any((l) => isSameDay(l.date, _selectedDay));

        return Container(
          padding: const EdgeInsets.only(left: 18.0, right: 50, bottom: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 24),
                  child: GestureDetector(
                    onTap: () {
                      _panelController.hide();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/topDivider.svg',
                      width: 130,
                    ),
                  ),
                ),
                Center(
                  child: !hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 140),
                            Center(
                              child: Column(children: [
                                Image.asset('assets/icons/ledgerIcon.png', width: 130),
                                Text("오늘의 수입과 지출을 기록하세요!", style: body1(textBlack)),
                              ]),
                            ),
                            const SizedBox(height: 130),
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
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(DateFormat('yyyy.MM.dd').format(_selectedDay!.toLocal()),
                                style: header3B(gray8)),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 33,
                              child: ElevatedButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LedgerDetailPage(
                                        selectedDate: _selectedDay!.toLocal(),
                                      ),
                                    ),
                                  )
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: primaryBlue500),
                                  ),
                                ),
                                child: Text('자세히 보기', style: header4(primaryBlue500)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text('매출', style: body1(gray4)),
                                const SizedBox(width: 12),
                                Text(
                                    '${NumberFormat('#,###').format(ledger.sales.fold(0, (sum, item) => sum + (item.price * item.weight).round()))}원',
                                    style: header4(primaryBlue300))
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text("어획량", style: caption1(gray4)),
                                const SizedBox(width: 90),
                                Text("단가", style: caption1(gray4)),
                                const SizedBox(width: 50),
                                Text("총합", style: caption1(gray4))
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildRevenueTable(ledger.sales),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Text('지출', style: body1(gray4)),
                                const SizedBox(width: 12),
                                Text(
                                    '${NumberFormat('#,###').format(ledger.pays.fold(0, (sum, item) => sum + (item.amount)))}원',
                                    style: header4(primaryYellow900))
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text("이름", style: caption1(gray4)),
                                const SizedBox(width: 75),
                                Text("가격", style: caption1(gray4)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildExpenseTable(ledger.pays),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Table _buildRevenueTable(List<SaleModel> sales) {
    List<TableRow> rows = [];

    for (final sale in sales) {
      rows.add(
        TableRow(
          children: [
            Text(sale.species, style: body2(black)),
            Text('${sale.weight}${sale.unit == 'KG' ? 'kg' : 'cs'}', style: body2(black)),
            Text('X ${NumberFormat('#,###').format(sale.price)}', style: body2(black)),
            Text('= ${NumberFormat('#,###').format((sale.price * sale.weight).round())}원',
                style: body2(black)),
          ],
        ),
      );

      if (sales.last != sale) {
        rows.add(
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
            ],
          ),
        );
      }
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  Table _buildExpenseTable(List<PayModel> pays) {
    List<TableRow> rows = [];

    for (final pay in pays) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(pay.category, style: body2(black)),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text('${NumberFormat('#,###').format(pay.amount)}원', style: body2(black)),
            ),
          ],
        ),
      );
      if (pays.last != pay) {
        rows.add(
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Divider(color: gray1, thickness: 1),
              ),
            ],
          ),
        );
      }
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: rows,
    );
  }

  Widget _buildTableLedger() {
    return Consumer<LedgerProvider>(builder: (context, ledgerProvider, child) {
      int totalRevenue = _selectedValue == 0
          ? _calculateTotalRevenue(ledgerProvider.ledgers
              // 현재 날짜로부터 30일 이전까지의 데이터만 필터링
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 30))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList())
          : _calculateTotalRevenue(ledgerProvider.ledgers
              // 현재 날짜로부터 7일 이전까지의 데이터만 필터링
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 7))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList());
      int totalExpense = _selectedValue == 0
          ? _calculateTotalExpense(ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 30))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList())
          : _calculateTotalExpense(ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 7))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList());

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: Row(children: [
              DropdownButton<int>(
                  value: _selectedValue,
                  items: [
                    DropdownMenuItem(value: 0, child: Text('월간 총 이익', style: body1(gray5))),
                    DropdownMenuItem(value: 1, child: Text('주간 총 이익', style: body1(gray5)))
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                      _pieChartSelectedValue = 0;
                    });
                  },
                  dropdownColor: Colors.white,
                  style: body2(gray8),
                  underline: Container(height: 0, color: Colors.transparent)),
              const Spacer(),
              Text("계좌연동 기능 준비중", style: body3(gray3))
            ]),
          ),
          Text("${NumberFormat("#,###").format(totalRevenue)}원", style: header1B(primaryBlue500)),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  Text('매출', style: body1(gray4)),
                  const SizedBox(width: 12),
                  Text('${NumberFormat("#,###").format(totalRevenue)}원',
                      style: header4(primaryBlue300))
                ],
              ),
              const Divider(color: gray1, thickness: 1, endIndent: 156),
              Row(
                children: [
                  Text('지출', style: body1(gray4)),
                  const SizedBox(width: 12),
                  Text('${NumberFormat("#,###").format(totalExpense)}원',
                      style: header4(primaryYellow900))
                ],
              ),
              const Divider(color: gray1, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('합계', style: body1(gray4)),
                  const SizedBox(width: 12),
                  Text('${NumberFormat("#,###").format(totalRevenue - totalExpense)}원',
                      style: header4(primaryBlue500))
                ],
              ),
              const SizedBox(height: 40)
            ],
          ),
        ],
      );
    });
  }

  Widget _buildLineChart() {
    return Consumer<LedgerProvider>(builder: (context, ledgerProvider, child) {
      final ledgers = _selectedValue == 0
          ? ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 30))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList()
          : ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 7))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList();

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
          LineChartView(ledgers: ledgers, value: _selectedValue, time: _selectedDay ?? _focusedDay),
        ],
      );
    });
  }

  Widget _buildPieChart() {
    return Consumer<LedgerProvider>(builder: (context, ledgerProvider, child) {
      final ledgers = _selectedValue == 0
          ? ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 30))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList()
          : ledgerProvider.ledgers
              .where((ledger) => ledger.date
                  .isAfter((_selectedDay ?? _focusedDay).subtract(const Duration(days: 7))))
              .where((ledger) =>
                  ledger.date.isBefore((_selectedDay ?? _focusedDay).add(const Duration(days: 1))))
              .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<int>(
              value: _pieChartSelectedValue,
              items: [
                DropdownMenuItem(value: 0, child: Text('지출 통계', style: body1(gray8))),
                DropdownMenuItem(value: 1, child: Text('매출 통계', style: body1(gray8)))
              ],
              onChanged: (value) {
                setState(() {
                  _pieChartSelectedValue = value!;
                });
              },
              dropdownColor: Colors.white,
              style: body2(gray8),
              underline: Container(height: 0, color: Colors.transparent)),
          const SizedBox(height: 20.0),
          PieChartView(value: _pieChartSelectedValue, ledgers: ledgers),
          const SizedBox(height: 30)
        ],
      );
    });
  }
}
