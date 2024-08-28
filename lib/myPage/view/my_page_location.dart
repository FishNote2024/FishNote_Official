import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/myPage/components/bottom_button.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPageLocation extends StatefulWidget {
  const MyPageLocation({super.key});

  @override
  State<MyPageLocation> createState() => _MyPageLocationState();
}

class _MyPageLocationState extends State<MyPageLocation> {
  List<double>? latlon;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late WebViewController _controller;
  late UserInformationProvider userInformationProvider;

  @override
  void initState() {
    super.initState();
    userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    latlon = List.from(userInformationProvider.location.latlon);
    _latController.text = userInformationProvider.location.latlon[0].toString();
    _lngController.text = userInformationProvider.location.latlon[1].toString();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://fish-note-map.vercel.app"))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // 페이지 로드가 완료된 후에 JavaScript를 실행합니다.
            _controller.runJavaScript('fromAppToWeb("${latlon![0]}", "${latlon![1]}");');
          },
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('주요 조업 위치 변경하기', style: body2()),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('주요 조업 위치를 지정해주세요', style: header3B()),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('위도', style: body1()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _getLocation,
                            icon: SvgPicture.asset(
                              'assets/icons/current_location.svg',
                              colorFilter: const ColorFilter.mode(primaryBlue500, BlendMode.srcIn),
                            ),
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
                    ),
                    // 한 번 하고 나면 다시 띄우지 않음
                    BottomButton(
                      text: "해당 위치로 수정하기",
                      value: latlon,
                      onPressed: () => _showLocationModal(
                          context, latlon!, userInformationProvider.location.name),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showLocationModal(BuildContext context, List<double> latlon, String name) {
  final TextEditingController controller = TextEditingController();
  controller.text = name;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    backgroundColor: backgroundWhite,
    builder: (BuildContext context) {
      final userInformationProvider = Provider.of<UserInformationProvider>(context);

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '주요 조업 위치의 별명을 입력해주세요',
                style: header3B(),
              ),
              const SizedBox(height: 18),
              TextField(
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: controller,
                cursorColor: primaryBlue500,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundWhite,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: primaryBlue500,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  hintText: '지역 별명을 입력해주세요',
                  hintStyle: body1(gray3),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: (controller.text == name || controller.text.isEmpty) &&
                        (latlon[0] == userInformationProvider.location.latlon[0] &&
                            latlon[1] == userInformationProvider.location.latlon[1])
                    ? () => showSnackBar(context, '별명이나 위치가 변경되지 않았습니다.')
                    : () {
                        userInformationProvider.setLocation(
                          latlon,
                          controller.text,
                        );
                        Navigator.pop(context);
                        // 별명 등록 로직 추가
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  backgroundColor: primaryBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('등록하기', style: header4(backgroundWhite)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
