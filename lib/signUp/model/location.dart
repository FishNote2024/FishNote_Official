class Location {
  String _name = '';
  List<double> _latlon = [];

  String get name => _name;
  List<double> get latlon => _latlon;

  Location(this._name, this._latlon);

  void setName(String name) {
    _name = name;
  }

  void setLatlon(List<double> latlon) {
    _latlon = latlon;
  }
}
