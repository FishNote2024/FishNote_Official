import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Homecustombutton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  Homecustombutton({
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
          padding: EdgeInsets.only(top: 8, bottom: 9),
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 1,
          side: BorderSide(color: Colors.transparent, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            SvgPicture.asset(iconPath),
            SizedBox(height: 6),
            Text(text, style: body2(gray6)),
          ],
        ),
      ),
    );
  }
}
