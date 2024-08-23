import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/font.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

class MarketPriceTable extends StatefulWidget {
  const MarketPriceTable({Key? key}) : super(key: key);

  @override
  _MarketPriceTableState createState() => _MarketPriceTableState();
}

class _MarketPriceTableState extends State<MarketPriceTable> {
  final Dio dio = Dio();
  final String apiUrl =
      'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  final String apiKey =
      'P9snIt2gDleusE4uaQ9a1Tyx6/QaQRBJjRzr9H4ELGzbp263NM0Fvprpu1mr6Qqu6Efxqu35tgxg0JeKZtRnHA==';
  String baseDt = '20240816';

  // 등록된 어종 목록
  final List<String> registeredSpecies = ['문어', '전복', '방어', '소라', '다금바리'];
  // 등록된 조합명
  final String mxtrNm = '거제수산업협동조합';

  Map<String, Map<String, dynamic>> groupedData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // 기존 데이터 제거
      groupedData.clear();
      String requestUrl =
          '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=$mxtrNm&fromDt=$baseDt&toDt=$baseDt&type=xml';
      var response = await dio.get(requestUrl);
      if (response.statusCode == 200) {
        var document = xml.XmlDocument.parse(response.data);
        final items = document.findAllElements('item');

        for (var item in items) {
          String mprcStdCodeNm = item.findElements('mprcStdCodeNm').single.text;

          if (registeredSpecies.contains(mprcStdCodeNm)) {
            double csmtUntpc =
                double.parse(item.findElements('csmtUntpc').single.text);
            String goodsStndrdNm =
                item.findElements('goodsStndrdNm').single.text;
            double csmtQy =
                double.parse(item.findElements('csmtQy').single.text);
            String kdfshSttusNm = item.findElements('kdfshSttusNm').single.text;
            String goodsUnitNm = item.findElements('goodsUnitNm').single.text;

            if (groupedData.containsKey(mprcStdCodeNm)) {
              groupedData[mprcStdCodeNm]!['totalUntpc'] += csmtUntpc;
              groupedData[mprcStdCodeNm]!['totalQy'] += csmtQy;
              groupedData[mprcStdCodeNm]!['count'] += 1;

              // 고가, 저가 갱신
              groupedData[mprcStdCodeNm]!['maxUntpc'] =
                  (csmtUntpc > groupedData[mprcStdCodeNm]!['maxUntpc'])
                      ? csmtUntpc
                      : groupedData[mprcStdCodeNm]!['maxUntpc'];

              groupedData[mprcStdCodeNm]!['minUntpc'] =
                  (csmtUntpc < groupedData[mprcStdCodeNm]!['minUntpc'])
                      ? csmtUntpc
                      : groupedData[mprcStdCodeNm]!['minUntpc'];
            } else {
              groupedData[mprcStdCodeNm] = {
                'mprcStdCodeNm': mprcStdCodeNm,
                'goodsStndrdNm': goodsStndrdNm,
                'totalUntpc': csmtUntpc,
                'totalQy': csmtQy,
                'count': 1,
                'kdfshSttusNm': kdfshSttusNm,
                'maxUntpc': csmtUntpc,
                'minUntpc': csmtUntpc,
                'goodsUnitNm': goodsUnitNm,
              };
            }
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final GlobalKey _iconKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showTooltip() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height - 620,
        left: MediaQuery.of(context).size.width - 150,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: gray2),
            ),
            child: Text(
              '소속 조합은 마이페이지에서\n변경 가능합니다',
              style: caption2(gray4),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(mxtrNm,
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
            Text("오늘의 경락시세", style: header3B().copyWith(height: 0.6)),
            SizedBox(height: 12),
            Text("소속 조합은 마이페이지에서 변경 가능합니다.\n*가격 표시 기준: ▵ 고가, - 평균가, ▿ 저가",
                style: caption1(gray4)),
            const SizedBox(height: 40),
            Table(
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(3),
              },
              border: TableBorder(
                  horizontalInside: BorderSide(color: gray1),
                  verticalInside: BorderSide(color: Colors.transparent)),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: gray2, width: 1))),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 12, 0, 12),
                      child: Text('주요 어종', style: body2(gray5)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 12, 0, 12),
                      child: Text('규격', style: body2(gray5)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                        child: Text('수량/단위', style: body2(gray5)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(''),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text('가격', style: body2(gray5)),
                      ),
                    ),
                  ],
                ),
                ...groupedData.entries.map((entry) {
                  final avgUntpc =
                      (entry.value['totalUntpc'] / entry.value['count'])
                          .toInt();
                  final maxUntpc = entry.value['maxUntpc']?.toInt() ?? 'N/A';
                  final minUntpc = entry.value['minUntpc']?.toInt() ?? 'N/A';
                  return TableRow(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: gray1, width: 1))),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, top: 30, bottom: 30),
                        child: Text(
                          '(${entry.value['kdfshSttusNm'][0]})${entry.value['mprcStdCodeNm']}',
                          style: body1(textBlack),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 30, bottom: 30),
                        child: Text(entry.value['goodsStndrdNm'],
                            style: body1(gray5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 30, bottom: 30),
                        child: Text(entry.value['goodsUnitNm'],
                            style: body1(gray5)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: SvgPicture.asset('assets/icons/up.svg'),
                          ),
                          SizedBox(height: 15),
                          SvgPicture.asset('assets/icons/avg.svg'),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: SvgPicture.asset('assets/icons/down.svg'),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Spacer(),
                            Text('$maxUntpc원', style: body1(textBlack)),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text('$avgUntpc원', style: body1(textBlack)),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text('$minUntpc원', style: body1(textBlack)),
                          ],
                        ),
                        SizedBox(height: 10),
                      ]),
                    ],
                  );
                }).toList(),
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
      ),
    );
  }
}