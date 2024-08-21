import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

class LedgerPage extends StatefulWidget {
  final int initialTabIndex;
  const LedgerPage({super.key, required this.initialTabIndex});

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _dropdownValue = '월간';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조업 장부'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '위판장부'),
            Tab(text: '경락시세'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: _dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                      });
                    },
                    items: <String>['월간', '주간']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '30,245,070원',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('매출 통계'),
                ],
              ),
            ),
            const Center(child: MarketPriceTable()),
          ],
        ),
      ),
    );
  }
}

class MarketPriceTable extends StatefulWidget {
  const MarketPriceTable({Key? key}) : super(key: key);

  @override
  _MarketPriceTableState createState() => _MarketPriceTableState();
}

class _MarketPriceTableState extends State<MarketPriceTable> {
  final Dio dio = Dio();
  final String apiUrl =
      'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  String baseDt = '20240818';
  final String apiKey =
      'P9snIt2gDleusE4uaQ9a1Tyx6/QaQRBJjRzr9H4ELGzbp263NM0Fvprpu1mr6Qqu6Efxqu35tgxg0JeKZtRnHA==';

  // 등록된 어종 목록
  final List<String> registeredSpecies = ['문어', '돗돔', '눈볼대', '다금바리'];
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
      groupedData.clear();
      String requestUrl =
          '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&type=xml';
      var response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        var document = xml.XmlDocument.parse(response.data);
        final items = document.findAllElements('item');

        for (var item in items) {
          String mprcStdCodeNm = item.findElements('mprcStdCodeNm').single.text;

          // 등록된 어종만 필터링
          if (registeredSpecies.contains(mprcStdCodeNm)) {
            double csmtUntpc =
                double.parse(item.findElements('csmtUntpc').single.text);

            if (groupedData.containsKey(mprcStdCodeNm)) {
              groupedData[mprcStdCodeNm]!['totalUntpc'] += csmtUntpc;
              groupedData[mprcStdCodeNm]!['count'] += 1;
            } else {
              groupedData[mprcStdCodeNm] = {
                'mprcStdCodeNm': mprcStdCodeNm,
                'totalUntpc': csmtUntpc,
                'count': 1,
              };
            }
          }
        }

        setState(() {});
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mxtrNm,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("최근 경락시세",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Table(
              border: TableBorder.all(color: Colors.grey),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '주요 어종',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '최근 시세 (1kg당)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...groupedData.entries.map((entry) {
                  final avgUntpc =
                      (entry.value['totalUntpc'] / entry.value['count'])
                          .toStringAsFixed(2);
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(entry.value['mprcStdCodeNm']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$avgUntpc원'),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
