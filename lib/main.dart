import 'package:dio/dio.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/home/view/home_view.dart';
import 'package:fish_note/signUp/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  const String apiUrl =
      'http://apis.data.go.kr/1192000/select0030List/getselect0030List';
  const String apiKey =
      'P9snIt2gDleusE4uaQ9a1Tyx6/QaQRBJjRzr9H4ELGzbp263NM0Fvprpu1mr6Qqu6Efxqu35tgxg0JeKZtRnHA==';
  final DateTime baseDt = DateTime.now();
  const String mprcStdCodeNm = "우럭";
  KakaoSdk.init(nativeAppKey: '5df0c1f5ae7c5485d949731c13179fc3');
  runApp(const MyApp());
  Dio dio = Dio();
  dio.options = BaseOptions(
    baseUrl:
        "http://apis.data.go.kr/1192000/select0030List/getselect0030List", // 요청의 기본 URL

    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  );
  var dios = Dio();

  try {
    // GET 요청
    var response = await dios.get(
        '$apiUrl?serviceKey=$apiKey&pageNo=1&numOfRows=10&baseDt=$baseDt&mprcStdCodeNm=$mprcStdCodeNm&type=xml');

    if (response.statusCode == 200) {
      // 성공 처리
      print('🥨 Response data: ${response.data}');
    } else {
      // 에러 처리
      print('🥨 Error: ${response.statusCode}');
    }
  } catch (e) {
    // 예외 처리
    print('🥨 Exception occurred: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.

        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue500),
        scaffoldBackgroundColor: backgroundBlue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signUp': (context) => const SignUpView(),
        '/home': (context) => const Home(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => {Navigator.pushNamed(context, '/signUp')},
          child: const Text("Sign Up"),
        ),
      ),
    );
  }
}
