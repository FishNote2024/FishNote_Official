import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPermission extends StatefulWidget {
  const SignUpPermission({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<SignUpPermission> createState() => _SignUpPermissionState();
}

class _SignUpPermissionState extends State<SignUpPermission> {
  bool _fullAgree = false;
  bool _serviceAgree = false;
  bool _privacyAgree = false;
  bool _locationAgree = false;
  bool _ageAgree = false;

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          NextButton(value: _fullAgree ? "agree" : "", onNext: widget.onNext, save: () {}),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text("약관에 동의하고\n조업일지를 무료로 이용하세요", style: header1B()),
          const SizedBox(height: 48),
          CheckboxListTile(
            title: const Text("전체 약관에 동의합니다"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: gray2),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            checkColor: backgroundWhite,
            activeColor: primaryBlue500,
            value: _fullAgree,
            onChanged: (value) => {
              setState(() {
                _serviceAgree = value!;
                _privacyAgree = value;
                _locationAgree = value;
                _ageAgree = value;
                _fullAgree = value;
              })
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => {
                  setState(() {
                    _serviceAgree = !_serviceAgree;
                    _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                  }),
                },
                label: Text("서비스 이용약관 (필수)", style: body2(gray8)),
                icon: Icon(Icons.check_rounded, color: _serviceAgree ? primaryBlue400 : gray2),
              ),
              TextButton(
                  onPressed: () => _launchURL(Uri.parse(
                      'https://docs.google.com/document/d/1zfLtufAEKG5JRNrn9b_EuJyxWO8jpw3EIrd2f5bDNEs/edit?usp=sharing')),
                  child: Text("보기", style: caption1(gray5))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => {
                  setState(() {
                    _privacyAgree = !_privacyAgree;
                    _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                  }),
                },
                label: Text("개인정보 처리방침 (필수)", style: body2(gray8)),
                icon: Icon(Icons.check_rounded, color: _privacyAgree ? primaryBlue400 : gray2),
              ),
              TextButton(
                  onPressed: () => _launchURL(Uri.parse(
                      'https://docs.google.com/document/d/1PGIXls8ln1CyTLeGe67UePsapXoZfefWrbeYZn-eMKU/edit?usp=sharing')),
                  child: Text("보기", style: caption1(gray5))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => {
                  setState(() {
                    _locationAgree = !_locationAgree;
                    _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                  }),
                },
                label: Text("위치정보 서비스 이용약관 (필수)", style: body2(gray8)),
                icon: Icon(Icons.check_rounded, color: _locationAgree ? primaryBlue400 : gray2),
              ),
              TextButton(
                  onPressed: () => _launchURL(Uri.parse(
                      'https://docs.google.com/document/d/1gDxCWqtUtuxF6DIqRmqCzBnFjCt7NPtqWwT-pLVA7cA/edit?usp=sharing')),
                  child: Text("보기", style: caption1(gray5))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => {
                  setState(() {
                    _ageAgree = !_ageAgree;
                    _fullAgree = _ageAgree && _serviceAgree && _privacyAgree && _locationAgree;
                  }),
                },
                label: Text("만 14세 이상입니다 (필수)", style: body2(gray8)),
                icon: Icon(Icons.check_rounded, color: _ageAgree ? primaryBlue400 : gray2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
