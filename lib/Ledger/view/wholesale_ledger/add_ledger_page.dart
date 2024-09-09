import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AddLedgerPage extends StatefulWidget {
  final DateTime selectedDate;
  const AddLedgerPage({super.key, required this.selectedDate});

  @override
  State<AddLedgerPage> createState() => _AddLedgerPageState();
}

class _AddLedgerPageState extends State<AddLedgerPage> {
  final Dio dio = Dio();
  String apiKey = dotenv.env['MARKET_PRICE_API_KEY']!;
  late List<TextEditingController> revenuePriceControllers;

  final String apiUrl = 'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  Set<String> registeredSpecies = {};
  String mxtrNm = '';
  Map<String, List<double>> speciesPrices = {};
  Map<String, String> units = {};
  bool _isLoading = true; // 로딩 상태 추가
  List<Map<String, dynamic>> revenueEntries = [];
  List<Map<String, dynamic>> expenseEntries = [
    {'구분': '', '비용': ''}
  ];

  void _addRevenueEntry() {
    setState(() {
      revenueEntries.add({
        '어종': '',
        '위판량': '',
        '단위': 'KG',
        '위판단가': '',
      });
    });
  }

  void _deleteRevenueEntry(int index) {
    setState(() {
      revenueEntries.removeAt(index);
    });
  }

  void _addExpenseEntry() {
    setState(() {
      expenseEntries.add({
        '구분': '',
        '비용': '',
      });
    });
  }

  void _deleteExpenseEntry(int index) {
    setState(() {
      expenseEntries.removeAt(index);
    });
  }

  void _saveLedger(BuildContext context) {
    final loginModelProvider = Provider.of<LoginModelProvider>(context, listen: false);

    List<SaleModel> sales = revenueEntries.map((entry) {
      return SaleModel(
        species: entry['어종'],
        weight: double.tryParse(entry['위판량']) ?? 0.0,
        unit: entry['단위'],
        price: int.tryParse(entry['위판단가']) ?? 0,
      );
    }).toList();

    List<PayModel> pays = expenseEntries.map((entry) {
      return PayModel(
        category: entry['구분'],
        amount: int.tryParse(entry['비용']) ?? 0,
      );
    }).toList();

    LedgerModel newLedger = LedgerModel(
      date: widget.selectedDate,
      totalSales: getTotalRevenue(),
      totalPays: getTotalExpense(),
      sales: sales,
      pays: pays,
    );

    Provider.of<LedgerProvider>(context, listen: false)
        .addLedger(newLedger, loginModelProvider.kakaoId);

    // 저장 후 이전 화면으로 이동
    Navigator.pop(context);
  }

  int getTotalRevenue() {
    return revenueEntries.fold(0, (sum, entry) {
      int price = int.tryParse(entry['위판단가']) ?? 0;
      double weight = double.tryParse(entry['위판량']) ?? 0.0;
      return sum + (price * weight).round();
    });
  }

  int getTotalExpense() {
    return expenseEntries.fold(0, (sum, entry) {
      int price = int.tryParse(entry['비용']) ?? 0;
      return sum + price;
    });
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Future<void> fetchData(String baseDt) async {
    try {
      for (var species in registeredSpecies) {
        String requestUrl =
            '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=50&baseDt=$baseDt&mxtrNm=$mxtrNm&fromDt=$baseDt&toDt=$baseDt&type=xml&mprcStdCodeNm=${Uri.encodeComponent(species)}';

        var response = await dio.get(requestUrl);

        if (response.statusCode == 200) {
          final document = xml.XmlDocument.parse(response.data);
          final items = document.findAllElements('item');
          final unit =
              items.any((item) => item.findElements('goodsUnitNm').single.text == '상자(C/S)')
                  ? '상자(C/S)'
                  : 'KG';

          List<double> prices = [];
          for (var item in items) {
            final priceText = item.findElements('csmtAmount').single.text;
            final price = double.tryParse(priceText) ?? 0.0;
            prices.add(price);
          }
          speciesPrices[species] = prices;
          units[species] = unit;
        } else {
          print('Error fetching data for species $species: ${response.statusCode}');
        }
      }

      if (speciesPrices.isEmpty) {
        revenueEntries.add({
          '어종': '',
          '위판량': '',
          '단위': 'KG',
          '위판단가': '',
        });
        revenuePriceControllers = List.generate(1, (index) => TextEditingController());
        return;
      }
      // speciesPrices에 저장된 key, value 값을 revenueEntries에 _addRevenueEntry() 하며 추가
      speciesPrices.forEach((species, prices) {
        if (prices.isEmpty) return;

        final average = prices.reduce((a, b) => a + b) / prices.length;

        revenueEntries.add({
          '어종': species,
          '위판량': '',
          '단위': units[species],
          '위판단가': average.toStringAsFixed(0),
        });
      });

      revenuePriceControllers = List.generate(
        revenueEntries.length,
        (index) => TextEditingController(text: revenueEntries[index]['위판단가']),
      );
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 완료
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    registeredSpecies = userInformationProvider.species;
    mxtrNm = userInformationProvider.affiliation;
    String baseDt = DateFormat('yyyyMMdd').format(widget.selectedDate);
    fetchData(baseDt);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd('ko_KR').format(widget.selectedDate);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        _showExitConfirmationDialog(context);
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundBlue,
              centerTitle: true,
              title: Text(formattedDate, style: body2(textBlack)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: gray7),
                onPressed: () {
                  _showExitConfirmationDialog(context);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      if (revenueEntries.length == 1 &&
                          expenseEntries.length == 1 &&
                          revenueEntries[0]['어종'] == '' &&
                          revenueEntries[0]['위판량'] == '' &&
                          revenueEntries[0]['위판단가'] == '' &&
                          expenseEntries[0]['구분'] == '' &&
                          expenseEntries[0]['비용'] == '') {
                        showSnackBar(context, '위판 정보나 지출 정보를 입력해주세요');
                        return;
                      } else if (revenueEntries.length > 1 &&
                          revenueEntries.any((entry) =>
                              entry['어종'] == '' || entry['위판량'] == '' || entry['위판단가'] == '')) {
                        showSnackBar(context, '위판 정보를 모두 입력해주세요');
                        return;
                      } else if (expenseEntries.length > 1 &&
                          expenseEntries.any((entry) => entry['구분'] == '' || entry['비용'] == '')) {
                        showSnackBar(context, '지출 정보를 모두 입력해주세요');
                        return;
                      } else if (revenueEntries.length == 1 &&
                          revenueEntries[0]['어종'] == '' &&
                          revenueEntries[0]['위판량'] == '' &&
                          revenueEntries[0]['위판단가'] == '') {
                        revenueEntries.removeAt(0);
                      } else if (expenseEntries.length == 1 &&
                          expenseEntries[0]['구분'] == '' &&
                          expenseEntries[0]['비용'] == '') {
                        expenseEntries.removeAt(0);
                      }
                      _saveLedger(context);
                    },
                    child: Text("저장", style: body2(primaryYellow900)),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [_buildRevenue(), _buildExpense()],
                ),
              ),
            ),
          ),
          _isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: backgroundWhite.withOpacity(0.8),
                  child: const Center(child: CircularProgressIndicator(color: primaryBlue500)),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "페이지에서 나가시겠습니까?",
            style: header3B(textBlack),
          ),
          content: Text("작성한 내용이 저장되지 않고 사라집니다.\n정말 페이지에서 나가시겠습니까?", style: body2(gray6)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("머무르기", style: caption1(primaryBlue500)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("나가기", style: caption1(primaryBlue500)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRevenue() {
    int totalRevenue = getTotalRevenue(); // 합계 계산
    String formattedTotalRevenue = formatNumber(totalRevenue); // 합계 형식화

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5, bottom: 24),
          child: Row(
            children: [
              Text("매출", style: body1(gray5)),
              const Spacer(),
              Text("$formattedTotalRevenue원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: gray1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("위판", style: header4(gray8)),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _addRevenueEntry,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('위판 추가하기 ', style: body2(gray4)),
                        const Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: revenueEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildRevenueEntryForm(context, index),
                      if (index != revenueEntries.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Divider(color: gray1),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제"),
          content: const Text("위판을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소", style: body2(primaryYellow900)),
            ),
            TextButton(
              onPressed: () {
                _deleteRevenueEntry(index);
                Navigator.pop(context);
              },
              child: Text("삭제", style: body2(primaryYellow900)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRevenueFormRow({required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                border: Border.all(color: gray4, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // 지출
  Widget _buildExpense() {
    int totalExpense = getTotalExpense(); // 합계 계산
    String formattedTotalExpense = formatNumber(totalExpense); // 합계 형식화

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 40, bottom: 24),
          child: Row(
            children: [
              Text("지출", style: body1(gray5)),
              const Spacer(),
              Text("$formattedTotalExpense원", style: header3B(textBlack)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: gray1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("지출 내역", style: header4(gray8)),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _addExpenseEntry,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.transparent),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('지출 추가하기 ', style: body2(gray4)),
                        const Icon(Icons.add_circle_outline, color: gray4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenseEntries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildExpenseEntryForm(index),
                      if (index != expenseEntries.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Divider(color: gray1),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueEntryForm(BuildContext context, int index) {
    return Column(
      children: [
        _buildRevenueFormRow(
          index: index,
          label: "어종",
          child: Consumer<NetRecordProvider>(
            builder: (context, netRecordProvider, child) {
              // 선택된 날짜에 해당하는 어종을 가져옴
              Set<String> speciesList = netRecordProvider.netRecords
                  .where((record) => record.isGet && isSameDay(record.getDate, widget.selectedDate))
                  .expand((record) => record.species)
                  .toSet();

              // 어종이 없을 때 userInfoProvider에서 species 가져오기
              if (speciesList.isEmpty) {
                final userInfoProvider =
                    Provider.of<UserInformationProvider>(context, listen: false);
                speciesList = userInfoProvider.species;
              }

              String? currentValue = revenueEntries[index]['어종'];
              if (!speciesList.contains(currentValue)) {
                currentValue = null;
              }

              return DropdownButton<String>(
                isExpanded: true,
                value: currentValue,
                hint: Text("어종을 선택해주세요", style: body2(gray4)),
                onChanged: (value) {
                  if (speciesList.length == 1 && speciesList.first == '해당 날짜에 양망한 어종이 없어요') {
                    // 어종이 없을 때는 선택하지 않음
                    return;
                  }
                  setState(() {
                    revenueEntries[index]['어종'] = value;
                  });
                },
                items: speciesList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    enabled:
                        !(speciesList.length == 1 && speciesList.first == '해당 날짜에 양망한 어종이 없어요'),
                    child: Text(value, style: body2(textBlack)), // 비활성화 설정
                  );
                }).toList(),
                underline: const SizedBox.shrink(),
              );
            },
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판량",
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      revenueEntries[index]['위판량'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "무게/개수를 입력해주세요",
                    hintStyle: body2(gray4),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "단위",
          child: DropdownButton<String>(
            isExpanded: true,
            value: revenueEntries[index]['단위'] ?? 'KG',
            hint: Text("단위를 선택해주세요", style: body2(gray4)),
            onChanged: (value) {
              setState(() {
                revenueEntries[index]['단위'] = value;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'KG',
                child: Text('KG', style: body2(textBlack)),
              ),
              DropdownMenuItem<String>(
                value: '상자(C/S)',
                child: Text('상자(C/S)', style: body2(textBlack)),
              )
            ],
            underline: const SizedBox.shrink(),
          ),
        ),
        _buildRevenueFormRow(
          index: index,
          label: "위판단가",
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: revenuePriceControllers[index],
                  onChanged: (value) {
                    setState(() {
                      revenueEntries[index]['위판단가'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "수입 금액을 입력해주세요",
                    hintStyle: body2(gray4),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Text("원", style: body2(gray4)),
            ],
          ),
        ),
        Row(
          children: [
            const Spacer(),
            if (revenueEntries.length > 1) // 리스트 길이가 1 초과인 경우에만 삭제 버튼 표시
              OutlinedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, index);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.transparent),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('삭제하기 ', style: body2(alertRedBackground)),
                    const Icon(Icons.delete_forever_outlined, color: alertRedBackground),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseEntryForm(int index) {
    return Column(
      children: [
        _buildExpenseFormRow(
          index: index,
          label: "구분",
          child: DropdownButton<String>(
            isExpanded: true,
            value: expenseEntries[index]['구분'].isEmpty ? null : expenseEntries[index]['구분'],
            hint: Text("지출 구분을 선택해주세요", style: body2(gray4)),
            onChanged: (value) {
              setState(() {
                expenseEntries[index]['구분'] = value;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: '유류비',
                child: Text('유류비', style: body2(textBlack)),
              ),
              DropdownMenuItem<String>(
                value: '인건비',
                child: Text('인건비', style: body2(textBlack)),
              ),
              DropdownMenuItem<String>(
                value: '어구',
                child: Text('어구', style: body2(textBlack)),
              ),
              DropdownMenuItem<String>(
                value: '기타',
                child: Text('기타', style: body2(textBlack)),
              ),
            ],
            underline: const SizedBox.shrink(),
          ),
        ),
        _buildExpenseFormRow(
          index: index,
          label: "비용",
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      expenseEntries[index]['비용'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "지출 금액을 입력해주세요",
                    hintStyle: body2(gray4),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Text("원", style: body2(gray4)),
            ],
          ),
        ),
        Row(
          children: [
            const Spacer(),
            if (expenseEntries.length > 1) // 리스트 길이가 1 초과인 경우에만 삭제 버튼 표시
              OutlinedButton(
                onPressed: () {
                  _showDeleteExpenseConfirmationDialog(context, index);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.transparent),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('삭제하기 ', style: body2(alertRedBackground)),
                    const Icon(Icons.delete_forever_outlined, color: alertRedBackground),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showDeleteExpenseConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제"),
          content: const Text("지출 내역을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소", style: body2(primaryYellow900)),
            ),
            TextButton(
              onPressed: () {
                _deleteExpenseEntry(index);
                Navigator.pop(context);
              },
              child: Text("삭제", style: body2(primaryYellow900)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpenseFormRow({required String label, required Widget child, required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: body3(gray5)),
          ),
          Expanded(
            child: Container(
              height: 33,
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                border: Border.all(color: gray4, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
