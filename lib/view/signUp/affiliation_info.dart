import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class AffiliationInfo extends StatefulWidget {
  const AffiliationInfo({super.key});

  @override
  State<AffiliationInfo> createState() => _AffiliationInfoState();
}

class _AffiliationInfoState extends State<AffiliationInfo> {
  final TextEditingController _controller = TextEditingController();
  String? name;
  String text = "";
  List<String> affiliation = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text('소속 정보를 설정하세요!', style: header1B),
                  const SizedBox(height: 8),
                  const Text('경락시세, 위판내역 등을 바로 보실 수 있어요!', style: body1),
                  const SizedBox(height: 58),
                  const Text('소속된 수협 조합을 검색하여 선택해주세요', style: header3B),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    cursorColor: primaryBlue500,
                    readOnly: name != null,
                    style: TextStyle(
                        color: _controller.text == name
                            ? Colors.white
                            : Colors.black),
                    onChanged: (value) => name == null
                        ? setState(() {
                            text = _controller.text;
                          })
                        : null,
                    onSubmitted: (value) => {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _controller.text == name
                          ? primaryBlue500
                          : backgroundWhite,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color:
                              _controller.text == "" ? gray2 : primaryBlue500,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: primaryBlue500,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color:
                              _controller.text == "" ? gray2 : primaryBlue500,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      hintText: '조합 이름을 입력해주세요',
                      hintStyle: body1,
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: _controller.text == name
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded),
                              color: Colors.white,
                              onPressed: () => {
                                setState(() {
                                  _controller.text = "";
                                  name = null;
                                }),
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _controller.text == ""
                                  ? null
                                  : () => {
                                        setState(() {
                                          affiliation.add(_controller.text);
                                        }),
                                      },
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('검색결과 ${affiliation.length}건', style: body1),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => {
                          setState(() {
                            name = affiliation[index];
                            _controller.text = affiliation[index];
                          }),
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              width: 1,
                              color: primaryBlue100,
                            ),
                          ),
                          child: Text(affiliation[index], style: body1),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: affiliation.length,
                    ),
                  ),
                ],
              ),
            ),
            NextButton(value: name, route: '/affiliationInfo'),
          ],
        ),
      ),
    );
  }
}
