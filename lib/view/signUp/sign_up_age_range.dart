import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class SignUpAgeRange extends StatefulWidget {
  const SignUpAgeRange({super.key});

  final String name = "지수";

  @override
  State<SignUpAgeRange> createState() => _SignUpAgeRangeState();
}

class _SignUpAgeRangeState extends State<SignUpAgeRange> {
  List<String> dropDownList = ['20대 이하', '30대', '40대', '50대', '60대', '70대 이상'];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
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
                Text('안녕하세요, ${widget.name}님!', style: header1B),
                const SizedBox(height: 8),
                Text('${widget.name}님의 만선을 위해 몇 가지 정보를 알려주세요.',
                    style: body1.copyWith(color: gray6)),
                const SizedBox(height: 58),
                const Text('연령대를 선택해주세요', style: header3B),
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
                    hint: Text('나이대를 선택해주세요', style: body1.copyWith(color: gray3)),
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
            NextButton(value: dropdownValue, route: '/affiliationInfo'),
          ],
        ),
      ),
    );
  }
}
