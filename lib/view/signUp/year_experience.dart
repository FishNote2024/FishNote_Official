import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  final String name = "지수";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<String> dropDownList = ['0~5년', '6~10년', '11년 이상'];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text('안녕하세요, ${widget.name}님!', style: header1B),
                const SizedBox(height: 8),
                Text('${widget.name}님의 만선을 위해 몇 가지 정보를 알려주세요.', style: body1),
                const SizedBox(height: 58),
                const Text('조업 경력을 선택해주세요', style: header3B),
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
                    hint: const Text('햇수를 선택해주세요', style: body1),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    value: dropdownValue,
                    items: dropDownList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: body1),
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
            NextButton(value: dropdownValue, route: '/ageRange'),
          ],
        ),
      ),
    );
  }
}
