import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 13;
const double CAMERA_BEARING = 30;

// ignore: must_be_immutable
class BookingMap extends StatefulWidget {
  LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
  LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
  String source = '', destination = '';
  final int duration;
  BookingMap({
    required this.DEST_LOCATION,
    required this.SOURCE_LOCATION,
    required this.source,
    required this.destination,
    required this.duration,
  });
  @override
  _BookingMapState createState() => _BookingMapState();
}

class _BookingMapState extends State<BookingMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyBGp2Pnbz9Htx-jMVQPXXES7t0iA4tQwTw';
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late CameraPosition initialLocation;
  bool loading = true;
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

    if (destinationLocation.latitude! >= currentLocation.latitude! &&
        destinationLocation.longitude! >= currentLocation.longitude!) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            northeast: LatLng(
                destinationLocation.latitude!, destinationLocation.longitude!),
          ),
          100,
        ),
      );
    } else {
      print('object');
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    }
    if (mounted) {
      setState(() {
        var pinPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(
          Marker(
            markerId: MarkerId('sourcePin'),
            position: pinPosition,
            icon: sourceIcon,
          ),
        );
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
    print(widget.duration);
    final icon1 = await placeToMarker(
        Place(
          id: '',
          title: widget.source,
          address: '',
          position: widget.SOURCE_LOCATION,
          distance: 5,
        ),
        5);
    final icon2 = await placeToMarker(
      Place(
        id: '',
        title: widget.destination,
        address: '',
        position: widget.DEST_LOCATION,
        distance: widget.duration,
      ),
      widget.duration,
    );
    setState(() {
      sourceIcon = icon1;
      destinationIcon = icon2;
      loading = false;
    });
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
        infoWindow: InfoWindow(
          title: 'helllo',
        ),
        visible: true,
      ),
    );
  }

  Future<BitmapDescriptor> placeToMarker(Place place, int? duration) async {
    final recoder = ui.PictureRecorder();
    final canvas = ui.Canvas(recoder);
    const size = ui.Size(450, 120);

    final customMarker = MyCustomMarker(
      label: place.title,
      duration: duration,
    );
    customMarker.paint(canvas, size);
    final picture = recoder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final bytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
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
            loading
                ? LoadingScrren()
                : GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: false,
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

class Place {
  final String id, title, address;
  final LatLng position;
  final int distance;

  Place({
    required this.id,
    required this.title,
    required this.address,
    required this.position,
    required this.distance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      title: json['title'],
      address: json['address']['label'],
      position: LatLng(
        json['position']['lat'],
        json['position']['lng'],
      ),
      distance: json['distance'],
    );
  }
}

class MyCustomMarker extends CustomPainter {
  final String label;
  final int? duration;

  MyCustomMarker({
    required this.label,
    required this.duration,
  });

  void _drawText({
    required Canvas canvas,
    required Size size,
    required String text,
    required double width,
    double? dx,
    double? dy,
    String? fontFamily,
    double fontSize = 22,
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );

    textPainter.layout(
      maxWidth: width,
    );

    textPainter.paint(
      canvas,
      Offset(
        dx ?? size.height * 0.5 - textPainter.width * 0.5,
        size.height * 0.5 - textPainter.size.height * 0.5 + (dy ?? 0),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;

    final rRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(5),
    );

    canvas.drawRRect(rRect, paint);

    paint.color = Colors.black;

    final miniRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.height,
      size.height,
      topLeft: const Radius.circular(5),
      bottomLeft: const Radius.circular(5),
    );

    canvas.drawRRect(miniRect, paint);

    _drawText(
      canvas: canvas,
      size: size,
      text: label,
      dx: size.height + 10,
      width: size.width - size.height - 10,
    );

    if (duration == null) {
      _drawText(
        canvas: canvas,
        size: size,
        text: String.fromCharCode(
          Icons.gps_fixed_rounded.codePoint,
        ),
        fontFamily: Icons.gps_fixed_rounded.fontFamily,
        fontSize: 40,
        color: Colors.white,
        width: size.height,
      );
    } else {
      final realDuration = Duration(seconds: duration!);
      final minutes = realDuration.inMinutes;
      final String durationAsText =
          "${minutes > 59 ? realDuration.inHours : minutes}";
      _drawText(
        canvas: canvas,
        size: size,
        text: duration!.toString(),
        fontSize: 27,
        dy: -9,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.w300,
      );

      _drawText(
        canvas: canvas,
        size: size,
        text: minutes > 59 ? "H" : "MIN",
        fontSize: 22,
        dy: 12,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.bold,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
