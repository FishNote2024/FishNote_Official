import 'package:encrypt_shared_preferences/provider.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/login/view/kakao_login.dart';
import 'package:fish_note/login/view/main_view_model.dart';
import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageWithdrawal extends StatefulWidget {
  const MyPageWithdrawal({super.key});

  @override
  State<MyPageWithdrawal> createState() => _MyPageWithdrawalState();
}

class _MyPageWithdrawalState extends State<MyPageWithdrawal> {
  bool _agree = false;
  final viewModel = MainViewModel(KakaoLogin());

  Future<void> _withdrawal() async {
    final userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    final ledgerProvider = Provider.of<LedgerProvider>(context, listen: false);
    final netRecordProvider = Provider.of<NetRecordProvider>(context, listen: false);
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences.getInstance();
    String id = prefs.getString('uid')!;
    await viewModel.logout();
    await ledgerProvider.withDrawal(id);
    await netRecordProvider.withDrawal(id);
    await userInformationProvider.withDrawal(id);
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
      ),
      bottomNavigationBar: BottomButton(
        text: "탈퇴하기",
        value: _agree ? "agree" : null,
        onPressed: () async {
          await _withdrawal();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text("탈퇴 전 안내사항", style: header1B()),
            const SizedBox(height: 16),
            const Divider(color: gray2),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. 탈퇴한 계정의 모든 기록은 탈퇴 직후\n모두 파기되며 복구되지 않습니다.", style: body1()),
                  const SizedBox(height: 24),
                  Text("2. 피시노트 앱 회원 탈퇴 후 재가입을 원하는 경우\n카카오톡 간편로그인을 통해 재가입 가능합니다.", style: body1()),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("탈퇴 전 안내사항을 모두 확인했습니다.", style: body1()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: gray2),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              checkColor: backgroundWhite,
              activeColor: primaryBlue500,
              value: _agree,
              onChanged: (value) => {
                setState(() {
                  _agree = value!;
                })
              },
            ),
          ],
        ),
      ),
    );
  }
}
