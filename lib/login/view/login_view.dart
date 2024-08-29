import 'package:fish_note/login/view/kakao_login.dart';
import 'package:fish_note/login/view/main_view_model.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../model/login_model_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    final loginModelProvider = Provider.of<LoginModelProvider>(context);
    final userInformationProvider = Provider.of<UserInformationProvider>(context);

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
                onPressed: () async {
                  await viewModel.login();
                  if (viewModel.user != null) {
                    // 카카오 로그인 성공
                    loginModelProvider
                        .setName(viewModel.user?.kakaoAccount?.profile?.nickname ?? "guest");
                    loginModelProvider.setKakaoId(viewModel.user!.id.toString());
                    // 사용자 정보를 가져온다.
                    await userInformationProvider.init(loginModelProvider.kakaoId);
                    // 주요 조업 위치의 이름이 있는 경우 -> 회원가입이 완료되었다는 의미이므로 홈 화면으로 이동
                    if (userInformationProvider.location.name != '') {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    } else {
                      // 사용자 이름 저장
                      loginModelProvider.saveName();
                      // 주요 조업 위치의 이름이 없는 경우 -> 회원가입이 아직 완료되지 않았다는 의미이므로 회원가입 화면으로 이동
                      Navigator.pushNamedAndRemoveUntil(context, '/signUp', (route) => false);
                    }
                  } else {
                    print('Login failed or user is null');
                  }
                },
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
