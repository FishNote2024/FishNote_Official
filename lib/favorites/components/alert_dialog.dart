import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

Widget buildRemoveFavoriteDialog(BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    title: Text('즐겨찾기에서 제거하시겠습니까?', style: header3B()),
    content: Text('즐겨찾기 목록이 변경됩니다.', style: body2(gray6)),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // 다이얼로그 닫기
        },
        child: Text('유지하기', style: body2(primaryBlue500)),
      ),
      TextButton(
        onPressed: () {
          // 제거 로직 추가
          Navigator.of(context).pop(); // 다이얼로그 닫기
        },
        child: Text('제거하기', style: body2(primaryBlue500)),
      ),
    ],
  );
}

Widget buildLocationDialog(BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    title: Text('주요 조업 위치로 지정하시겠습니까?', style: header3B()),
    content: Text('기존에 설정된 주요 조업 위치가 변경됩니다.', style: body2(gray6)),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // 다이얼로그 닫기
        },
        child: Text('유지하기', style: body2(primaryBlue500)),
      ),
      TextButton(
        onPressed: () {
          // 제거 로직 추가
          Navigator.of(context).pop(); // 다이얼로그 닫기
        },
        child: Text('변경하기', style: body2(primaryBlue500)),
      ),
    ],
  );
}
