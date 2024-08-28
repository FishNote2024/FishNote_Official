import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginModelProvider with ChangeNotifier {
  String _name = '';
  String _kakaoId = '';

  // Getters
  String get name => _name;
  String get kakaoId => _kakaoId;

  final db = FirebaseFirestore.instance;

  // Setters with notifyListeners to update UI when data changes
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setKakaoId(String kakaoId) {
    _kakaoId = kakaoId;
    notifyListeners();
  }

  // Save name to Firestore
  void saveName() async {
    final docRef = db.collection("users").doc(_kakaoId);
    await docRef.set({
      'name': _name,
    }, SetOptions(merge: true));
    notifyListeners();
  }
}
