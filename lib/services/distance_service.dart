import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

Future getCurrentLatLng() async {
  if (await Permission.location.request().isGranted) {
    Location location = Location();
    LocationData _pos = await location.getLocation();
    return {'latitude': _pos.latitude!, 'longitude': _pos.longitude!};
  }
}
