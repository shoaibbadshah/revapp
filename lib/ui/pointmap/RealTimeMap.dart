import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class RealTimeMap extends StatefulWidget {
  LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
  LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
  RealTimeMap({
    required this.DEST_LOCATION,
    required this.SOURCE_LOCATION,
    Key? key,
  }) : super(key: key);

  @override
  _RealTimeMapState createState() => _RealTimeMapState();
}

class _RealTimeMapState extends State<RealTimeMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw';
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late CameraPosition initialLocation;
  LocationData currentLocation = LocationData.fromMap({
    "latitude": 42.7477863,
    "longitude": -71.1699932,
  });
  late LocationData destinationLocation;
  late Location location;
  late StreamSubscription<LocationData> locationData;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      location = new Location();
      polylinePoints = PolylinePoints();
      locationData = location.onLocationChanged.listen((LocationData cLoc) {
        if (LatLng(currentLocation.latitude!, currentLocation.longitude!) !=
            LatLng(cLoc.latitude!, cLoc.longitude!)) {
          print('LOCATION IS UPDATED');
          setState(() {
            currentLocation = cLoc;
          });
          updatePinOnMap();
        }
      });
      setSourceAndDestinationIcons();
      setInitialLocation();
    }
  }

  @override
  void dispose() {
    locationData.cancel();
    super.dispose();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    if (mounted) {
      setState(() {
        var pinPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            position: pinPosition,
            icon: sourceIcon));
      });
    }
    setPolylines();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    destinationLocation = LocationData.fromMap({
      "latitude": widget.DEST_LOCATION.latitude,
      "longitude": widget.DEST_LOCATION.longitude
    });
    updatePinOnMap();
  }

  void showPinsOnMap() {
    var pinPosition =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    var destPosition =
        LatLng(widget.DEST_LOCATION.latitude, widget.DEST_LOCATION.longitude);
    _markers.add(
      Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon,
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon,
      ),
    );
  }

  void setPolylines() async {
    if (mounted) {
      setState(() {
        _polylines.clear();
        polylineCoordinates.clear();
      });
    }
    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation.latitude!, currentLocation.longitude!),
      PointLatLng(
          widget.DEST_LOCATION.latitude, widget.DEST_LOCATION.longitude),
    );
    List<PointLatLng> result = result1.points;
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      if (mounted) {
        setState(() {
          _polylines.add(
            Polyline(
              width: 5,
              polylineId: PolylineId('ploy'),
              color: Colors.black,
              points: polylineCoordinates,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: widget.SOURCE_LOCATION);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                showPinsOnMap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
