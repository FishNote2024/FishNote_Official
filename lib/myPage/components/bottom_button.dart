import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget {
  const BottomButton({
    super.key,
    required this.text,
    required this.value,
    required this.onPressed,
  });

  final String text;
  final Object? value;
  final VoidCallback onPressed;

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  final TextEditingController _controller = TextEditingController();

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: backgroundWhite,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '주요 조업 위치의 별명을 입력해주세요',
                style: header3B(),
              ),
              const SizedBox(height: 18),
              TextField(
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: _controller,
                cursorColor: primaryBlue500,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundWhite,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  hintText: '지역 별명을 입력해주세요',
                  hintStyle: body1(gray3),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _controller.text.isEmpty
                    ? () => {}
                    : () {
                        // 허용 안함 버튼 클릭 시 동작
                        Navigator.pop(context);
                        // 별명 등록 로직 추가
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  backgroundColor: primaryBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('등록하기', style: header4(backgroundWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: widget.value == null
            ? null
            : widget.text == "해당 위치로 수정하기"
                ? () => _showLocationModal(context)
                : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.value == null ? gray2 : primaryBlue500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(widget.text, style: header1B(Colors.white)),
      ),
    );
  }
}
