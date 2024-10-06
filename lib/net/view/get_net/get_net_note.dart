import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetNetNote extends StatefulWidget {
  final VoidCallback onNext;
  final String recordId;

  const GetNetNote({super.key, required this.onNext, required this.recordId});

  @override
  State<GetNetNote> createState() => _GetNetNoteState();
}

class _GetNetNoteState extends State<GetNetNote> {
  String memo = "";

  void _submitMemo() {
    final userId =
        Provider.of<LoginModelProvider>(context, listen: false).kakaoId;
    Provider.of<NetRecordProvider>(context, listen: false).updateRecord(
        widget.recordId, userId,
        getTime: DateTime.now(), isGet: true, memo: memo);
    Navigator.pushReplacementNamed(context, '/netPage2');
  }

  @override
  Widget build(BuildContext context) {
    final netRecordProvider = Provider.of<NetRecordProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // 메모가 비어있지 않으면 저장하고 다음 페이지로 이동
            if (memo.isNotEmpty) {
              _submitMemo();
              // 넘어가기 전에 어종 초기화
              netRecordProvider.resetSpecies();
              print(
                  "🥨🥨 speciesList after submit (not empty): ${netRecordProvider.species}");
            } else {
              _submitMemo();
              // 넘어가기 전에 어종 초기화
              netRecordProvider.resetSpecies();
              print(
                  "🥨🥨 speciesList after submit (empty): ${netRecordProvider.species}");
            }
          },
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
      body: SingleChildScrollView(
        child: Padding(
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
                      memo = value;
                    });
                  },
                  maxLines: 35,
                  decoration: InputDecoration(
                    hintText: '이곳에 메모를 입력해주세요.\n메모는 스킵 가능합니다.',
                    hintStyle: body1(gray6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: gray2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: primaryBlue500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
