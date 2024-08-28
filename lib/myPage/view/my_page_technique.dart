import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/signUp/model/data_list.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageTechnique extends StatefulWidget {
  const MyPageTechnique({super.key});

  @override
  State<MyPageTechnique> createState() => _MyPageTechniqueState();
}

class _MyPageTechniqueState extends State<MyPageTechnique> {
  final TextEditingController _controller = TextEditingController();
  bool isNotSearch = true;
  Set<String> selectedList = {};
  List<String> searchResult = [];
  late UserInformationProvider userInformationProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    selectedList = Set<String>.from(userInformationProvider.technique);
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
        title: Text('주요 어법 추가하기', style: body2()),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomButton(
        text: '수정 완료',
        value: selectedList.difference(userInformationProvider.technique).isEmpty &&
                userInformationProvider.technique.difference(selectedList).isEmpty
            ? null
            : selectedList,
        onPressed: () {
          userInformationProvider.setTechnique(selectedList);
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('주로 사용하는 어법을 선택해주세요', style: header3B()),
            const SizedBox(height: 16),
            TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              controller: _controller,
              cursorColor: primaryBlue500,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => setState(() {
                if (_controller.text.isEmpty) {
                  isNotSearch = true;
                } else {
                  isNotSearch = false;
                  searchResult = [];
                  for (final item in primaryTechniques) {
                    if (item.contains(_controller.text)) {
                      searchResult.add(item);
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
                hintText: '어법 이름을 입력해주세요',
                hintStyle: body1(gray3),
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Text('선택 내역', style: body2(gray6)),
            const SizedBox(height: 8),
            selectedList.isEmpty
                ? Text('아직 선택된 어법이 없어요', style: body2(gray2))
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
            SizedBox(
              height: 400,
              child: isNotSearch
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주요 어법', style: body2(gray6)),
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
                                  child: Text(primaryTechniques[index],
                                      style: selectedList.contains(primaryTechniques[index])
                                          ? body1(primaryBlue500)
                                          : body1()),
                                ),
                                onTap: () => {
                                  setState(() {
                                    if (selectedList.length >= 5) {
                                      showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                                    } else {
                                      selectedList.add(primaryTechniques[index]);
                                    }
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
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('검색결과 ${searchResult.length + 1}건', style: body2(gray6)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => {
                            setState(() {
                              if (selectedList.length >= 5) {
                                showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                              } else {
                                selectedList.add(_controller.text);
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_controller.text,
                                    style: selectedList.contains(_controller.text)
                                        ? body1(primaryBlue500)
                                        : body1()),
                                Text('어법 새로 추가하기', style: body3(gray5)),
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
                                  if (selectedList.length >= 5) {
                                    showSnackBar(context, '최대 5개까지 선택 가능합니다.');
                                  } else {
                                    selectedList.add(searchResult[index]);
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
                                child: Text(searchResult[index],
                                    style: selectedList.contains(searchResult[index])
                                        ? body1(primaryBlue500)
                                        : body1()),
                              ),
                            ),
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemCount: searchResult.length,
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
