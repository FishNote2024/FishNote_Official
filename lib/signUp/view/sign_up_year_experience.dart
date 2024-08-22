import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class SignUpYearExperience extends StatefulWidget {
  const SignUpYearExperience({super.key, required this.onNext});

  final String name = "지수";
  final VoidCallback onNext;

  @override
  State<SignUpYearExperience> createState() => _SignUpYearExperienceState();
}

class _SignUpYearExperienceState extends State<SignUpYearExperience> {
  List<String> dropDownList = ['0~5년', '6~10년', '11년 이상'];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NextButton(value: dropdownValue, onNext: widget.onNext),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text('안녕하세요, ${widget.name}님!', style: header1B()),
          const SizedBox(height: 8),
          Text('서비스 제공을 위해 몇 가지 정보를 알려주세요.', style: body1(gray6)),
          const SizedBox(height: 58),
          Text('조업 경력을 선택해주세요', style: header3B()),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                width: 1,
                color: dropdownValue == null ? gray2 : primaryBlue500,
              ),
            ),
            child: DropdownButton<String>(
              hint: Text('햇수를 선택해주세요', style: body1(gray3)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              underline: const SizedBox.shrink(),
              isExpanded: true,
              value: dropdownValue,
              items: dropDownList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: body1()),
                );
              }).toList(),
              onChanged: (value) => {
                setState(() {
                  dropdownValue = value;
                })
              },
            ),
          ),
        ],
      ),
    );
  }
}
