import 'dart:convert';

import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyPageAffiliation extends StatefulWidget {
  const MyPageAffiliation({super.key});

  @override
  State<MyPageAffiliation> createState() => _MyPageAffiliationState();
}

class _MyPageAffiliationState extends State<MyPageAffiliation> {
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
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('소속 조합 수정하기', style: body2()),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomButton(
        text: '수정 완료',
        value: affiliation == userInformationProvider.affiliation ? null : affiliation,
        onPressed: () {
          userInformationProvider.setAffiliation(affiliation!, loginModelProvider.kakaoId);
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('소속된 수협 조합을 검색하여 선택해주세요', style: header3B()),
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
                                : const Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 700,
                          child: Column(
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
                                      child: Text(searchResult[index], style: body1(gray6)),
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
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
