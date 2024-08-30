import 'package:fish_note/login/view/kakao_login.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/view/main_view_model.dart';

Future<void> _clear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // 모든 저장된 데이터를 삭제
}

Widget buildLogoutDialog(BuildContext context) {
  final viewModel = MainViewModel(KakaoLogin());

  return AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    title: Text('로그아웃하시겠습니까?', style: header3B()),
    content: Text('가입된 카카오 ID로 다시 로그인 가능합니다.', style: body2(gray6)),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // 다이얼로그 닫기
        },
        child: Text('취소하기', style: body2(primaryBlue500)),
      ),
      TextButton(
        onPressed: () async {
          // 로그아웃 로직 추가
          _clear();
          viewModel.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // 다이얼로그 닫기
        },
        child: Text('로그아웃', style: body2(primaryBlue500)),
      ),
    ],
  );
}
