import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class FavoritesInformation extends StatelessWidget {
  const FavoritesInformation({super.key, required this.latlon});

  final List<double>? latlon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        actions: const [SizedBox.shrink()],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 24, color: primaryBlue300),
            Text('위도 ${latlon![0]} 경도 ${latlon![1]}', style: body2()),
          ],
        ),
        centerTitle: true,
      ),
    );
  }
}
