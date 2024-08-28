import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_note/signUp/model/location.dart';
import 'package:flutter/material.dart';

class UserInformationProvider with ChangeNotifier {
  String _ageRange = '';
  String _yearExperience = '';
  String _affiliation = '';
  Set<String> _species = {};
  Set<String> _technique = {};
  final Location _location = Location('', const GeoPoint(0, 0));
  final List<Location> _favorites = [];

  // Getters
  String get ageRange => _ageRange;
  String get yearExperience => _yearExperience;
  String get affiliation => _affiliation;
  Set<String> get species => _species;
  Set<String> get technique => _technique;
  Location get location => _location;
  List<Location> get favorites => _favorites;

  final db = FirebaseFirestore.instance;

  Future<void> init(String id) async {
    final docRef = db.collection("users").doc(id);
    try {
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _ageRange = data['ageRange'];
        _yearExperience = data['yearExperience'];
        _affiliation = data['affiliation'];
        _species = Set<String>.from(data['species']);
        _technique = Set<String>.from(data['technique']);
        _location.setName(data['location']['name']);
        _location.setLatlon(data['location']['latlon']);
        _favorites.clear();
        for (var favorite in data['favorites']) {
          _favorites.add(Location(favorite['name'], (favorite['latlon'])));
        }
        notifyListeners();
      } else {
        print('Document does not exist in Firestore');
      }
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  // Setters with notifyListeners to update UI when data changes
  void setAgeRange(String ageRange, String id) async {
    _ageRange = ageRange;
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'ageRange': _ageRange,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void setYearExperience(String yearExperience, String id) async {
    _yearExperience = yearExperience;
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'yearExperience': _yearExperience,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void setAffiliation(String affiliation, String id) async {
    _affiliation = affiliation;
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'affiliation': _affiliation,
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void setSpecies(Set<String> species, String id) async {
    _species = species;
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'species': _species.toList(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void setTechnique(Set<String> technique, String id) async {
    _technique = technique;
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'technique': _technique.toList(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void setLocation(GeoPoint latlon, String name, String id) async {
    _location.setName(name);
    _location.setLatlon(latlon);
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'location': {
        'name': name,
        'latlon': latlon,
      },
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void addFavorite(GeoPoint latlon, String name, String id) async {
    Location newFavorite = Location(name, latlon);
    _favorites.add(newFavorite);
    final docRef = db.collection("users").doc(id);
    await docRef.set({
      'favorites': FieldValue.arrayUnion([
        {
          'name': name,
          'latlon': latlon,
        }
      ]),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  void removeFavorite(Location location, String id) async {
    _favorites.remove(location);
    final docRef = db.collection("users").doc(id);
    await docRef.update({
      'favorites': FieldValue.arrayRemove([
        {
          'name': location.name,
          'latlon': location.latlon,
        }
      ]),
    });
    notifyListeners();
  }

  void removeSpecies(String species, String id) async {
    _species.remove(species);
    final docRef = db.collection("users").doc(id);
    await docRef.update({
      'species': FieldValue.arrayRemove([species]),
    });
    notifyListeners();
  }

  void removeTechnique(String technique, String id) async {
    _technique.remove(technique);
    final docRef = db.collection("users").doc(id);
    await docRef.update({
      'technique': FieldValue.arrayRemove([technique]),
    });
    notifyListeners();
  }
}
