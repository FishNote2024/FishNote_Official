import 'package:fish_note/signUp/components/bottom_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddThrowNetPage extends StatefulWidget {
  const AddThrowNetPage({super.key});

  @override
  State<AddThrowNetPage> createState() => _AddThrowNetPageState();
}

class _AddThrowNetPageState extends State<AddThrowNetPage> {
  List<double>? latlon;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late WebViewController _controller;
  String todayDate = DateFormat('M월 d일 (E)', 'ko_KR').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://fish-note-map.vercel.app"));
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latController.text = '${position.latitude}';
      _lngController.text = '${position.longitude}';
      _controller.runJavaScript(
          'fromAppToWeb("${position.latitude}", "${position.longitude}");');
      latlon = [position.latitude, position.longitude];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${todayDate} 기록하기", style: body2(textBlack)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15, color: gray7),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('투망 위치를 확인해주세요', style: header1B()),
                const SizedBox(height: 8),
                Text('지도에서 위치를 직접 선택하거나\n위도경도를 직접 입력해서 위치를 조정할 수 있습니다.',
                    style: body1(gray6)),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('위도', style: header3B(gray8)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        controller: _latController,
                        cursorColor: primaryBlue500,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (value) => setState(() {
                          if (_latController.text.isNotEmpty &&
                              _lngController.text.isNotEmpty) {
                            _controller.runJavaScript(
                              'fromAppToWeb("${_latController.text}", "${_lngController.text}");',
                            );
                            latlon = [
                              double.parse(_latController.text),
                              double.parse(_lngController.text)
                            ];
                          }
                        }),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundWhite,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: _latController.text.isEmpty
                                  ? gray2
                                  : primaryBlue500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: primaryBlue500,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: _latController.text.isEmpty
                                  ? gray2
                                  : primaryBlue500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text('경도', style: header3B(gray8)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        controller: _lngController,
                        cursorColor: primaryBlue500,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (value) => setState(() {
                          if (_latController.text.isNotEmpty &&
                              _lngController.text.isNotEmpty) {
                            _controller.runJavaScript(
                              'fromAppToWeb("${_latController.text}", "${_lngController.text}");',
                            );
                            latlon = [
                              double.parse(_latController.text),
                              double.parse(_lngController.text)
                            ];
                          }
                        }),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundWhite,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: _lngController.text.isEmpty
                                  ? gray2
                                  : primaryBlue500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: primaryBlue500,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: _lngController.text.isEmpty
                                  ? gray2
                                  : primaryBlue500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _getLocation,
                            icon: SvgPicture.asset(
                              'assets/icons/current_location.svg',
                              colorFilter: const ColorFilter.mode(
                                  primaryBlue500, BlendMode.srcIn),
                            ),
                            color: primaryBlue500,
                            iconSize: 18.5,
                            style: IconButton.styleFrom(
                              backgroundColor: backgroundWhite,
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: gray2,
                                  width: 1,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      BottomButton(
                        text: '다음',
                        onPressed: () {
                          // if (latlon != null) {
                          //   Navigator.pushNamed(context, '/addNet',
                          //       arguments: latlon);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
