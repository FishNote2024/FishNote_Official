import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class NextButton extends StatefulWidget {
  const NextButton({
    super.key,
    required this.value,
    required this.onNext,
  });

  final Object? value;
  final VoidCallback onNext;

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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(false);
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(false);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.value(false);
    }
    return Future.value(true);
  }

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

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: backgroundWhite,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '주요 조업 위치의 별명을 입력해주세요',
                style: header3B(),
              ),
              const SizedBox(height: 18),
              TextField(
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: _controller,
                cursorColor: primaryBlue500,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundWhite,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  hintText: '지역 별명을 입력해주세요',
                  hintStyle: body1(gray3),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _controller.text.isEmpty
                    ? () => {}
                    : () {
                        // 허용 안함 버튼 클릭 시 동작
                        Navigator.pop(context);
                        if (widget.value is List<double>) {
                          // 위치 정보 등록 로직 추가
                        }
                        // 별명 등록 로직 추가
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  backgroundColor: primaryBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('등록하기', style: header4(backgroundWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.value is List<double>
          ? () => _showLocationModal(context)
          : widget.value == "agree"
              ? () => _showPermissionModal(context)
              : widget.value == null || widget.value == ""
                  ? null
                  : widget.onNext,
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
