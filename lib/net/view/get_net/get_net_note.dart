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
          onPressed: widget.onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('양망완료', style: header1B(Colors.white)),
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
            SizedBox(
              height: 418,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    selectedList = [value];
                  });
                },
                maxLines: 35,
                decoration: InputDecoration(
                  hintText: '이곳에 메모를 입력해주세요.\n메모는 스킵 가능합니다.',
                  hintStyle: body1(gray6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: gray2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryBlue500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
