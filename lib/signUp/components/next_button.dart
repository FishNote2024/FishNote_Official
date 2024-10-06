import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class NextButton extends StatefulWidget {
  const NextButton({
    super.key,
    required this.value,
    required this.onNext,
    required this.save,
  });

  final Object? value;
  final VoidCallback onNext;
  final VoidCallback save;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _determinePermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    location.enableBackgroundMode(enable: false);

    // 서비스가 가능한지 확인하는 코드
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.value(false);
      }
    }

    // 사용자의 허락이 떨어졌는지 확인하는 코드
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.value(false);
      }
    }

    return Future.value(true);
  }

  void showPermissionModal(BuildContext context) {
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
              '위치정보 권한 안내',
              style: header3B(),
            ),
            const SizedBox(height: 16),
            Text(
              '기상, 해상, 지도 서비스 제공을 위해\n위치정보 권한이 필요합니다.',
              textAlign: TextAlign.center,
              style: body1(),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                // 허용 버튼 클릭 시 동작 + @@권한 설정 기능@@
                Navigator.pop(context);
                await _determinePermission();
                widget.onNext();
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
      onPressed: widget.value == "agree"
          ? () => showPermissionModal(context)
          : widget.value == null || widget.value == ""
              ? null
              : () {
                  widget.save();
                  widget.onNext();
                },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.value == null || widget.value == "" ? gray2 : primaryBlue500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(widget.value == "" || widget.value == "agree" ? "동의하고 가입하기" : '다음',
          style: header3R(Colors.white)),
    );
  }
}
