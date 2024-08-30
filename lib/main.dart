import 'package:fish_note/favorites/view/favorites_view.dart';
import 'package:fish_note/home/model/ledger_model.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'Ledger/view/tab_bar_view.dart';
import 'signUp/model/user_information_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue500),
        scaffoldBackgroundColor: backgroundBlue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/login': (context) => const LoginView(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signUp': (context) => const SignUpView(),
        '/home': (context) => const Home(),
        '/ledger1': (context) => const LedgerTabBarView(initialTabIndex: 0),
        '/ledger2': (context) => const LedgerTabBarView(initialTabIndex: 1),
        '/onBoarding': (context) => OnboardingScreen(),
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
