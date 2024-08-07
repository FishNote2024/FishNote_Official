import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignUpLocation extends StatefulWidget {
  const SignUpLocation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpLocation> createState() => _SignUpLocationState();
}

class _SignUpLocationState extends State<SignUpLocation> {
  String? location;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString('''
      <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>지도</title>
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/openlayers/2.13.1/theme/default/style.css" type="text/css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/openlayers/2.13.1/OpenLayers.js" type="text/javascript"></script>
        <script src="http://www.khoa.go.kr/oceanmap/js/proj4js-1.1.0/lib/proj4js.js" type="text/javascript"></script>
        <script src="http://www.khoa.go.kr/oceanmap/js/proj4js-1.1.0/lib/defs/EPSG5179.js" type="text/javascript"></script>
        <script src="http://www.khoa.go.kr/oceanmap/js/gis/OtmsApi.js" type="text/javascript"></script>
        <!-- 개방海 지도 서비스 호출 -->
        <script src="http://www.khoa.go.kr/oceanmap/BASEMAP_MOBILE/otmsBasemapApi.do?ServiceKey=E7B2BB13B189926AD1A925C2F" type="text/javascript"></script>
        
        <script type="text/javascript">
          var map;
            
          var OtmsLayer;
          var mapCenterX='956498.5710969';
          var mapCenterY='1819967.0629328';
          var numZoomLevels = 11;
          var zoomLevel = 1;
            
          // 지도의 영역을 지정
          var mapBounds = new OpenLayers.Bounds(123 , 32, 132 , 43);  
            
          // avoid pink tiles
          OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
          OpenLayers.Util.onImageLoadErrorColor = "transparent";
        
          function init() {
            var options = {
              projection : new OpenLayers.Projection("EPSG:5179"), //지도의 좌표계
              displayProjection: new OpenLayers.Projection("EPSG:4326"),
              maxExtent : new OpenLayers.Bounds(-200000.0, -3015.4524155292, 3803015.45241553, 4000000.0),
              restrictedExtent : new OpenLayers.Bounds(37953.1466, 1126946.7253, 2152527.8074, 2873292.7040),
              center : new OpenLayers.LonLat(mapCenterX, mapCenterY),
              allOverlays: true,
              maxResolution : 1954.597389,//지도의 해상도
              numZoomLevels: numZoomLevels,
              layers : [ OtmsLayer ],
              controls : [
                new OpenLayers.Control.Navigation(),
                new OpenLayers.Control.PanZoomBar(),
                new OpenLayers.Control.ScaleLine(),
              ],
              // 사용자 이벤트 등록 
              eventListeners: {
                featureover: function(e) {  // feature에 마우스오버시
                  e.feature.renderIntent = "select";
                  e.feature.layer.drawFeature(e.feature);
                  console.log("featureover");
                },
                featureout: function(e) {   // feature에 마우스아웃시
                  e.feature.renderIntent = "default";
                  e.feature.layer.drawFeature(e.feature);
                  console.log("featureout");
                },
                featureclick: function(e) { // feature에 마우스클릭시
                  console.log("featureclick e.feature.id = " + e.feature.id);
                }
              }
            };
            map = new OpenLayers.Map('map', options);       // html의 'map'div 태그에 지도를 그려주도록 세팅
            
            map.zoomToExtent( mapBounds.transform(map.displayProjection, map.projection ) );
            // 지도 센터 설정
            map.setCenter([mapCenterX,mapCenterY]);
            // 지도 초기 레벨 설정
            map.zoomTo(zoomLevel);
          }
        </script>
      </head>
  
      <body onload="init()" style="margin: 0;">
        <div id="map" style="height:100%;"></div>
      </body>
  
    </html>
    ''');
    // ..loadRequest(Uri.parse("http://www.khoa.go.kr/oceanmap/main.do"));
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
                        if (_latController.text.isNotEmpty) {}
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
                        if (_lngController.text.isNotEmpty) {}
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
                          onPressed: () => {
                            setState(() {
                              location = '현재 위치 좌표값 get';
                            }),
                          },
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
                    NextButton(value: location, onNext: widget.onNext),
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
