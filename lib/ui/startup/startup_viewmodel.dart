import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:avenride/ui/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/car_ride/car_ride_view.dart';
import 'package:avenride/ui/notification/notification_view.dart';
import 'package:avenride/ui/pointmap/MyMap.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/startup/startup_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:places_service/places_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');
  final userService = locator<UserService>();
  final navigationService = locator<NavigationService>();
  final _placesService = locator<PlacesService>();
  final _calculate = locator<Calculate>();
  final firestoreApi = locator<FirestoreApi>();
  final _notifyService = locator<PushNotificationService>();
  Position? currentPosition;
  bool status = true;
  String? userId;

  CameraPosition initialLocation = CameraPosition(
    zoom: CAMERA_ZOOM,
    bearing: CAMERA_BEARING,
    tilt: CAMERA_TILT,
    target: LatLng(51.457838, -0.596342),
  );

  Future<void> logout() async {
    await userService.logout;
    log.v('Successfully Loggeg out');
    runStartupLogic();
  }

  navigateToBoatRide() {
    navigationService.navigateWithTransition(
      BoatRideView(
        isBoat: true,
      ),
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
      CarRideView(
        formType: Cartype,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToTaxiRide() {
    navigationService.navigateWithTransition(
      CarRideView(
        formType: Taxi,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToAmbulanceRide() {
    _placesService.initialize(apiKey: env['GOOGLE_MAPS_API_KEY']!);
    navigationService.navigateWithTransition(
      CarRideView(
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
        formType: DeliveryService,
      ),
      transition: 'rightToLeft',
    );
  }

  setStatus(bool isB) {
    status = isB;
    notifyListeners();
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
      initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: LatLng(52.482125, -1.895545),
      );
      final currentUser = userService.currentUser;
      userId = currentUser.id;
      log.v('User sync complete. User profile: $currentUser');
      setBusy(false);
    } else {
      log.v('No user on disk, navigate to the LoginView');
      setBusy(false);
      navigationService.replaceWith(Routes.loginView);
    }
  }
}
