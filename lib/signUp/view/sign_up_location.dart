import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpLocation extends StatefulWidget {
  const SignUpLocation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpLocation> createState() => _SignUpLocationState();
}

class _SignUpLocationState extends State<SignUpLocation> {
  String? location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('정확한 계산을 위해\n조업 정보를 알려주세요!', style: header1B()),
              const SizedBox(height: 8),
              Text('데이터 분석 이외에 다른 용도로 사용되지 않아요.', style: body1(gray6)),
              const SizedBox(height: 19),
              Text('주요 조업 위치를 지정해주세요', style: header3B()),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(color: primaryYellow500),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: backgroundWhite,
                            border: Border.all(
                              color: primaryBlue500,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text('위치', style: body2(gray4)),
                              const SizedBox(width: 10),
                              Text('$location', style: body2(textBlack)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              location = '현재 위치 좌표값 get';
                            }),
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/current_location.svg',
                            colorFilter: const ColorFilter.mode(primaryBlue500, BlendMode.srcIn),
                          ),
                          color: primaryBlue500,
                          iconSize: 18.5,
                          style: IconButton.styleFrom(
                            backgroundColor: backgroundWhite,
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: gray2,
                                width: 1,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    NextButton(value: location, onNext: widget.onNext),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
