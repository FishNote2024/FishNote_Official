import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class MyPageWithdrawal extends StatefulWidget {
  const MyPageWithdrawal({super.key});

  @override
  State<MyPageWithdrawal> createState() => _MyPageWithdrawalState();
}

class _MyPageWithdrawalState extends State<MyPageWithdrawal> {
  bool _fullAgree = false;
  bool _serviceAgree = false;
  bool _privacyAgree = false;
  bool _locationAgree = false;
  bool _ageAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('회원 탈퇴', style: body2()),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomButton(
        text: "탈퇴하기",
        value: _fullAgree ? "agree" : null,
        onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text("탈퇴 전 안내사항", style: header1B()),
            const SizedBox(height: 48),
            CheckboxListTile(
              title: const Text("전체 약관에 동의합니다"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: gray2),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              checkColor: backgroundWhite,
              activeColor: primaryBlue500,
              value: _fullAgree,
              onChanged: (value) => {
                setState(() {
                  _serviceAgree = value!;
                  _privacyAgree = value;
                  _locationAgree = value;
                  _ageAgree = value;
                  _fullAgree = value;
                })
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => {
                    setState(() {
                      _serviceAgree = !_serviceAgree;
                      _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                    }),
                  },
                  label: Text("서비스 이용약관 (필수)", style: body2(gray8)),
                  icon: Icon(Icons.check_rounded, color: _serviceAgree ? primaryBlue400 : gray2),
                ),
                TextButton(onPressed: () => {}, child: Text("보기", style: caption1(gray5))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => {
                    setState(() {
                      _privacyAgree = !_privacyAgree;
                      _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                    }),
                  },
                  label: Text("개인정보 처리방침 (필수)", style: body2(gray8)),
                  icon: Icon(Icons.check_rounded, color: _privacyAgree ? primaryBlue400 : gray2),
                ),
                TextButton(onPressed: () => {}, child: Text("보기", style: caption1(gray5))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => {
                    setState(() {
                      _locationAgree = !_locationAgree;
                      _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                    }),
                  },
                  label: Text("위치정보 서비스 이용약관 (필수)", style: body2(gray8)),
                  icon: Icon(Icons.check_rounded, color: _locationAgree ? primaryBlue400 : gray2),
                ),
                TextButton(onPressed: () => {}, child: Text("보기", style: caption1(gray5))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => {
                    setState(() {
                      _ageAgree = !_ageAgree;
                      _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                    }),
                  },
                  label: Text("만 14세 이상입니다 (필수)", style: body2(gray8)),
                  icon: Icon(Icons.check_rounded, color: _ageAgree ? primaryBlue400 : gray2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
