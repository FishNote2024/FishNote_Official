import 'package:flutter/material.dart';

class WaveProvider with ChangeNotifier {
  String _wave = "";// 데이터 저장 여부를 확인하는 플래그

  String get wave => _wave;

  void setWavString(String newWavString) {
      _wave = newWavString;
      notifyListeners();
    }
}
