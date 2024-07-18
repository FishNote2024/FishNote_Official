import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.value,
    required this.route,
  });

  final String? value;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: value == null
          ? null
          : () => {
                Navigator.pushNamed(context, route),
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: value == null ? gray2 : primaryBlue500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: const Text('다음', style: header3R),
    );
  }
}
