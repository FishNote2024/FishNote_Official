import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_note/favorites/components/modal_bottom_sheet.dart';
import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/signUp/model/location.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  LocationInfo locationInfo = LocationInfo(
    '',
    const GeoPoint(0, 0),
  );
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late WebViewController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    String? mapUrl = dotenv.env['MAP_URL'];
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("toApp", onMessageReceived: (JavaScriptMessage message) {
        message.message == "marker touched"
            ? showLocationBottomSheet(context, locationInfo, _nameController)
            : null;
      })
      ..loadRequest(Uri.parse(mapUrl!));
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true; // 로딩 상태로 전환
    });

    Location location = Location();
    location.enableBackgroundMode(enable: false);
    if (await location.serviceEnabled()) {
      if (await location.hasPermission() == PermissionStatus.granted) {
        LocationData position = await location.getLocation();

        setState(() {
          _latController.text = '${position.latitude}';
          _lngController.text = '${position.longitude}';
          if ((position.latitude! > 31 && position.latitude! < 40) &&
              (position.longitude! > 120 && position.longitude! < 132)) {
            _controller
                .runJavaScript('fromAppToWeb("${position.latitude}", "${position.longitude}");');
            locationInfo.setLatlon(GeoPoint(position.latitude!, position.longitude!));
          } else {
            showSnackBar(context, '지도의 범위 밖입니다. 다시 시도해주세요.');
          }
        });
      } else {
        if (!mounted) return;
        showSnackBar(context, '위치 권한이 없습니다.');
      }
    } else {
      if (!mounted) return;
      showSnackBar(context, '위치 서비스가 비활성화되어 있습니다.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('해상 지도', style: body2()),
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
                Text('지도에서 위치를 직접 선택하거나\n위도 경도를 직접 입력해서 위치를 조정할 수 있습니다.', style: body1()),
                const SizedBox(height: 24),
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
                        onSubmitted: (value) => setState(() {
                          if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty) {
                            if ((double.parse(_latController.text) > 31 &&
                                    double.parse(_latController.text) < 40) &&
                                (double.parse(_lngController.text) > 120 &&
                                    double.parse(_lngController.text) < 132)) {
                              _controller.runJavaScript(
                                'fromAppToWeb("${_latController.text}", "${_lngController.text}");',
                              );
                              locationInfo.setLatlon(GeoPoint(double.parse(_latController.text),
                                  double.parse(_lngController.text)));
                            } else {
                              showSnackBar(context, '지도의 범위 밖입니다. 다시 시도해주세요.');
                            }
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
                        onSubmitted: (value) => setState(() {
                          if (_latController.text.isNotEmpty && _lngController.text.isNotEmpty) {
                            if ((double.parse(_latController.text) > 31 &&
                                    double.parse(_latController.text) < 40) &&
                                (double.parse(_lngController.text) > 120 &&
                                    double.parse(_lngController.text) < 132)) {
                              _controller.runJavaScript(
                                'fromAppToWeb("${_latController.text}", "${_lngController.text}");',
                              );
                              locationInfo.setLatlon(GeoPoint(double.parse(_latController.text),
                                  double.parse(_lngController.text)));
                            } else {
                              showSnackBar(context, '지도의 범위 밖입니다. 다시 시도해주세요.');
                            }
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => showFavoriteBottomSheet(context, _controller,
                                _latController, _lngController, _nameController, locationInfo),
                            icon: const Icon(Icons.star_rate_rounded),
                            color: primaryBlue500,
                            iconSize: 24,
                            style: IconButton.styleFrom(
                              backgroundColor: backgroundWhite,
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: gray2,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _getLocation();
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/current_location.svg',
                              colorFilter: const ColorFilter.mode(primaryBlue500, BlendMode.srcIn),
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: backgroundWhite,
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: gray2,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: backgroundWhite.withOpacity(0.8),
                        child:
                            const Center(child: CircularProgressIndicator(color: primaryBlue500)),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
