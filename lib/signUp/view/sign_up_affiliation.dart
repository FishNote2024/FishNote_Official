import 'dart:convert';

import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/user_information_provider.dart';

class SignUpAffiliation extends StatefulWidget {
  const SignUpAffiliation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpAffiliation> createState() => _SignUpAffiliationState();
}

class _SignUpAffiliationState extends State<SignUpAffiliation> {
  final TextEditingController _controller = TextEditingController();
  String? affiliation;
  late Future<List<dynamic>> affiliations;
  List<String> searchResult = [];
  bool isSearch = false;

  Future<List<dynamic>> loadJsonData() async {
    // JSON 파일 읽기
    String jsonString = await rootBundle.loadString('assets/data/members_combination.json');

    // JSON 디코딩
    List<dynamic> jsonData = json.decode(jsonString);

    return jsonData;
  }

  @override
  void initState() {
    super.initState();
    affiliations = loadJsonData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInformationProvider = Provider.of<UserInformationProvider>(context);
    final loginModelProvider = Provider.of<LoginModelProvider>(context);

    return Scaffold(
      bottomNavigationBar: NextButton(
        value: affiliation,
        onNext: widget.onNext,
        save: () =>
            userInformationProvider.setAffiliation(affiliation!, loginModelProvider.kakaoId),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('소속 정보를 설정하세요!', style: header1B()),
            const SizedBox(height: 8),
            Text('위판장 시세와 내 사업성과를 확인할 수 있어요.', style: body1(gray6)),
            const SizedBox(height: 58),
            Text('소속된 수협 조합을 선택해주세요', style: header3B()),
            const SizedBox(height: 16),
            FutureBuilder<List<dynamic>>(
                future: affiliations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<dynamic> items = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          controller: _controller,
                          cursorColor: primaryBlue500,
                          readOnly: affiliation != null,
                          style: TextStyle(
                              color: _controller.text == affiliation ? Colors.white : Colors.black),
                          onChanged: (value) => setState(() {
                            if (_controller.text.isNotEmpty) {
                              searchResult = [];
                              for (final item in items) {
                                if (item['unionName'].contains(_controller.text)) {
                                  searchResult.add(item['unionName']);
                                }
                              }
                              isSearch = true;
                            } else {
                              isSearch = false;
                            }
                          }),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                _controller.text == affiliation ? primaryBlue500 : backgroundWhite,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: _controller.text.isEmpty ? gray2 : primaryBlue500,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: _controller.text.isEmpty ? gray2 : primaryBlue500,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            hintText: '조합 이름을 입력해주세요',
                            hintStyle: body1(gray3),
                            contentPadding: const EdgeInsets.all(16),
                            suffixIcon: _controller.text == affiliation
                                ? IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    color: Colors.white,
                                    onPressed: () => {
                                      setState(() {
                                        _controller.text = "";
                                        affiliation = null;
                                        isSearch = false;
                                      }),
                                    },
                                  )
                                : const Icon(Icons.search_rounded),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 340,
                          child: isSearch
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('검색결과 ${searchResult.length}건', style: body1(gray6)),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => InkWell(
                                          onTap: () => {
                                            setState(() {
                                              if (affiliation == null) {
                                                affiliation = searchResult[index];
                                                _controller.text = searchResult[index];
                                              } else {
                                                showSnackBar(context,
                                                    "수협 조합은 한 곳만 설정할 수 있어요.\n소속 조협을 변경하고 싶다면 선택 내역을\n취소하고 다시 선택해주세요.");
                                              }
                                            }),
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(Radius.circular(5)),
                                              color: backgroundWhite,
                                              border: Border.all(
                                                width: 1,
                                                color: primaryBlue100,
                                              ),
                                            ),
                                            child: Text(searchResult[index], style: body1(gray6)),
                                          ),
                                        ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 8),
                                        itemCount: searchResult.length,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('전국 수협 리스트', style: body2(gray6)),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(Radius.circular(4)),
                                            color: backgroundWhite,
                                            border: Border.all(
                                              width: 1,
                                              color: gray2,
                                            )),
                                        child: ListView.separated(
                                          itemBuilder: (context, index) => InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                items[index]['unionName'],
                                                style: affiliation == items[index]['unionName']
                                                    ? body1(primaryBlue500)
                                                    : body1(),
                                              ),
                                            ),
                                            onTap: () => {
                                              setState(() {
                                                if (affiliation == null) {
                                                  affiliation = items[index]['unionName'];
                                                  _controller.text = items[index]['unionName'];
                                                } else {
                                                  showSnackBar(context,
                                                      "수협 조합은 한 곳만 설정할 수 있어요.\n소속 조협을 변경하고 싶다면 선택 내역을\n취소하고 다시 선택해주세요.");
                                                }
                                              }),
                                            },
                                          ),
                                          separatorBuilder: (context, index) => const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Divider(thickness: 1, color: gray1, height: 0),
                                          ),
                                          itemCount: items.length,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
