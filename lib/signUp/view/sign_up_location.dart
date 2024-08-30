import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignUpLocation extends StatefulWidget {
  const SignUpLocation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpLocation> createState() => _SignUpLocationState();
}

class _SignUpLocationState extends State<SignUpLocation> {
  GeoPoint? latlon;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late WebViewController _controller;
  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latController.text = '${position.latitude}';
      _lngController.text = '${position.longitude}';
      _controller.runJavaScript('fromAppToWeb("${position.latitude}", "${position.longitude}");');
      latlon = GeoPoint(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginModelProvider = Provider.of<LoginModelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('반자동 조업일지 작성을 위해\n위치를 지정해주세요!', style: header1B()),
              const SizedBox(height: 8),
              Text('매번 조업위치를 입력하는 번거로움을 줄여드려요.', style: body1(gray6)),
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
                          latlon = GeoPoint(
                            double.parse(_latController.text),
                            double.parse(_lngController.text),
                          );
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
                          latlon = GeoPoint(
                            double.parse(_latController.text),
                            double.parse(_lngController.text),
                          );
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
                    NextButton(
                      value: latlon,
                      onNext: widget.onNext,
                      save: () => _showLocationModal(
                        context,
                        latlon!,
                        loginModelProvider.kakaoId,
                      ),
                    ),
                  ],
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
        ),
      ],
    );
  }
}

void _showLocationModal(BuildContext context, GeoPoint latlon, String id) {
  final TextEditingController controller = TextEditingController();

  Future<void> completeRegistration() async {
    final userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    final loginModelProvider = Provider.of<LoginModelProvider>(context, listen: false);
    // 위치 정보 등록 로직 추가
    userInformationProvider.setLocation(latlon, controller.text, id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // 로그인 상태 저장
    await prefs.setString('name', loginModelProvider.name); // 사용자 이름 저장
    await prefs.setString('uid', loginModelProvider.kakaoId); // 사용자 이름 저장
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    backgroundColor: backgroundWhite,
    builder: (BuildContext context) {
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
                onPressed: controller.text.isEmpty ? () => {} : completeRegistration,
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
