import 'package:avenride/api/paystack_api.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/location_service.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:avenride/ui/avenfood/avenfood_view.dart';
import 'package:avenride/ui/boat/boat_confirmpickup/boat_confirmpickup_view.dart';
import 'package:avenride/ui/boat/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/boat/boatsearchingdriver/boat_seacrhdriver_view.dart';
import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:avenride/ui/car/confirmpickup/confirmpickup_view.dart';
import 'package:avenride/ui/mainScreen/mainScreenView.dart';
import 'package:avenride/ui/car/searchingdriver/seacrhdriver_view.dart';
import 'package:places_service/places_service.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/address_selection/address_selection_view.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/create_account/create_account_view.dart';
import 'package:avenride/ui/login/login_view.dart';
import 'package:avenride/ui/second/second_view.dart';
import 'package:avenride/ui/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    CupertinoRoute(page: StartUpView, initial: true),
    CupertinoRoute(page: MainScreenView),
    CupertinoRoute(page: SecondView),
    CupertinoRoute(page: AvenFoodView),
    CupertinoRoute(page: CreateAccountView),
    CupertinoRoute(page: LoginView),
    CupertinoRoute(page: AddressSelectionView),
    CupertinoRoute(page: CarRideView),
    CupertinoRoute(page: BoatRideView),
    CupertinoRoute(page: ConfirmPickUpView),
    CupertinoRoute(page: BookingView),
    CupertinoRoute(page: SearchDriverView),
    CupertinoRoute(page: BoatConfirmPickUpView),
    CupertinoRoute(page: BoatSearchDriverView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    Singleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    LazySingleton(classType: PaystackApi),
    LazySingleton(classType: PlacesService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: LocationService),
    LazySingleton(classType: Calculate),
    LazySingleton(classType: PushNotificationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
