import 'package:fish_note/home/view/ledger/wholesale_ledger/ledger_page.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'auction_price/market_price_table.dart';

class LedgerTabBarView extends StatefulWidget {
  final int initialTabIndex;
  const LedgerTabBarView({super.key, required this.initialTabIndex});

  @override
  _LedgerTabBarViewState createState() => _LedgerTabBarViewState();
}

class _LedgerTabBarViewState extends State<LedgerTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
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
          children: [LedgerPage(), MarketPriceTable()],
        ),
      ),
    );
  }
}
