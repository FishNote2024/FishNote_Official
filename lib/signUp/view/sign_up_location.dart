import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignUpLocation extends StatefulWidget {
  const SignUpLocation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpLocation> createState() => _SignUpLocationState();
}

class _SignUpLocationState extends State<SignUpLocation> {
  List<double>? latlon;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late WebViewController _controller;

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
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latController.text = '${position.latitude}';
      _lngController.text = '${position.longitude}';
      _controller.runJavaScript('fromAppToWeb("${position.latitude}", "${position.longitude}");');
      latlon = [position.latitude, position.longitude];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('정확한 계산을 위해\n조업 정보를 알려주세요!', style: header1B()),
              const SizedBox(height: 8),
              Text('데이터 분석 이외에 다른 용도로 사용되지 않아요.', style: body1(gray6)),
              const SizedBox(height: 19),
              Text('주요 조업 위치를 지정해주세요', style: header3B()),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('위도', style: body1()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _latController,
                      cursorColor: primaryBlue500,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) => setState(() {
                        if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty) {
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
                            color: _latController.text.isEmpty ? gray2 : primaryBlue500,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                            color: _latController.text.isEmpty ? gray2 : primaryBlue500,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text('경도', style: body1()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _lngController,
                      cursorColor: primaryBlue500,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) => setState(() {
                        if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty) {
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
                            color: _lngController.text.isEmpty ? gray2 : primaryBlue500,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                            color: _lngController.text.isEmpty ? gray2 : primaryBlue500,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                            colorFilter: const ColorFilter.mode(primaryBlue500, BlendMode.srcIn),
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
                    // 한 번 하고 나면 다시 띄우지 않음
                    NextButton(value: latlon, onNext: widget.onNext),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
