import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

// ignore: must_be_immutable
class MyMap extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
  // ignore: non_constant_identifier_names
  LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
  // ignore: non_constant_identifier_names
  bool isBoat = false;
  MyMap(
      // ignore: non_constant_identifier_names
      {required this.DEST_LOCATION,
      // ignore: non_constant_identifier_names
      required this.SOURCE_LOCATION,
      required this.isBoat});
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  final _bottomSheetService = locator<BottomSheetService>();
// this set will hold my markers
  Set<Marker> _markers = {};
// this will hold the generated polylines
  Set<Polyline> _polylines = {};
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = 'AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw';
// for my custom icons
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
    if (!widget.isBoat) {
      setPolylines();
    }
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: widget.SOURCE_LOCATION,
      ));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: widget.DEST_LOCATION,
          icon: destinationIcon!));
    });
  }

  setPolylines() async {
    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(
          widget.SOURCE_LOCATION.latitude, widget.SOURCE_LOCATION.longitude),
      PointLatLng(
          widget.DEST_LOCATION.latitude, widget.DEST_LOCATION.longitude),
    );
    List<PointLatLng> result = result1.points;
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  Future showBasicBottomSheet() async {
    await _bottomSheetService.showBottomSheet(
      title: 'The basic bottom sheet',
      description:
          'Use this bottom sheet function to show something to the user. It\'s better than the standard alert dialog in terms of UI quality.',
    );
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: widget.SOURCE_LOCATION);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              onMapCreated: onMapCreated,
            ),
            Positioned(
              top: screenHeight(context) / 1.7,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                height: 180.0,
                width: screenWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: Image.asset(
                        Assets.firebase,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'We are near you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Finding the best ride for you',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
