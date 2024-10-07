import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_add_fish.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';

class GetNetFish extends StatefulWidget {
  final VoidCallback onNext;
  final String recordId;

  const GetNetFish({super.key, required this.onNext, required this.recordId});

  @override
  State<GetNetFish> createState() => _GetNetFishState();
}

class _GetNetFishState extends State<GetNetFish> {
  final TextEditingController _controller = TextEditingController();
  List<String> selectedList = [];
  Set<String> speciesList = {};
  bool isFirstLoad = true;

  @override
  void initState() {
    final netRecordProvider =
        Provider.of<NetRecordProvider>(context, listen: false);
    super.initState();
    speciesList = netRecordProvider.species;
    print("🥨 speciesList : $speciesList");
    // 프로바이더에 저장하는데 뭔가 페이지 나가면 자꾸 초기화되는 것 같음. 들어오자마자 init에 복제해둬서 그런가?
    // init에서 복제하는 조건을 수정할 필요가 있음.

    // 최초 로딩 시에 speciesList가 비어있을 경우에만 UserInformationProvider에서 species를 가져와서 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // speciesList가 비어있을 경우에만 실행
      if (speciesList.isEmpty) {
        final userInformationProvider =
            Provider.of<UserInformationProvider>(context, listen: false);
        // final netRecordProvider =
        //     Provider.of<NetRecordProvider>(context, listen: false);

        // UserInformationProvider에서 species 가져오기
        speciesList = userInformationProvider.species.toSet();

        // NetRecordProvider에 species 초기값 설정
        netRecordProvider.setSpecies(speciesList);
      }
      setState(() {
        // speciesList를 UI에 반영
        // speciesList = NetRecordProvider().species;
        print("init ---> speciesList: $speciesList");
      });
      print("222-> speciesList is now: ${speciesList.isEmpty}");
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
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedList.isEmpty
              ? null
              : () {
                  // 선택된 어종을 기록에 업데이트
                  final userId =
                      Provider.of<LoginModelProvider>(context, listen: false)
                          .kakaoId;
                  Provider.of<NetRecordProvider>(context, listen: false)
                      .updateRecord(widget.recordId, userId,
                          species: selectedList.toSet());

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
                            color: Colors.white,
                            border: Border.all(
                              color: selectedList.contains(species)
                                  ? primaryBlue500
                                  : gray1,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // 그림자 색상
                                spreadRadius: 1, // 그림자의 퍼짐 정도
                                blurRadius: 6, // 그림자의 흐림 정도
                                offset: Offset(0, 3), // 그림자의 위치 (x, y)
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              species,
                              style: header3R(textBlack),
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
                        ));
                  } else {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: gray1,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // 그림자 색상
                                spreadRadius: 1, // 그림자의 퍼짐 정도
                                blurRadius: 4, // 그림자의 흐림 정도
                                offset: Offset(0, 3), // 그림자의 위치 (x, y)
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.add_circle_outline,
                                color: gray4),
                            title: Text("어종 추가하기", style: header3B(gray4)),
                            onTap: () async {
                              // GetNetAddFish로 이동해서 목록을 수정한 후 돌아오도록
                              print("---> speciesList: $speciesList");
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GetNetAddFish(
                                      recordId: widget.recordId,
                                      initialSelectedSpecies: speciesList),
                                ),
                              );

                              // 돌아왔을 때 NetRecordProvider에서 최신 목록 가져오기
                              setState(() {
                                speciesList = netRecordProvider.species;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
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
