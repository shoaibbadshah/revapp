// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:logger/logger.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../api/firestore_api.dart';
import '../api/paystack_api.dart';
import '../services/chargec_card.dart';
import '../services/distance.dart';
import '../services/location_service.dart';
import '../services/push_notification_service.dart';
import '../services/user_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingleton(FirebaseAuthenticationService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirestoreApi());
  locator.registerLazySingleton(() => PaystackApi());
  locator.registerLazySingleton(() => PlacesService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => Calculate());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => ChargeCard());
}
