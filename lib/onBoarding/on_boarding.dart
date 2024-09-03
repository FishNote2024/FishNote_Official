import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/font.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _pageTimer;
  Timer? _buttonTimer;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _startPageTimer();
  }

  void _startPageTimer() {
    _pageTimer?.cancel();
    _pageTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int nextPage = _pageController.page!.round() + 1;

      if (nextPage == 3) {
        _pageTimer?.cancel();
        _startButtonTimer(); // 마지막 페이지에서는 3초 뒤에 버튼 나타나도록
      } else {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startButtonTimer() {
    _buttonTimer?.cancel();
    _buttonTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showButton = true;
      });
    });
  }

  @override
  void dispose() {
    _pageTimer?.cancel();
    _buttonTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _pageTimer?.cancel(); // 페이지가 바뀔 때마다 타이머를 리셋
              setState(() {
                _showButton = false; // 페이지 변경 시 버튼 숨기기
              });
              if (page == 2) {
                _startButtonTimer(); // 마지막 페이지에서 3초 뒤에 버튼이 나타나도록
              } else {
                _startPageTimer();
              }
            },
            children: [
              buildPage(context, 'assets/icons/onboarding1.png', 1),
              buildPage(context, 'assets/icons/onboarding2.png', 2),
              buildPage(context, 'assets/icons/onboarding3.png', 3),
            ],
          ),
          if (_showButton)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Text(
                      '피시노트 시작하기',
                      style: header3R(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, String imagePath, int pageIndex) {
    return GestureDetector(
      onTap: () {
        if (pageIndex < 3) {
          _pageController.animateToPage(
            pageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        _startPageTimer(); // 터치 후 타이머 재시작
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
