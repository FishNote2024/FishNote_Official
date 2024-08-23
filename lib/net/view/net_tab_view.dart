import 'package:fish_note/net/view/get_net/get_net_page.dart';
import 'package:fish_note/net/view/throw_net/throw_net_page.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:intl/intl.dart';
import '../../home/view/ledger/ledger_page.dart';

class NetTabBarView extends StatefulWidget {
  final int initialTabIndex;
  const NetTabBarView({super.key, required this.initialTabIndex});

  @override
  _NetTabBarViewState createState() => _NetTabBarViewState();
}

class _NetTabBarViewState extends State<NetTabBarView>
    with SingleTickerProviderStateMixin {
  String todayDate = DateFormat('M월 d일 (E)', 'ko_KR').format(DateTime.now());
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
        title: Text("${todayDate} 기록하기", style: body2(textBlack)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            Tab(text: '양망 전'),
            Tab(text: '양망 후'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TabBarView(
          controller: _tabController,
          children: [GetNetPage(), ThrowNetPage()],
        ),
      ),
    );
  }
}
