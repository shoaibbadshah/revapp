import 'dart:async';

import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/ui/pointmap/MyMap.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BackMap extends StatelessWidget {
  BackMap({Key? key}) : super(key: key);
  Completer<GoogleMapController> _controller = Completer();
  final calculate = locator<Calculate>();
  late CameraPosition initialLocation;
  @override
  Widget build(BuildContext context) {
    initialLocation = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: LatLng(calculate.currentPosition.latitude,
          calculate.currentPosition.longitude),
    );
    return ViewModelBuilder<StartUpViewModel>.reactive(
      initialiseSpecialViewModelsOnce: true,
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
