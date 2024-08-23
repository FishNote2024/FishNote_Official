import 'package:fish_note/net/view/get_net/get_net_add_fish.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';

class GetNetFishWeight extends StatefulWidget {
  const GetNetFishWeight(
      {super.key,
      required this.onNext,
      this.fishList,
      required List<String> selectedFish});

  final void Function(List<String> selectedFish) onNext; // Modify this line
  final List<String>? fishList;

  @override
  State<GetNetFishWeight> createState() => _GetNetFishWeightState();
}

class _GetNetFishWeightState extends State<GetNetFishWeight> {
  Map<String, TextEditingController> _controllers = {};
  final TextEditingController _controller = TextEditingController();
  Set<String> selectedList = {};
  List<String> speciesList = [
    '갈치',
    '고등어',
    '방어',
    '문어',
  ];

  @override
  void initState() {
    super.initState();
    for (String species in speciesList) {
      _controllers[species] = TextEditingController();
    }
    if (widget.fishList != null && widget.fishList!.isNotEmpty) {
      speciesList.addAll(widget.fishList!);
      speciesList = speciesList.toSet().toList();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSpecies(String species) {
    if (species.isNotEmpty && !speciesList.contains(species)) {
      setState(() {
        speciesList.add(species);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedList.isEmpty
              ? null
              : () => widget
                  .onNext(selectedList.toList()), // Pass the selected fish list
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
                            onTap: () {
                              // setState(() {
                              //   if (selectedList.contains(species)) {
                              //     selectedList.remove(species);
                              //   } else {
                              //     selectedList.add(species);
                              //   }
                              // });
                            },
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
