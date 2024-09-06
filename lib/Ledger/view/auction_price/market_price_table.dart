import 'package:fish_note/myPage/view/my_page_view.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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
  String apiKey = dotenv.env['MARKET_PRICE_API_KEY']!;

  final String apiUrl =
      'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  String baseDt = '20240816';
  Set<String> registeredSpecies = {};
  String mxtrNm = '';
  Map<String, Map<String, dynamic>> groupedData = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userInformationProvider =
        Provider.of<UserInformationProvider>(context);
    registeredSpecies = userInformationProvider.species;
    mxtrNm = userInformationProvider.affiliation;
    print('mxtrNm: $mxtrNm');
    print('registeredSpecies: $registeredSpecies');
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      groupedData.clear();
      String requestUrl =
          '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=$mxtrNm&fromDt=$baseDt&toDt=$baseDt&type=xml';
      var response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        var document = xml.XmlDocument.parse(response.data);
        final items = document.findAllElements('item');
        print("데이터 가져오기 성공");
        print(response.data);
        print("response 끝");
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
        top: MediaQuery.of(context).size.height - 655,
        left: MediaQuery.of(context).size.width - 180,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(6),
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
    Future.delayed(const Duration(seconds: 2), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _formatGoodsUnitNm(String goodsUnitNm) {
    final match = RegExp(r'상자\((.*?)\)').firstMatch(goodsUnitNm);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    return goodsUnitNm;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideTooltip,
      child: Padding(
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
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.error_outline, color: gray5, size: 25),
                    onPressed: _showTooltip,
                  ),
                ],
              ),
              Text("오늘의 경락시세", style: header3B().copyWith(height: 0.6)),
              const SizedBox(height: 12),
              Text("소속 조합은 마이페이지에서 변경 가능합니다.\n*가격 표시 기준: ▵ 고가, - 평균가, ▿ 저가",
                  style: caption1(gray4)),
              const SizedBox(height: 40),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(3),
                },
                border: const TableBorder(
                    horizontalInside: BorderSide(color: gray1),
                    verticalInside: BorderSide(color: Colors.transparent)),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: gray2, width: 1))),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
                        child: Text('주요 어종', style: body2(gray5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
                        child: Text('규격', style: body2(gray5)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                          child: Text('수량/단위', style: body2(gray5)),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Text(''),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Text('가격', style: body2(gray5)),
                        ),
                      ),
                    ],
                  ),
                  ...groupedData.entries.map((entry) {
                    final avgUntpc =
                        (entry.value['totalUntpc'] / entry.value['count'])
                            .toInt();
                    final maxUntpc = entry.value['maxUntpc']?.toInt() ?? '-';
                    final minUntpc = entry.value['minUntpc']?.toInt() ?? '-';
                    return TableRow(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: gray1, width: 1))),
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
                              left: 16.0, top: 30, bottom: 30),
                          child: Text(
                            _formatGoodsUnitNm(entry.value['goodsUnitNm']),
                            style: body1(gray5),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(right: 1.0),
                              child: SvgPicture.asset('assets/icons/up.svg'),
                            ),
                            const SizedBox(height: 15),
                            SvgPicture.asset('assets/icons/avg.svg'),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(right: 1.0),
                              child: SvgPicture.asset('assets/icons/down.svg'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Spacer(),
                                Text('$maxUntpc원', style: body1(textBlack)),
                              ],
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text('$avgUntpc원', style: body1(textBlack)),
                              ],
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text('$minUntpc원', style: body1(textBlack)),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryBlue500, width: 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPageView()));
                    },
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
      ),
    );
  }
}
