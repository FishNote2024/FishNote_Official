import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    content: Text(
      message,
      style: header4(backgroundWhite),
      
      textAlign: TextAlign.center,
    ),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))), //	둥글게
    backgroundColor: primaryBlue500, //	배경색
    behavior: SnackBarBehavior.floating, //	아래 플로팅 띄우기
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
