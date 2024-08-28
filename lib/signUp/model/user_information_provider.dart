import 'package:fish_note/signUp/model/location.dart';
import 'package:flutter/material.dart';

class UserInformationProvider with ChangeNotifier {
  String _ageRange = '';
  String _yearExperience = '';
  String _affiliation = '';
  Set<String> _species = {};
  Set<String> _technique = {};
  final Location _location = Location('', []);
  final List<Location> _favorites = [];

  // Getters
  String get ageRange => _ageRange;
  String get yearExperience => _yearExperience;
  String get affiliation => _affiliation;
  Set<String> get species => _species;
  Set<String> get technique => _technique;
  Location get location => _location;
  List<Location> get favorites => _favorites;

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

  void setSpecies(Set<String> species) {
    _species = species;
    notifyListeners();
  }

  void setTechnique(Set<String> technique) {
    _technique = technique;
    notifyListeners();
  }

  void setLocation(List<double> latlon, String name) {
    _location.setName(name);
    _location.setLatlon(latlon);
    notifyListeners();
  }

  void addFavorite(List<double> latlon, String name) {
    Location newFavorite = Location(name, latlon);
    _favorites.add(newFavorite);
    notifyListeners();
  }
}
