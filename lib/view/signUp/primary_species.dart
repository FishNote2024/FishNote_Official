import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class PrimarySpecies extends StatefulWidget {
  const PrimarySpecies({super.key});

  @override
  State<PrimarySpecies> createState() => _PrimarySpeciesState();
}

class _PrimarySpeciesState extends State<PrimarySpecies> {
  final TextEditingController _controller = TextEditingController();
  List<String> selectedList = [];
  List<String> speciesList = [];
  List<String> top10 = [
    "가자미",
    "갈치",
    "감성돔",
    "광어",
    "노래미",
    "농어",
    "고등어",
    "방어",
    "우럭",
    "참돔"
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
            Text('정확한 계산을 위해\n조업 정보를 알려주세요!', style: header1B()),
            const SizedBox(height: 8),
            Text('조업일지, 조업장부 작성 이외에 사용되지 않아요.', style: body1(gray6)),
            const SizedBox(height: 19),
            Text('주 어종을 선택해주세요.', style: header3B()),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              cursorColor: primaryBlue500,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => setState(() {
                speciesList = [];
                for (int i = 0; i < top10.length; i++) {
                  if (top10[i].contains(_controller.text)) {
                    speciesList.add(top10[i]);
                  }
                }
              }),
              decoration: InputDecoration(
                filled: true,
                fillColor: backgroundWhite,
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
                hintText: '어종 이름을 입력해주세요',
                hintStyle: body1(gray3),
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Text('선택 내역', style: body2(gray6)),
            const SizedBox(height: 8),
            selectedList.isEmpty
                ? Text('아직 선택된 어종이 없어요', style: body2(gray2))
                : SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedList.length,
                      itemBuilder: (context, index) => TextButton.icon(
                        iconAlignment: IconAlignment.end,
                        label: Text(
                          selectedList[index],
                          style: body3(Colors.white),
                        ),
                        onPressed: () => {
                          setState(() {
                            selectedList.remove(selectedList[index]);
                          }),
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: primaryBlue500,
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                    ),
                  ),
            const SizedBox(height: 23),
            Expanded(
              child: _controller.text.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('어획량 순 top 10', style: body2(gray6)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  width: 1,
                                  color: gray2,
                                )),
                            child: ListView.separated(
                              itemBuilder: (context, index) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    top10[index],
                                    style: selectedList.contains(top10[index])
                                        ? body1(primaryBlue500)
                                        : body1(),
                                  ),
                                ),
                                onTap: () => {
                                  setState(() {
                                    selectedList.add(top10[index]);
                                  }),
                                },
                              ),
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                    thickness: 1, color: gray1, height: 0),
                              ),
                              itemCount: top10.length,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('검색결과 ${speciesList.length}건',
                            style: body1(gray6)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => {
                                setState(() {
                                  selectedList.add(speciesList[index]);
                                }),
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                    width: 1,
                                    color: primaryBlue100,
                                  ),
                                ),
                                child: Text(
                                  speciesList[index],
                                  style:
                                      selectedList.contains(speciesList[index])
                                          ? body1(primaryBlue500)
                                          : body1(),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: speciesList.length,
                          ),
                        ),
                      ],
                    ),
            ),
            NextButton(
                value: selectedList.isEmpty ? null : selectedList[0],
                route: '/fishingTechnique'),
          ],
        ),
      ),
    );
  }
}
