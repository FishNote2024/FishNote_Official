import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/view/home/home_view.dart';
import 'package:fish_note/view/signUp/sign_up_affiliation.dart';
import 'package:fish_note/view/signUp/sign_up_location.dart';
import 'package:fish_note/view/signUp/sign_up_technique.dart';
import 'package:fish_note/view/signUp/sign_up_permission.dart';
import 'package:fish_note/view/signUp/sign_up_species.dart';
import 'package:fish_note/view/signUp/sign_up_age_range.dart';
import 'package:fish_note/view/signUp/sign_up_year_experience.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '5df0c1f5ae7c5485d949731c13179fc3');
  runApp(const MyApp());
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
        '/': (context) => const MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signUp/yearExperience': (context) => const SignUpYearExperience(),
        '/signUp/ageRange': (context) => const SignUpAgeRange(),
        '/signUp/affiliation': (context) => const SignUpAffiliation(),
        '/signUp/species': (context) => const SignUpSpecies(),
        '/signUp/technique': (context) => const SignUpTechnique(),
        '/signUp/permission': (context) => const SignUpPermission(),
        '/signUp/location': (context) => const SignUpLocation(),
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
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpYearExperience(),
              ),
            )
          },
          child: const Text("Sign Up"),
        ),
      ),
    );
  }
}
