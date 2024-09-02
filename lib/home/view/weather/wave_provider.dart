import 'package:flutter/material.dart';

class WaveProvider with ChangeNotifier {
  String _wave = "";
  bool _isSet = false;  // 데이터 저장 여부를 확인하는 플래그

  String get wave => _wave;
  bool get isSet => _isSet;

  void setWavString(String newWavString) {
    if (!_isSet) {
      _wave = newWavString;
      _isSet = true;
      notifyListeners();
    }
  }
}
