import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/signUp/model/data_list.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageSpecies extends StatefulWidget {
  const MyPageSpecies({super.key});

  @override
  State<MyPageSpecies> createState() => _MyPageSpeciesState();
}

class _MyPageSpeciesState extends State<MyPageSpecies> {
  final TextEditingController _controller = TextEditingController();
  Set<String> selectedList = {};
  List<String> speciesList = [];
  late UserInformationProvider userInformationProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    selectedList = Set<String>.from(userInformationProvider.species);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('주요 어종 추가하기', style: body2()),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomButton(
          text: '수정 완료',
          value: selectedList.difference(userInformationProvider.species).isEmpty &&
                  userInformationProvider.species.difference(selectedList).isEmpty
              ? null
              : selectedList,
          onPressed: () {
            userInformationProvider.setSpecies(selectedList);
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('주 어종을 선택해주세요.', style: header3B()),
            const SizedBox(height: 16),
            TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              controller: _controller,
              cursorColor: primaryBlue500,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => setState(() {
                if (_controller.text.isNotEmpty) {
                  speciesList = [];
                  for (final item in fishList) {
                    if (item.contains(_controller.text)) {
                      speciesList.add(item);
                    }
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
                          selectedList.elementAt(index),
                          style: body3(Colors.white),
                        ),
                        onPressed: () => {
                          setState(() {
                            selectedList.remove(selectedList.elementAt(index));
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
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                    ),
                  ),
            const SizedBox(height: 23),
            _controller.text.isEmpty
                ? SizedBox(
                    height: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('어획량 순 top 10', style: body2(gray6)),
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
                                  child: Text(
                                    top10[index],
                                    style: selectedList.contains(top10[index])
                                        ? body1(primaryBlue500)
                                        : body1(),
                                  ),
                                ),
                                onTap: () => {
                                  setState(() {
                                    if (selectedList.length >= 5) {
                                      showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                                    } else {
                                      selectedList.add(top10[index]);
                                      print(selectedList);
                                    }
                                  }),
                                },
                              ),
                              separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(thickness: 1, color: gray1, height: 0),
                              ),
                              itemCount: top10.length,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('어종 리스트', style: body2(gray6)),
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
                                  child: Text(
                                    fishList[index],
                                    style: selectedList.contains(fishList[index])
                                        ? body1(primaryBlue500)
                                        : body1(),
                                  ),
                                ),
                                onTap: () => {
                                  setState(() {
                                    if (selectedList.length >= 5) {
                                      showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                                    } else {
                                      selectedList.add(fishList[index]);
                                    }
                                  }),
                                },
                              ),
                              separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(thickness: 1, color: gray1, height: 0),
                              ),
                              itemCount: fishList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('검색결과 ${speciesList.length}건', style: body2(gray6)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => {
                                setState(() {
                                  if (selectedList.length >= 5) {
                                    showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                                  } else {
                                    selectedList.add(speciesList[index]);
                                  }
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
                                child: Text(
                                  speciesList[index],
                                  style: selectedList.contains(speciesList[index])
                                      ? body1(primaryBlue500)
                                      : body1(),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemCount: speciesList.length,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
