import 'package:fish_note/home/view/ledger/ledger_page.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

import 'market_price_table.dart';

class LedgerTabBarView extends StatefulWidget {
  const LedgerTabBarView({super.key});

  @override
  _LedgerTabBarViewState createState() => _LedgerTabBarViewState();
}

class _LedgerTabBarViewState extends State<LedgerTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        title: Text('조업 장부', style: body2(textBlack)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          labelStyle: header4(primaryBlue500),
          unselectedLabelStyle: TextStyle(color: gray5),
          indicatorWeight: 1,
          indicatorColor: primaryBlue500,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: '위판장부'),
            Tab(text: '경락시세'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            LedgerPage(),
            const Center(child: MarketPrice()),
          ],
        ),
      ),
    );
  }
}
