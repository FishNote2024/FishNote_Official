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
  String? affiliation;
  List<String> affiliations = ["완즈이", "완즈이 르끼비끼니시티자나?"];
  List<String> searchResult = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('소속 정보를 설정하세요!', style: header1B),
                  const SizedBox(height: 8),
                  Text('경락시세, 위판내역 등을 바로 보실 수 있어요!', style: body1.copyWith(color: gray6)),
                  const SizedBox(height: 58),
                  const Text('소속된 수협 조합을 검색하여 선택해주세요', style: header3B),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    cursorColor: primaryBlue500,
                    readOnly: affiliation != null,
                    style: TextStyle(
                        color: _controller.text == affiliation ? Colors.white : Colors.black),
                    onChanged: (value) => setState(() {
                      searchResult = [];
                      for (int i = 0; i < affiliations.length; i++) {
                        if (affiliations[i].contains(_controller.text)) {
                          searchResult.add(affiliations[i]);
                        }
                      }
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _controller.text == affiliation ? primaryBlue500 : backgroundWhite,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: _controller.text.isEmpty ? gray2 : primaryBlue500,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                          color: _controller.text.isEmpty ? gray2 : primaryBlue500,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      hintText: '조합 이름을 입력해주세요',
                      hintStyle: body1.copyWith(color: gray3),
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: _controller.text == affiliation
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded),
                              color: Colors.white,
                              onPressed: () => {
                                setState(() {
                                  _controller.text = "";
                                  affiliation = null;
                                }),
                              },
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('검색결과 ${searchResult.length}건', style: body1.copyWith(color: gray6)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => {
                          setState(() {
                            affiliation = searchResult[index];
                            _controller.text = searchResult[index];
                          }),
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              width: 1,
                              color: primaryBlue100,
                            ),
                          ),
                          child: Text(searchResult[index], style: body1.copyWith(color: gray6)),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemCount: searchResult.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            NextButton(value: affiliation, route: '/primarySpecies'),
          ],
        ),
      ),
    );
  }
}
