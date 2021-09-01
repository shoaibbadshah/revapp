import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  LatLng _currentLocation = LatLng(51.457838, -0.596342);
  LatLng get currentLocation => _currentLocation;

  getCurrentLocation() {
    Location location = Location();
    location.currentLocation;
  }
}
