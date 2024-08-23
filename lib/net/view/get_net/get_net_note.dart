import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class GetNetNote extends StatefulWidget {
  const GetNetNote({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  State<GetNetNote> createState() => _GetNetNoteState();
}

class _GetNetNoteState extends State<GetNetNote> {
  List<String> selectedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedList.isEmpty ? null : widget.onNext,
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
            Text('메모를 추가해보세요', style: header1B()),
            const SizedBox(height: 8),
            Text(
              '오늘 어획에 있어 기록하고 싶은 특징이 있다면\n자유롭게 기록해보세요.',
              style: body1(gray6),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: selectedList.length + 1,
                itemBuilder: (context, index) {
                  if (index < selectedList.length) {
                    String species = selectedList[index];
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
