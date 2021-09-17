import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  LatLng _currentLocation = LatLng(51.457838, -0.596342);
  LatLng get currentLocation => _currentLocation;

  getCurrentLocation() async {
    Location location = Location();
    final loc = await location.getLocation();
    return loc;
  }
}
