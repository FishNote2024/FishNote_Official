import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/signUp/view/sign_up_affiliation.dart';
import 'package:fish_note/signUp/view/sign_up_age_range.dart';
import 'package:fish_note/signUp/view/sign_up_location.dart';
import 'package:fish_note/signUp/view/sign_up_permission.dart';
import 'package:fish_note/signUp/view/sign_up_species.dart';
import 'package:fish_note/signUp/view/sign_up_technique.dart';
import 'package:fish_note/signUp/view/sign_up_year_experience.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  int _currentPage = 0;
  final int _totalPages = 7;

  void _nextPage() {
    setState(() {
      if (_currentPage < _totalPages - 1) {
        _currentPage += 1;
      }
    });
  }

  Widget _getPage() {
    switch (_currentPage) {
      case 0:
        return SignUpPermission(onNext: _nextPage);
      case 1:
        return SignUpYearExperience(onNext: _nextPage);
      case 2:
        return SignUpAgeRange(onNext: _nextPage);
      case 3:
        return SignUpAffiliation(onNext: _nextPage);
      case 4:
        return SignUpSpecies(onNext: _nextPage);
      case 5:
        return SignUpTechnique(onNext: _nextPage);
      case 6:
        return SignUpLocation(onNext: _nextPage);
      default:
        return SignUpYearExperience(onNext: _nextPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded, color: Colors.black),
          onPressed: () {
            setState(() {
              if (_currentPage > 0) {
                _currentPage -= 1;
              } else {
                Navigator.pop(context);
              }
            });
          },
        ),
      ),
      body: _currentPage != _totalPages - 1
          ? Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearPercentIndicator(
                    percent: _currentPage / (_totalPages - 1),
                    backgroundColor: primaryYellow50,
                    progressColor: primaryYellow500,
                    lineHeight: 4,
                    barRadius: const Radius.circular(4),
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                  Expanded(
                    child: _getPage(),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearPercentIndicator(
                    percent: _currentPage / (_totalPages - 1),
                    backgroundColor: primaryYellow50,
                    progressColor: primaryYellow500,
                    lineHeight: 4,
                    barRadius: const Radius.circular(4),
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                ),
                Expanded(
                  child: _getPage(),
                ),
              ],
            ),
    );
  }
}
