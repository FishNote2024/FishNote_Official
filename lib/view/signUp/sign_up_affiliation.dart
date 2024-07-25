import 'dart:convert';

import 'package:fish_note/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('소속 정보를 설정하세요!', style: header1B()),
              const SizedBox(height: 8),
              Text('경락시세, 위판내역 등을 바로 보실 수 있어요!', style: body1(gray6)),
              const SizedBox(height: 58),
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
                      return TextField(
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
                                    }),
                                  },
                                )
                              : const Icon(Icons.search),
                        ),
                      );
                    }
                  }),
              const SizedBox(height: 20),
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
              const SizedBox(height: 16),
            ],
          ),
        ),
        NextButton(value: affiliation, onNext: widget.onNext),
      ],
    );
  }
}
