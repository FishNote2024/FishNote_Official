import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:flutter/material.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';

class GetNetFishWeight extends StatefulWidget {
  final VoidCallback onNext;
  final String recordId;

  const GetNetFishWeight(
      {super.key, required this.onNext, required this.recordId});

  @override
  State<GetNetFishWeight> createState() => _GetNetFishWeightState();
}

class _GetNetFishWeightState extends State<GetNetFishWeight> {
  final Map<String, TextEditingController> _controllers = {};
  bool allFieldsFilled = false;
  List<String> speciesList = [];
  // late FocusNode _focusNode;
  final Map<String, FocusNode> _focusNodes = {};
  Color borderColor = gray3; // 기본 테두리 색상
  @override
  void initState() {
    super.initState();
    // _focusNode = FocusNode();

    // NetRecordProvider에서 species 리스트를 가져와서 speciesList에 넣기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final netRecordProvider =
          Provider.of<NetRecordProvider>(context, listen: false);

      // 특정 recordId에 해당하는 기록 찾기
      NetRecord? record = netRecordProvider.getRecordById(widget.recordId);

      if (record != null && record.species.isNotEmpty) {
        speciesList = record.species.toList();
        // speciesList에 있는 각 species에 대해 TextEditingController를 설정
        for (String species in speciesList) {
          _controllers[species] = TextEditingController();
          _controllers[species]!.addListener(_updateButtonState);
          _focusNodes[species] = FocusNode();
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose(); // FocusNode 해제
    }
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
    });
  }

  void _submitData() {
    List<double> weights = [];
    for (var entry in _controllers.entries) {
      weights.add(double.parse(entry.value.text));
    }

    final userId =
        Provider.of<LoginModelProvider>(context, listen: false).kakaoId;
    Provider.of<NetRecordProvider>(context, listen: false)
        .updateRecord(widget.recordId, userId, amount: weights);

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: allFieldsFilled ? _submitData : null,
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
                          color: gray1,
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
                        title: Row(
                          children: [
                            Text(
                              species,
                              style: header3R(textBlack),
                            ),
                            const Spacer(),
                            Container(
                              width: 180,
                              height: 33,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _focusNodes[species]?.hasFocus == true
                                      ? primaryBlue500 // 포커스가 있을 경우
                                      : gray3, // 기본 테두리 색상
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _controllers[species],
                                focusNode: _focusNodes[species],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
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
