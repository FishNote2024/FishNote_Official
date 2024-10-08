import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/net/view/get_net/get_net_fish.dart';
import 'package:fish_note/net/view/get_net/get_net_fish_weight.dart';
import 'package:fish_note/net/view/get_net/get_net_note.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GetNetView extends StatefulWidget {
  final NetRecord? record;
  final List<String>? fishList;
  final String recordId;

  const GetNetView(
      {super.key, this.record, this.fishList, required this.recordId});

  @override
  State<GetNetView> createState() => _GetNetViewState();
}

class _GetNetViewState extends State<GetNetView> {
  int _currentPage = 1;
  final int _totalPages = 4;

  void _nextPage([List<String>? selectedFish]) {
    setState(() {
      if (_currentPage < _totalPages - 1) {
        _currentPage += 1;
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    if (_currentPage == 2 && selectedFish != null) {
      // 여기서 recordId를 GetNetFishWeight에 전달
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetNetFishWeight(
            onNext: _nextPage,
            recordId: widget.record!.id,
          ),
        ),
      );
    }
  }

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return GetNetFish(onNext: _nextPage, recordId: widget.record!.id);
      case 2:
        return GetNetFishWeight(onNext: _nextPage, recordId: widget.record!.id);
      case 3:
        return GetNetNote(onNext: _nextPage, recordId: widget.record!.id);
      default:
        return GetNetNote(onNext: _nextPage, recordId: widget.record!.id);
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
                if (_currentPage > 1) {
                  _currentPage -= 1; // 현재 페이지가 1보다 크면 페이지 감소
                } else {
                  // 현재 페이지가 1일 때
                  final netRecordProvider =
                      Provider.of<NetRecordProvider>(context, listen: false);
                  netRecordProvider.resetSpecies(); // 상태 초기화
                  Navigator.pop(context); // 페이지를 닫음
                }
              });
            },
          ),
          centerTitle: true,
          title: Text(
              '${DateFormat('MM월dd일(E)', 'ko_KR').format(DateTime.now())} 기록하기',
              style: body1(textBlack))),
      body: _currentPage != _totalPages - 1
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 6),
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
