import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avenride/app/app.logger.dart';

class Distance {
  List<LatLng> polylineCoordinates = [];
  Future calculateDistance(
      {required String selectedPlac, required String dropoffplac}) async {
    final log = getLogger('calculateDistance');
    try {
      Position startCoordinates;
      Position destinationCoordinates;
      String selectedPlace = selectedPlac;
      String dropoffplace = dropoffplac;
      String _placeDistance;
      String _placeRate;

      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(selectedPlace);
      //await _geolocator.placemarkFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(dropoffplace);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      startCoordinates = Position(
        latitude: startPlacemark[0].latitude,
        longitude: startPlacemark[0].longitude,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
      );
      destinationCoordinates = Position(
        latitude: destinationPlacemark[0].latitude,
        longitude: destinationPlacemark[0].longitude,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
      );

      log.v('START COORDINATES: $startCoordinates');
      log.v('DESTINATION COORDINATES: $destinationCoordinates');

      // ignore: unused_local_variable
      Position _northeastCoordinates;
      // ignore: unused_local_variable
      Position _southwestCoordinates;

      // Calculating to check that
      // southwest coordinate <= northeast coordinate
      if (startCoordinates.latitude <= destinationCoordinates.latitude) {
        _southwestCoordinates = startCoordinates;
        _northeastCoordinates = destinationCoordinates;
      } else {
        _southwestCoordinates = destinationCoordinates;
        _northeastCoordinates = startCoordinates;
      }

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      double distanceInMeters = Geolocator.bearingBetween(
        startCoordinates.latitude,
        startCoordinates.longitude,
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      );
      log.i('DISTANCE: $distanceInMeters meters');
      double totalDistance = 0.0;
      await _createPolylines(startCoordinates, destinationCoordinates);
      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      _placeDistance = totalDistance.toStringAsFixed(2);
      _placeRate = (totalDistance * 100).toStringAsFixed(2);
      log.i('DISTANCE: $_placeDistance km');
      log.i('DISTANCE: $_placeRate km');

      return {'placeDistance': _placeDistance, 'placeRate': _placeRate};
    } catch (e) {
      print(e);
      return {};
    }
  }

  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    PolylinePoints polylinePoints;
    Map<PolylineId, Polyline> polylines = {};
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
}
