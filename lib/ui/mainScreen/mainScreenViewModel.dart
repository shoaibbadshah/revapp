import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/car_ride/car_ride_view.dart';
import 'package:avenride/ui/notification/notification_view.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:avenride/ui/startup/startup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainScreenViewModel extends BaseViewModel {
  final userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  navigateToBoatRide() {
    _navigationService.navigateWithTransition(
      BoatRideView(
        isBoat: true,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToProfile() {
    _navigationService.navigateWithTransition(
      ProfileView(),
      transition: 'rightToLeft',
    );
  }

  navigateToCardRide() {
    _navigationService.navigateWithTransition(
      CarRideView(
        formType: Cartype,
        isDropLatLng: false,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToTaxiRide() {
    _navigationService.navigateWithTransition(
      CarRideView(
        formType: Taxi,
        isDropLatLng: false,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToAmbulanceRide() {
    _navigationService.navigateWithTransition(
      CarRideView(
        formType: Ambulance,
        isDropLatLng: false,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToNotification() {
    _navigationService.navigateWithTransition(
      NotificationView(),
      transition: 'downToUp',
    );
  }

  navigateToHome() {
    _navigationService.navigateWithTransition(
      StartUpView(),
      transition: 'rightToLeft',
    );
  }

  navigateToBooking() {
    _navigationService.navigateWithTransition(
      BookingView(
        enableAppBar: true,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToDelivery() async {
    _navigationService.navigateWithTransition(
      BoatRideView(
        isBoat: false,
      ),
      transition: 'rightToLeft',
    );
  }

  navigateToDeliveryServices() {
    _navigationService.navigateWithTransition(
      CarRideView(
        formType: DeliveryService,
        isDropLatLng: false,
      ),
      transition: 'rightToLeft',
    );
  }
}
