import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class FishingTechnique extends StatefulWidget {
  const FishingTechnique({super.key});

  @override
  State<FishingTechnique> createState() => _FishingTechniqueState();
}

class _FishingTechniqueState extends State<FishingTechnique> {
  final TextEditingController _controller = TextEditingController();
  bool isNotSearch = true;
  String? technique;
  List<String> searchResult = [];
  List<String> primaryTechniques = [
    "가자미어업",
    "건간망 어업",
    "기선권현망 어업",
    "기타통발 어업",
    "끌낚시 어업",
    "낭장망 어업",
    "문어단지 어업",
    "미역어업",
    "방치망 어업",
    "병어 어업",
    "선망 어업",
    "새우조망 어업",
    "안강망 어업",
    "자망 어업",
    "자리돔들망 어업",
    "쌍끌이 기선저인망 어업",
    "연승 어업",
    "외끌이 기선저인망 어업",
    "외줄낚시 어업",
    "패류껍질 어업",
    "트롤 어업",
    "정치망 어업",
    "초망 어업",
    "죽방렴 어업",
    "주목망 어업",
    "장어통발 어업"
  ];

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
          children: [
            const Text('정확한 계산을 위해\n조업 정보를 알려주세요!', style: header1B),
            const SizedBox(height: 8),
            Text('조업일지, 조업장부 작성 이외에 사용되지 않아요.', style: body1.copyWith(color: gray6)),
            const SizedBox(height: 19),
            const Text('주로 사용하는 어법을 선택해주세요', style: header3B),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              cursorColor: primaryBlue500,
              readOnly: technique != null,
              style: TextStyle(color: _controller.text == technique ? Colors.white : Colors.black),
              onChanged: (value) => setState(() {
                searchResult = [];
                for (int i = 0; i < primaryTechniques.length; i++) {
                  if (primaryTechniques[i].contains(_controller.text)) {
                    searchResult.add(primaryTechniques[i]);
                  }
                }

                if (_controller.text.isEmpty) {
                  isNotSearch = true;
                } else {
                  isNotSearch = false;
                }
              }),
              decoration: InputDecoration(
                filled: true,
                fillColor: _controller.text == technique ? primaryBlue500 : backgroundWhite,
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
                hintText: '어법 이름을 입력해주세요',
                hintStyle: body1.copyWith(color: gray3),
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: _controller.text == technique
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.white,
                        onPressed: () => {
                          setState(() {
                            _controller.text = "";
                            isNotSearch = true;
                            technique = null;
                          }),
                        },
                      )
                    : const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isNotSearch
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주요 어법', style: body2.copyWith(color: gray6)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  width: 1,
                                  color: gray2,
                                )),
                            child: ListView.separated(
                              itemBuilder: (context, index) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(primaryTechniques[index], style: body1),
                                ),
                                onTap: () => {
                                  setState(() {
                                    technique = primaryTechniques[index];
                                    _controller.text = primaryTechniques[index];
                                  }),
                                },
                              ),
                              separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(thickness: 1, color: gray1, height: 0),
                              ),
                              itemCount: primaryTechniques.length,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('검색결과 ${searchResult.length + 1}건',
                            style: body1.copyWith(color: gray6)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => {
                            setState(() {
                              technique = _controller.text;
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_controller.text,
                                    style: body1.copyWith(color: primaryBlue500)),
                                Text('어법 새로 추가하기', style: body3.copyWith(color: gray5)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => {
                                setState(() {
                                  technique = searchResult[index];
                                  _controller.text = primaryTechniques[index];
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
                                child: Text(searchResult[index], style: body1),
                              ),
                            ),
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemCount: searchResult.length,
                          ),
                        ),
                      ],
                    ),
            ),
            NextButton(value: technique, route: '/primarySpecies'),
          ],
        ),
      ),
    );
  }
}
