import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String _name = '';
  GeoPoint _latlon = const GeoPoint(0, 0);

  String get name => _name;
  GeoPoint get latlon => _latlon;

  Location(this._name, this._latlon);

  void setName(String name) {
    _name = name;
  }

  void setLatlon(GeoPoint latlon) {
    _latlon = latlon;
  }
}
