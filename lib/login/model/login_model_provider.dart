import 'package:flutter/material.dart';

class LoginModelProvider with ChangeNotifier {
  String _name = '';
  String _kakaoId = '123';

  // Getters
  String get name => _name;
  String get kakaoId => _kakaoId;

  // Setters with notifyListeners to update UI when data changes
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setKakaoId(String kakaoId) {
    _kakaoId = kakaoId;
    notifyListeners();
  }
}
