import 'package:fish_note/login/view/kakao_login.dart';
import 'package:fish_note/login/view/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    height: 150,
                  ),
                ],
              ),
              const SizedBox(height: 51),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 115),
              child: Text('오늘도 만선하기 위해', style: header3R()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: viewModel.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryYellow400,
                  minimumSize: const Size(328, 51),
                  textStyle: header3R(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0), // 직각 모서리
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/kakao_talk.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                    const Text(
                      '카카오 아이디로 시작하기',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}