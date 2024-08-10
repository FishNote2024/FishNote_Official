import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/font.dart';

class MarketPrice extends StatelessWidget {
  const MarketPrice({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fishData = [
      {'name': '아귀', 'price': '7,666원'},
      {'name': '청어', 'price': '13,333원'},
      {'name': '정어리', 'price': '111원'},
      {'name': '골뱅이', 'price': '180원'},
      {'name': '참치', 'price': '1280원'},
    ];

    final GlobalKey _iconKey = GlobalKey();
    OverlayEntry? _overlayEntry;

    void _showTooltip() {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).size.height - 635,
          left: MediaQuery.of(context).size.width - 145,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gray2),
              ),
              child: Text(
                '소속 조합은 마이페이지에서\n변경 가능합니다',
                style: caption1(gray4),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }

    void _hideTooltip() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("양양수산업협동조합",
                    style: header3B(primaryBlue500).copyWith(height: 0.6)),
                IconButton(
                  key: _iconKey,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.error_outline, color: gray5, size: 25),
                  onPressed: () {
                    _showTooltip();
                    Future.delayed(Duration(seconds: 2), () {
                      _hideTooltip();
                    });
                  },
                ),
              ],
            ),
          ),
          Text("최근 경락시세", style: header3B().copyWith(height: 0.6)),
          SizedBox(height: 40),
          Table(
            border: TableBorder(
                horizontalInside: BorderSide(color: gray1),
                verticalInside: BorderSide(color: Colors.transparent)),
            children: [
              TableRow(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: gray2, width: 1))),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 12, 0, 12),
                    child: Text('등록된 주요 어종', style: body2(gray5)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 12, 0, 12),
                    child: Text('최근 시세 (1kg당)', style: body2(gray5)),
                  ),
                ],
              ),
              for (int i = 0; i < fishData.length; i++)
                TableRow(
                  decoration: i == fishData.length - 1
                      ? BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: gray1, width: 1)))
                      : null,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(4, 12, 0, 12),
                        child: Text(fishData[i]['name'] ?? "아직 데이터가 없습니다.",
                            style: body1(textBlack))),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(fishData[i]['price'] ?? "-",
                            style: body1(textBlack))),
                  ],
                ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue500, width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "주요 어종 추가",
                    style: header4(primaryBlue500),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
