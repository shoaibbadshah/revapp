import 'dart:async';

import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:avenride/ui/avenfood/avenfood_view.dart';
import 'package:avenride/ui/boat_booking/boat_booking_view.dart';
import 'package:avenride/ui/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/car_booking/car_booking_view.dart';
import 'package:avenride/ui/car_ride/car_ride_view.dart';
import 'package:avenride/ui/notification/notification_view.dart';
import 'package:avenride/ui/pointmap/MyMap.dart';
import 'package:avenride/ui/profile/personal_info.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/startup/startup_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:places_service/places_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');
  final userService = locator<UserService>();
  final navigationService = locator<NavigationService>();
  final _placesService = locator<PlacesService>();
  final firestoreApi = locator<FirestoreApi>();
  final _notifyService = locator<PushNotificationService>();
  late Location location;
  late StreamSubscription<LocationData> locationData;
  Position? currentPosition;
  bool status = true;
  String? userId;
  int index = 0;
  Future<void> logout() async {
    await userService.logout;
    log.v('Successfully Loggeg out');
    runStartupLogic();
  }

  navigateToBoatRide() {
    navigationService.navigateWithTransition(
      BoatBookingView(),
      transition: 'rightToLeft',
    );
  }

  navigateToProfile() {
    navigationService.navigateWithTransition(
      ProfileView(),
      transition: 'rightToLeft',
    );
  }

  navigateToCardRide() {
    navigationService.navigateWithTransition(
      CarBookingView(),
      transition: 'rightToLeft',
    );
  }

  navigateToTaxiRide() {
    navigationService.navigateWithTransition(
      CarRideView(
        isDropLatLng: false,
        formType: Taxi,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToAvenFood() {
    navigationService.navigateWithTransition(
      AvenFoodView(),
      transition: 'rightToLeft',
    );
  }

  navigateToAmbulanceRide() {
    _placesService.initialize(apiKey: env['GOOGLE_MAPS_API_KEY']!);
    navigationService.navigateWithTransition(
      CarRideView(
        isDropLatLng: false,
        formType: Ambulance,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToNotification() {
    navigationService.navigateWithTransition(
      NotificationView(),
      transition: 'downToUp',
    );
  }

  navigateToHome() {
    navigationService.navigateWithTransition(
      StartUpView(),
      transition: 'rightToLeft',
    );
  }

  navigateToBooking() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToDelivery() async {
    navigationService.navigateWithTransition(
      BoatRideView(
        isBoat: false,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToDeliveryServices() {
    navigationService.navigateWithTransition(
      CarRideView(
        isDropLatLng: false,
        formType: DeliveryService,
      ),
      transition: 'rightToLeft',
    );
  }

  setStatus(bool isB) {
    status = isB;
    notifyListeners();
  }

  void checkData(BuildContext context) {
    if (userService.currentUser.email!.isEmpty ||
        userService.currentUser.name!.isEmpty ||
        userService.currentUser.mobileNo!.isEmpty) {
      Future<bool> _onBackPressed() {
        return Future.delayed(Duration(milliseconds: 200), () {
          return false;
        });
      }

      Alert(
        context: context,
        title: "Please Update your Info",
        desc: "click below to update your info",
        closeFunction: _onBackPressed,
        onWillPopActive: true,
        buttons: [
          DialogButton(
            child: Text(
              "Click Here",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            onPressed: () async {
              navigationService.navigateToView(ProfileInfo(
                isMainScreen: true,
              ));
            },
            width: 120,
          ),
        ],
      ).show();
    }
  }

  Future<void> runStartupLogic() async {
    setBusy(true);
    if (userService.hasLoggedInUser) {
      log.v('We have a user session on disk. Sync the user profile ...');
      await userService.syncUserAccount();
      if (userService.currentUser.pushToken != _notifyService.pushToken) {
        firestoreApi.updateRider(
          data: {
            'pushToken': _notifyService.pushToken,
          },
          user: userService.currentUser.id,
        );
      }
      final currentUser = userService.currentUser;
      userId = currentUser.id;
      log.v('User sync complete. User profile');
      setBusy(false);
    } else {
      log.v('No user on disk, navigate to the LoginView');
      setBusy(false);
      navigationService.replaceWith(Routes.loginView);
    }
  }

  void onMapCreated(GoogleMapController controller,
      Completer<GoogleMapController> _controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  Future<void> messageHandler(RemoteMessage message) async {
    log.i('New notification Recieved');
    List data = [];
    if (userService.currentUser.notification != null) {
      data = userService.currentUser.notification!;
    }
    data.add({
      'data': message.data,
      'title': message.notification!.title == null
          ? ''
          : message.notification!.title,
      'body':
          message.notification!.body == null ? '' : message.notification!.body,
    });
    firestoreApi.updateRider(data: {
      'notification': data,
    }, user: userService.currentUser.id);
    log.i('New notification and it is updated');
    data = [];
  }

  void updateBottomNav(int i) {
    index = i;
    notifyListeners();
  }

  updatePinOnMap(
      {required LatLng location,
      required Completer<GoogleMapController> completer}) async {
    CameraPosition cPosition = CameraPosition(
      zoom: 10,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(location.latitude, location.longitude),
    );
    final GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    log.d('databse updaeted');
  }

  liveLocation(
      {required Function setLocation, required LatLng currentLocation}) {
    location = new Location();
    locationData = location.onLocationChanged.listen((LocationData cLoc) {
      if (currentLocation != LatLng(cLoc.latitude!, cLoc.longitude!)) {
        setLocation(cLoc);
      }
    });
  }
}
