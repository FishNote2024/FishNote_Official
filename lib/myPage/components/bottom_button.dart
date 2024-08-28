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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: widget.value == null ? null : widget.onPressed,
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
