import 'dart:async';

import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:avenride/ui/avenfood/avenfood_view.dart';
import 'package:avenride/ui/boat/boat_booking/boat_booking_view.dart';
import 'package:avenride/ui/boat/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/car/car_booking/car_booking_view.dart';
import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:avenride/ui/notification/notification_view.dart';
import 'package:avenride/ui/profile/personal_info.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/startup/startup_view.dart';
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
    SetBookinType(bookingtype: Cartype);
    navigationService.navigateWithTransition(
      CarBookingView(
        bookingtype: Cartype,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToNewDelivery() {
    SetBookinType(bookingtype: DeliveryService);
    navigationService.navigateWithTransition(
      CarBookingView(
        bookingtype: Cartype,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToNewAmbulance() {
    SetBookinType(bookingtype: Ambulance);
    navigationService.navigateWithTransition(
      CarBookingView(
        bookingtype: Ambulance,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToTaxiRide() {
    SetBookinType(bookingtype: Taxi);
    navigationService.navigateWithTransition(
      CarBookingView(
        bookingtype: Taxi,
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
    _placesService.initialize(apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!);
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

  navigateToBookingCar() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
        bookingtype: Cartype,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToBookingBusTaxi() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
        bookingtype: Taxi,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToBookingAmbulance() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
        bookingtype: Ambulance,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToBookingSendPickups() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
        bookingtype: DeliveryService,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToBookingBoat() {
    navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
        bookingtype: BoatRidetype,
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
    if (userService.currentUser != null) {
      if (userService.currentUser!.email!.isEmpty ||
          userService.currentUser!.name!.isEmpty ||
          userService.currentUser!.mobileNo!.isEmpty) {
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
  }

  Future<void> runStartupLogic() async {
    setBusy(true);
    if (userService.hasLoggedInUser || userService.currentUser != null) {
      log.v('We have a user session on disk. Sync the user profile ...');
      await userService.syncUserAccount();
      if (userService.currentUser!.pushToken != _notifyService.pushToken) {
        firestoreApi.updateRider(
          data: {
            'pushToken': _notifyService.pushToken,
          },
          user: userService.currentUser!.id,
        );
      }
      final currentUser = userService.currentUser;
      userId = currentUser!.id;
      log.v('User sync complete. User profile');
      setBusy(false);
    } else {
      log.v('No user on disk, navigate to the LoginView');
      setBusy(false);
      navigationService.replaceWith(Routes.loginView);
    }
  }

  Future<void> messageHandler(RemoteMessage message) async {
    log.i('New notification Recieved');
    List data = [];
    if (userService.currentUser!.notification != null) {
      data = userService.currentUser!.notification!;
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
    }, user: userService.currentUser!.id);
    log.i('New notification and it is updated');
    data = [];
  }

  Future<void> messageOpenedApp(
      RemoteMessage message, BuildContext context) async {
    log.i('New notification Recieved');
    List data = [];
    if (userService.currentUser!.notification != null) {
      data = userService.currentUser!.notification!;
    }
    data.add({
      'data': message.data,
      'title': message.notification!.title == null
          ? ''
          : message.notification!.title,
      'body':
          message.notification!.body == null ? '' : message.notification!.body,
    });
    firestoreApi.updateRider(
      data: {
        'notification': data,
      },
      user: userService.currentUser!.id,
    );
    log.i('New notification and it is updated');
    final snackBar =
        SnackBar(content: Text('driver found, opt is ${message.data['otp']}'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    data = [];
  }

  void updateBottomNav(int i) {
    index = i;
    notifyListeners();
  }
}
