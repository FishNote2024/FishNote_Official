import 'package:flutter/material.dart';

class UserInformationProvider with ChangeNotifier {
  String _ageRange = '';
  String _yearExperience = '';
  String _affiliation = '';
  List<String> _species = [];
  List<String> _technique = [];
  Map<String, Object> _location = {};

  // Getters
  String get ageRange => _ageRange;
  String get yearExperience => _yearExperience;
  String get affiliation => _affiliation;
  List<String> get species => _species;
  List<String> get technique => _technique;
  Map<String, Object> get location => _location;

  // Setters with notifyListeners to update UI when data changes
  void setAgeRange(String ageRange) {
    _ageRange = ageRange;
    notifyListeners();
  }

  void setYearExperience(String yearExperience) {
    _yearExperience = yearExperience;
    notifyListeners();
  }

  void setAffiliation(String affiliation) {
    _affiliation = affiliation;
    notifyListeners();
  }

  void setSpecies(List<String> species) {
    _species = species;
    notifyListeners();
  }

  void setTechnique(List<String> technique) {
    _technique = technique;
    notifyListeners();
  }

  void setLocation(Map<String, Object> location) {
    _location = location;
    notifyListeners();
  }
}
