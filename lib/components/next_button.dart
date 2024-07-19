import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.value,
    required this.onNext,
  });

  final String? value;
  final VoidCallback onNext;

  void _showPermissionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/location.svg',
              colorFilter: const ColorFilter.mode(primaryBlue500, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 16),
            Text(
              '피시노트 권한 안내',
              style: header3B(),
            ),
            const SizedBox(height: 16),
            Text(
              '조업일지 작성, 현재 위치 조회를 위해\n위치 정보가 필수로 사용됩니다.',
              textAlign: TextAlign.center,
              style: body1(),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // 허용 버튼 클릭 시 동작 + @@권한 설정 기능@@
                Navigator.pop(context);
                onNext();
              },
              style: TextButton.styleFrom(
                foregroundColor: textBlack,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              ),
              child: Text('허용', style: header4()),
            ),
            TextButton(
              onPressed: () {
                // 허용 안함 버튼 클릭 시 동작
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: TextButton.styleFrom(
                foregroundColor: textBlack,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              ),
              child: Text('허용 안함', style: header4()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: value == ""
          ? () => _showPermissionModal(context)
          : value == null
              ? null
              : onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: value == null ? gray2 : primaryBlue500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text('다음', style: header3R(Colors.white)),
    );
  }
}
