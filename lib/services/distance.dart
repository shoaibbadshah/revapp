import 'dart:convert';

import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:avenride/app/router_names.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Calculate {
  Position _currentPosition = Position(
      longitude: 51.457838,
      latitude: -0.596342,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: null);
  Position get currentPosition => _currentPosition;
  Future calculateDis(
      {required PickResult selectedPlac,
      required PickResult dropoffplac,
      required String formtype}) async {
    Geodesy geodesy = Geodesy();
    num distance = geodesy.distanceBetweenTwoGeoPoints(
            LatLng(selectedPlac.geometry!.location.lat,
                selectedPlac.geometry!.location.lng),
            LatLng(dropoffplac.geometry!.location.lat,
                dropoffplac.geometry!.location.lng)) /
        1000;
    num rate = 0;
    final placeRate = formtype == Cartype
        ? (distance * 1000.05).toStringAsFixed(2)
        : formtype == Taxi
            ? (distance * 800.50).toStringAsFixed(2)
            : formtype == Ambulance
                ? (distance * 1500.50).toStringAsFixed(2)
                : formtype == DeliveryService
                    ? (distance * 1200.50).toStringAsFixed(2)
                    : 0;
    if (formtype == Ambulance) {
      rate = distance * 1500;
    }

    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${selectedPlac.geometry!.location.lat},${selectedPlac.geometry!.location.lng}&destinations=${dropoffplac.geometry!.location.lat}%2C${dropoffplac.geometry!.location.lng}&key=AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw'),
    );
    print('############ $response');
    print(jsonDecode(response.body));
    final data = jsonDecode(response.body);
    print(data['rows'][0]['elements'][0]['distance']['text']);
    print(data['rows'][0]['elements'][0]['duration']['text']);
    return {
      'distance': distance.toStringAsFixed(2),
      'duration': data['rows'][0]['elements'][0]['duration']['text'],
      'placeRate': placeRate,
      'rate': rate,
    };
  }

  Future getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentPosition = position;
      }).catchError((e) {
        print(e);
      });
    }
  }
}
