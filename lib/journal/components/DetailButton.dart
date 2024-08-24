import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/font.dart';

class DetailButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const DetailButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundWhite,  // 버튼의 배경색을 설정합니다.
          foregroundColor: color, // 텍스트 색상
          side: BorderSide(
            color: color,  // 테두리 색상
            width: 1,  // 테두리 두께
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 모서리를 둥글게 만듭니다.
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // 내부 여백 설정
          minimumSize: const Size(304, 16),
        ),
        child: Text(text, style: body1(color)),
      ),
    );
  }
}
