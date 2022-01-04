import 'dart:convert';

import 'package:avenride/services/distance_service.dart';
import 'package:flutter/services.dart';
import 'package:geodesy/geodesy.dart';
import 'package:avenride/app/router_names.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Calculate {
  LatLng _currentPosition = LatLng(
    51.457838,
    -0.596342,
  );
  var googleGeocoding =
      GoogleGeocoding("AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw");
  LatLng get currentPosition => _currentPosition;
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

    final data = jsonDecode(response.body);
    return {
      'distance': distance.toStringAsFixed(2),
      'duration': data['rows'][0]['elements'][0]['duration']['text'],
      'placeRate': placeRate,
      'rate': rate,
    };
  }

  Future calculateDistan(
      {required double selectedPlac1,
      required double selectedPlac2,
      required double dropoffplac1,
      required double dropoffplac2,
      required String formtype}) async {
    LatLng selectedPlac = LatLng(selectedPlac1, selectedPlac2);
    LatLng dropoffplac = LatLng(dropoffplac1, dropoffplac2);
    Geodesy geodesy = Geodesy();
    num distance = geodesy.distanceBetweenTwoGeoPoints(
                LatLng(selectedPlac.latitude, selectedPlac.longitude),
                LatLng(dropoffplac.latitude, dropoffplac.longitude)) /
            1000 +
        25;
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
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${selectedPlac.latitude},${selectedPlac.longitude}&destinations=${dropoffplac.latitude}%2C${dropoffplac.longitude}&key=AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw'),
    );
    String duration = '0';
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (response.body != null) {
        print(data);
        duration = data['rows'][0]['elements'][0]['duration']['text'];
      } else {
        duration = "0";
      }
    }
    return {
      'distance': distance.toStringAsFixed(2),
      'duration': duration,
      'placeRate': placeRate,
      'rate': rate,
    };
  }

  Future getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      final data = await getCurrentLatLng();
      _currentPosition = LatLng(data['latitude'], data['longitude']);
    }
  }

  getUserLocation() async {
    LatLng myLocation = _currentPosition;
    String error;
    try {
      await getCurrentLocation();
      myLocation = _currentPosition;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        throw Exception(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        throw Exception(error);
      }
    }

    var risult = await googleGeocoding.geocoding
        .getReverse(LatLon(myLocation.latitude, myLocation.longitude));
    var first = risult!.results!.first;
    return first;
  }
}
