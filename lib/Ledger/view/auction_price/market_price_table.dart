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
  Map<String, List<double>> speciesPrices = {};
  bool isLoading = true; // 로딩 상태 추가

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userInformationProvider =
        Provider.of<UserInformationProvider>(context);
    registeredSpecies = userInformationProvider.species;
    mxtrNm = userInformationProvider.affiliation;
    fetchData();
  }

  String _formatStatus(String status) {
    if (status.isNotEmpty) {
      return '(${status[0]})'; // 가장 앞글자만 가져와서 괄호로 감싸기
    }
    return status;
  }

  String _extractGoodsUnitNm(String goodsUnitNm) {
    final match = RegExp(r'상자\((.*?)\)').firstMatch(goodsUnitNm);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    return goodsUnitNm;
  }

  void parseApiResponse(String response, String species) {
    final document = xml.XmlDocument.parse(response);
    final items = document.findAllElements('item');

    List<double> prices = [];
    String kdfshSttusNm = '';
    String goodsUnitNm = '';
    String goodsStndrdNm = '';

    for (var item in items) {
      final priceText = item.findElements('csmtAmount').single.text;
      final price = double.tryParse(priceText) ?? 0.0;
      prices.add(price);

      if (kdfshSttusNm.isEmpty) {
        kdfshSttusNm = item.findElements('kdfshSttusNm').single.text;
      }
      if (goodsUnitNm.isEmpty) {
        goodsUnitNm = item.findElements('goodsUnitNm').single.text;
      }
      if (goodsStndrdNm.isEmpty) {
        goodsStndrdNm = item.findElements('goodsStndrdNm').single.text;
      }
    }

    if (prices.isNotEmpty) {
      speciesPrices[species] = prices;
      groupedData[species] = {
        'avgPrice': 0.0,
        'maxPrice': 0.0,
        'minPrice': 0.0,
        'status': _formatStatus(kdfshSttusNm),
        'goodsUnitNm': _extractGoodsUnitNm(goodsUnitNm),
        'goodsStndrdNm': goodsStndrdNm,
      };
    }
  }

  void calculateAndDisplayStatistics() {
    speciesPrices.forEach((species, prices) {
      if (prices.isEmpty) return;

      final average = prices.reduce((a, b) => a + b) / prices.length;
      final max = prices.reduce((a, b) => a > b ? a : b);
      final min = prices.reduce((a, b) => a < b ? a : b);

      groupedData[species]!['avgPrice'] = average;
      groupedData[species]!['maxPrice'] = max;
      groupedData[species]!['minPrice'] = min;
    });
  }

  Future<void> fetchData() async {
    try {
      groupedData.clear(); // 이전 데이터 clear

      for (var species in registeredSpecies) {
        String requestUrl =
            '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=$mxtrNm&fromDt=$baseDt&toDt=$baseDt&type=xml&mprcStdCodeNm=${Uri.encodeComponent(species)}';

        var response = await dio.get(requestUrl);

        if (response.statusCode == 200) {
          parseApiResponse(response.data, species);
        } else {
          print(
              'Error fetching data for species $species: ${response.statusCode}');
        }
      }

      calculateAndDisplayStatistics();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false; // 로딩 완료
      });
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

  @override
  Widget build(BuildContext context) {
    bool hasData = groupedData.isNotEmpty;

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
                      icon: const Icon(Icons.error_outline,
                          color: gray5, size: 25),
                      onPressed: _showTooltip,
                    ),
                  ],
                ),
                Text("오늘의 경락시세", style: header3B().copyWith(height: 0.6)),
                const SizedBox(height: 12),
                Text("소속 조합은 마이페이지에서 변경 가능합니다.\n*가격 표시 기준: ▵ 고가, - 평균가, ▿ 저가",
                    style: caption1(gray4)),
                const SizedBox(height: 40),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else if (hasData)
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(3),
                    },
                    border: const TableBorder(
                        horizontalInside: BorderSide(color: gray1),
                        verticalInside: BorderSide(color: Colors.transparent)),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: gray2, width: 1))),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                            child: Row(
                              children: [
                                Spacer(),
                                Text('가격', style: body2(gray5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      for (var species in groupedData.keys)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
                              child: Text(
                                '${groupedData[species]!['status']}$species',
                                style: body2(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
                              child: Text(
                                groupedData[species]!['goodsStndrdNm'] ?? '',
                                style: body2(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                child: Text(
                                  groupedData[species]!['goodsUnitNm'] ?? '',
                                  style: body2(),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child:
                                      SvgPicture.asset('assets/icons/up.svg'),
                                ),
                                const SizedBox(height: 15),
                                SvgPicture.asset('assets/icons/avg.svg'),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child:
                                      SvgPicture.asset('assets/icons/down.svg'),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 10, 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${groupedData[species]!['maxPrice']!.toStringAsFixed(0)}원',
                                      style: body2(),
                                    ),
                                    Text(
                                      '${groupedData[species]!['avgPrice']!.toStringAsFixed(0)}원',
                                      style: body2(),
                                    ),
                                    Text(
                                      '${groupedData[species]!['minPrice']!.toStringAsFixed(0)}원',
                                      style: body2(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                else
                  Center(child: Text('No data available')),
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
        ));
  }
}
