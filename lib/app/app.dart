import 'package:avenride/services/distance.dart';
import 'package:avenride/services/location_service.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:avenride/ui/mainScreen/mainScreenView.dart';
import 'package:avenride/ui/permissionpage/permissionpgeview.dart';
import 'package:places_service/places_service.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/address_selection/address_selection_view.dart';
import 'package:avenride/ui/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/car_ride/car_ride_view.dart';
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
    CupertinoRoute(page: CreateAccountView),
    CupertinoRoute(page: LoginView),
    CupertinoRoute(page: AddressSelectionView),
    CupertinoRoute(page: CarRideView),
    CupertinoRoute(page: BoatRideView),
    CupertinoRoute(page: BookingView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    Singleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    LazySingleton(classType: PlacesService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: Distance),
    LazySingleton(classType: Calculate),
    LazySingleton(classType: PushNotificationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
