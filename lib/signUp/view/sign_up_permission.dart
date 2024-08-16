import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPermission extends StatefulWidget {
  const SignUpPermission({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpPermission> createState() => _SignUpPermissionState();
}

class _SignUpPermissionState extends State<SignUpPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NextButton(value: "", onNext: widget.onNext),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text('피시노트는 기록을 위해\n아래 권한이 필요해요', style: header1B()),
          const SizedBox(height: 8),
          Text('권한을 허용하지 않으면\n피시노트의 해상지도 기능을 사용하실 수 없습니다.', style: body1(gray6)),
          const SizedBox(height: 38),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SvgPicture.asset(
                      'assets/icons/location.svg',
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('위치', style: header3B()),
                      const SizedBox(height: 4),
                      Text('조업 일지 작성, 현재 위치 조회를 위해\n위치 정보가 필수로 사용됩니다', style: body2()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
