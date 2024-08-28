import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_add_fish.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';

class GetNetFish extends StatefulWidget {
  const GetNetFish({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<GetNetFish> createState() => _GetNetFishState();
}

class _GetNetFishState extends State<GetNetFish> {
  final TextEditingController _controller = TextEditingController();
  Set<String> selectedList = {};
  Set<String> speciesList = {};

  @override
  void initState() {
    super.initState();
    // 최초 로딩 시 UserInformationProvider에서 species를 가져와 NetRecordProvider에 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userInformationProvider =
          Provider.of<UserInformationProvider>(context, listen: false);
      final netRecordProvider =
          Provider.of<NetRecordProvider>(context, listen: false);

      // 초기 데이터 복사
      speciesList = userInformationProvider.species.toSet();
      netRecordProvider.setSpecies(speciesList);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final netRecordProvider = Provider.of<NetRecordProvider>(context);

    // NetRecordProvider에서 업데이트된 species 목록을 가져옴
    speciesList = netRecordProvider.species;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedList.isEmpty
              ? null
              : () {
                  netRecordProvider.setSpecies(selectedList);
                  print("🤯 selectedList = ${selectedList}");
                  widget.onNext();
                },
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: speciesList.length + 1,
                itemBuilder: (context, index) {
                  if (index < speciesList.length) {
                    String species = speciesList.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedList.contains(species)
                              ? primaryBlue500
                              : Colors.white,
                          border: Border.all(
                            color: selectedList.contains(species)
                                ? primaryBlue500
                                : gray2,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            species,
                            style: header3R(
                              selectedList.contains(species)
                                  ? Colors.white
                                  : textBlack,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (selectedList.contains(species)) {
                                selectedList.remove(species);
                              } else {
                                selectedList.add(species);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: gray2,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.add_circle_outline,
                                color: primaryBlue500),
                            title: Text("어종 추가하기",
                                style: header3R(primaryBlue500)),
                            onTap: () async {
                              // GetNetAddFish로 이동해서 목록을 수정한 후 돌아오도록
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetNetAddFish(),
                                ),
                              );

                              // 돌아왔을 때 NetRecordProvider에서 최신 목록 가져오기
                              setState(() {
                                speciesList = netRecordProvider.species;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
