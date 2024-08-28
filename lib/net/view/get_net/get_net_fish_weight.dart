import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/net/view/get_net/get_net_add_fish.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';

class GetNetFishWeight extends StatefulWidget {
  const GetNetFishWeight({super.key, required this.onNext});

  final void Function(List<String> selectedFish) onNext;

  @override
  State<GetNetFishWeight> createState() => _GetNetFishWeightState();
}

class _GetNetFishWeightState extends State<GetNetFishWeight> {
  Map<String, TextEditingController> _controllers = {};
  bool allFieldsFilled = false;
  Set<String> selectedList = {};
  List<String> speciesList = [];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding을 사용해 initState 이후에 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final netRecordProvider =
          Provider.of<NetRecordProvider>(context, listen: false);
      String speciesString =
          netRecordProvider.fishData.keys.elementAt(0).toString();
      speciesList = speciesString.replaceAll(RegExp(r'[\[\]]'), '').split(', ');

      // speciesList가 초기화된 후에 TextEditingController를 설정합니다.
      for (String species in speciesList) {
        _controllers[species] = TextEditingController();
        _controllers[species]!.addListener(_updateButtonState);
      }

      setState(() {}); // 컨트롤러 설정 후 UI 갱신
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateButtonState() {
    bool allFilled =
        _controllers.values.every((controller) => controller.text.isNotEmpty);

    setState(() {
      allFieldsFilled = allFilled;

      if (allFilled) {
        selectedList = _controllers.entries
            .map((entry) => '${entry.key} ${entry.value.text} kg')
            .toSet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: allFieldsFilled
              ? () {
                  final netRecordProvider =
                      Provider.of<NetRecordProvider>(context, listen: false);
                  for (var entry in _controllers.entries) {
                    netRecordProvider.addFish(
                        entry.key, double.parse(entry.value.text));
                  }
                  print(netRecordProvider.fishData);

                  widget.onNext(selectedList.toList());
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: allFieldsFilled ? primaryBlue500 : gray2,
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
                itemCount: speciesList.length,
                itemBuilder: (context, index) {
                  String species = speciesList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: gray2,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              species,
                              style: header3R(textBlack),
                            ),
                            Spacer(),
                            Container(
                              width: 180,
                              height: 33,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: gray3,
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _controllers[species],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '- ',
                                  isDense: false,
                                  suffixText: ' kg  ',
                                ),
                                textAlign: TextAlign.end,
                                style: body1(textBlack),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
