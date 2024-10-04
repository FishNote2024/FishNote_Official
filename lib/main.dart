import 'dart:async';
import 'dart:math';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:fish_note/favorites/view/favorites_view.dart';
import 'package:fish_note/home/model/ledger_model.dart';
import 'package:fish_note/home/view/weather/wave_provider.dart';
import 'package:fish_note/journal/view/journal_view.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/login/view/login_view.dart';
import 'package:fish_note/net/model/net_record.dart';
import 'package:fish_note/myPage/view/my_page_view.dart';
import 'package:fish_note/net/view/net_tab_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fish_note/firebase_options.dart';
import 'package:fish_note/net/view/throw_net/add_throw_net_page.dart';
import 'package:fish_note/onBoarding/on_boarding.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/home/view/home_view.dart';
import 'package:fish_note/signUp/view/sign_up_view.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'Ledger/view/tab_bar_view.dart';
import 'signUp/model/user_information_provider.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

String generateRandomKey(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random.secure();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

// 암호화 키를 생성하거나 저장된 키를 불러오는 함수
Future<String> getEncryptionKey() async {
  // 이미 저장된 키가 있는지 확인
  String? encryptionKey = await secureStorage.read(key: 'encryption_key');

  // 저장된 키가 없으면 새로 생성
  if (encryptionKey == null) {
    // 새로운 암호화 키를 생성 (16바이트)
    encryptionKey = generateRandomKey(16);

    // 새로 생성한 키를 안전하게 저장
    await secureStorage.write(key: 'encryption_key', value: encryptionKey);
  }

  return encryptionKey;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String encryptionKey = await getEncryptionKey();
  await EncryptedSharedPreferences.initialize(encryptionKey);
  await dotenv.load(fileName: ".env");
  String kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY']!;
  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
  await initializeDateFormatting('ko_KR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInformationProvider()),
        ChangeNotifierProvider(create: (_) => NetRecordProvider()),
        ChangeNotifierProvider(create: (_) => LoginModelProvider()),
        ChangeNotifierProvider(create: (_) => LedgerProvider()),
        ChangeNotifierProvider(create: (_) => WaveProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue500),
        scaffoldBackgroundColor: backgroundBlue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signUp': (context) => const SignUpView(),
        '/home': (context) => const Home(),
        '/ledger1': (context) => const LedgerTabBarView(initialTabIndex: 0),
        '/ledger2': (context) => const LedgerTabBarView(initialTabIndex: 1),
        '/onBoarding': (context) => const OnboardingScreen(),
        '/netPage1': (context) => const NetTabBarView(initialTabIndex: 0),
        '/netPage2': (context) => const NetTabBarView(initialTabIndex: 1),
        '/myPage': (context) => const MyPageView(),
        '/journal': (context) => const JournalView(),
        '/getNetAddFishWeight': (context) => const AddThrowNetPage(),
        '/favorites': (context) => const FavoritesView(),
      },
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const LoginView(),
          transitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('이제 어업도 감이 아닌 데이터로!', style: body2(gray4)),
              const SizedBox(height: 3),
              Text('무료 조업일지, 피시노트', style: header3R()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    height: 150,
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/icons/splash_back.svg',
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
