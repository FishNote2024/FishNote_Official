import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_add_fish.dart';
import 'package:fish_note/net/view/get_net/get_net_fish.dart';
import 'package:fish_note/net/view/get_net/get_net_note.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GetNetView extends StatefulWidget {
  final NetRecord record;
  const GetNetView({Key? key, required this.record}) : super(key: key);

  @override
  State<GetNetView> createState() => _GetNetViewState();
}

class _GetNetViewState extends State<GetNetView> {
  int _currentPage = 1;
  final int _totalPages = 4;

  void _nextPage() {
    setState(() {
      if (_currentPage < _totalPages - 1) {
        _currentPage += 1;
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return GetNetFish(onNext: _nextPage);
      case 2:
        return GetNetAddFish(onNext: _nextPage);
      case 3:
        return GetNetNote(onNext: _nextPage);
      default:
        return GetNetNote(onNext: _nextPage);
    }
  }

  void _handleNext(int caseNumber) {
    if (caseNumber == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetNetAddFish(
              onNext: _nextPage,
            ),
          ));
    } else if (caseNumber == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetNetNote(
              onNext: _nextPage,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: backgroundBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
            onPressed: () {
              setState(() {
                if (_currentPage > 0) {
                  _currentPage -= 1;
                } else {
                  Navigator.pop(context);
                }
              });
            },
          ),
          centerTitle: true,
          title: Text(
              '${DateFormat('MM월dd일(E)', 'ko_KR').format(widget.record.date)} 기록하기',
              style: body1(textBlack))),
      body: _currentPage != _totalPages - 1
          ? Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearPercentIndicator(
                    percent: _currentPage / (_totalPages - 1),
                    backgroundColor: primaryYellow50,
                    progressColor: primaryYellow500,
                    lineHeight: 4,
                    barRadius: const Radius.circular(4),
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                  Expanded(
                    child: _getPage(),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearPercentIndicator(
                    percent: _currentPage / (_totalPages - 1),
                    backgroundColor: primaryYellow50,
                    progressColor: primaryYellow500,
                    lineHeight: 4,
                    barRadius: const Radius.circular(4),
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                ),
                Expanded(
                  child: _getPage(),
                ),
              ],
            ),
    );
  }
}
