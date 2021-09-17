import 'dart:async';

import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/ui/pointmap/MyMap.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackMap extends StatefulWidget {
  BackMap({Key? key}) : super(key: key);

  @override
  _BackMapState createState() => _BackMapState();
}

class _BackMapState extends State<BackMap> {
  Completer<GoogleMapController> _controller = Completer();

  final calculate = locator<Calculate>();

  late Location location;

  late CameraPosition initialLocation;

  late LatLng currentLocation;

  late StreamSubscription<LocationData> locationData;

  @override
  void initState() {
    currentLocation = LatLng(calculate.currentPosition.latitude,
        calculate.currentPosition.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialLocation = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: currentLocation,
    );
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) {
        location = new Location();
        locationData = location.onLocationChanged.listen((LocationData cLoc) {
          if (currentLocation != LatLng(cLoc.latitude!, cLoc.longitude!)) {
            setState(() {
              currentLocation = LatLng(cLoc.latitude!, cLoc.longitude!);
            });
            model.updatePinOnMap(
              location: currentLocation,
              completer: _controller,
            );
          }
        });
      },
      onDispose: (model) {
        locationData.cancel();
      },
      builder: (context, model, child) => GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: (controller) {
          model.onMapCreated(controller, _controller);
        },
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
