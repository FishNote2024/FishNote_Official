import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerticalOutlinedButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  const VerticalOutlinedButton({super.key, 
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: (screenWidth) / 5,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.only(top: 8, bottom: 9),
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          overlayColor: Colors.black,
          elevation: 1,
          side: const BorderSide(color: gray1, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(height: 6),
            Text(text, style: body2(gray6)),
          ],
        ),
      ),
    );
  }
}
