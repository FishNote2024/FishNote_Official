import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/net_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/signUp/model/data_list.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GetNetAddFish extends StatefulWidget {
  final String recordId;
  final Set<String> initialSelectedSpecies;
  const GetNetAddFish({
    super.key,
    required this.recordId,
    required this.initialSelectedSpecies, // 추가
  });
  @override
  State<GetNetAddFish> createState() => _GetNetAddFishState();
}

class _GetNetAddFishState extends State<GetNetAddFish> {
  final TextEditingController _controller = TextEditingController();
  Set<String> selectedList = {};
  List<String> speciesList = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 현재 선택된 어종을 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 이전 화면에서 전달된 어종만을 사용하도록 초기화
      selectedList = widget.initialSelectedSpecies.toSet();
      // 선택 목록이 업데이트되면 UI가 반영되도록 상태를 업데이트
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final netRecordProvider = Provider.of<NetRecordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const NetTabBarView(initialTabIndex: 0)));
          },
        ),
        centerTitle: true,
        title: Text(
          '${DateFormat('MM월dd일(E)', 'ko_KR').format(DateTime.now())} 기록하기',
          style: body1(textBlack),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedList.isNotEmpty
              ? () {
                  print("👉🏻 selectedList: $selectedList");
                  setState(() {
                    speciesList = selectedList.toList();
                  });
                  print("👉🏻 speciesList: $speciesList");
                  netRecordProvider.setSpecies(selectedList);
                  print(
                      "👉🏻 netRecordProvider.species: ${netRecordProvider.species}");
                  Navigator.pop(context, widget.recordId);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedList.isEmpty ? gray2 : primaryBlue500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('다음', style: header1B(Colors.white)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('어종을 모두 선택해주세요', style: header1B()),
              const SizedBox(height: 8),
              Text(
                '오늘 어획한 어종을 모두 선택해주세요.\n리스트에 없는 어종은 추가하여 선택 가능합니다.',
                style: body1(gray6),
              ),
              const SizedBox(height: 19),
              Text('주 어종을 선택해주세요.', style: header3B()),
              const SizedBox(height: 16),
              TextField(
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
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
                              selectedList
                                  .remove(selectedList.elementAt(index));
                              netRecordProvider.setSpecies(selectedList);
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  width: 1,
                                  color: gray2,
                                ),
                              ),
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
                                        showSnackBar(
                                            context, '어종은 5개까지 선택 가능해요.');
                                      } else {
                                        selectedList.add(top10[index]);
                                      }
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
                          Text('어종 리스트', style: body2(gray6)),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  width: 1,
                                  color: gray2,
                                ),
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) => InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      fishList[index],
                                      style:
                                          selectedList.contains(fishList[index])
                                              ? body1(primaryBlue500)
                                              : body1(),
                                    ),
                                  ),
                                  onTap: () => {
                                    setState(() {
                                      selectedList.add(fishList[index]);
                                    }),
                                  },
                                ),
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(
                                      thickness: 1, color: gray1, height: 0),
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
                          Text('검색결과 ${speciesList.length}건',
                              style: body2(gray6)),
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
                                    style: selectedList
                                            .contains(speciesList[index])
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
            ],
          ),
        ),
      ),
    );
  }
}
