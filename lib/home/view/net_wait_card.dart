import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';

class NetWaitCard extends StatelessWidget {
  const NetWaitCard({super.key});

  @override
  Widget build(BuildContext context) {
    final netRecords = Provider.of<NetRecordProvider>(context).netRecords;

    // isGet이 false인 레코드만 필터링
    final waitingRecords = netRecords.where((record) => !record.isGet).toList();

    if (waitingRecords.isEmpty) {
      return const Center(
        child: Text("양망 대기 중인 기록이 없습니다."),
      );
    }

    return Column(
      children: waitingRecords.map((record) {
        // 날짜 계산해서 몇 일 전인지 표시
        final daysSince = DateTime.now().difference(record.throwDate).inDays;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: double.infinity,
            height: 57,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/netPage1');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                backgroundColor: primaryBlue500,
                foregroundColor: Colors.white,
                overlayColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Row(
                children: [
                  Text('$daysSince 일 전', style: header4(Colors.white)),
                  const Spacer(),
                  Text(record.locationName, style: body1(Colors.white)),
                  const SizedBox(width: 7),
                  SvgPicture.asset('assets/icons/whiteArrow.svg'),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
