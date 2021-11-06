// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../ui/address_selection/address_selection_view.dart';
import '../ui/avenfood/avenfood_view.dart';
import '../ui/boat/boat_confirmpickup/boat_confirmpickup_view.dart';
import '../ui/boat/boat_ride/boat_ride_view.dart';
import '../ui/boat/boatsearchingdriver/boat_seacrhdriver_view.dart';
import '../ui/booking/booking_view.dart';
import '../ui/car/car_ride/car_ride_view.dart';
import '../ui/car/confirmpickup/confirmpickup_view.dart';
import '../ui/car/searchingdriver/seacrhdriver_view.dart';
import '../ui/create_account/create_account_view.dart';
import '../ui/login/login_view.dart';
import '../ui/mainScreen/mainScreenView.dart';
import '../ui/second/second_view.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String mainScreenView = '/main-screen-view';
  static const String secondView = '/second-view';
  static const String avenFoodView = '/aven-food-view';
  static const String createAccountView = '/create-account-view';
  static const String loginView = '/login-view';
  static const String addressSelectionView = '/address-selection-view';
  static const String carRideView = '/car-ride-view';
  static const String boatRideView = '/boat-ride-view';
  static const String confirmPickUpView = '/confirm-pick-up-view';
  static const String bookingView = '/booking-view';
  static const String searchDriverView = '/search-driver-view';
  static const String boatConfirmPickUpView = '/boat-confirm-pick-up-view';
  static const String boatSearchDriverView = '/boat-search-driver-view';
  static const all = <String>{
    startUpView,
    mainScreenView,
    secondView,
    avenFoodView,
    createAccountView,
    loginView,
    addressSelectionView,
    carRideView,
    boatRideView,
    confirmPickUpView,
    bookingView,
    searchDriverView,
    boatConfirmPickUpView,
    boatSearchDriverView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.mainScreenView, page: MainScreenView),
    RouteDef(Routes.secondView, page: SecondView),
    RouteDef(Routes.avenFoodView, page: AvenFoodView),
    RouteDef(Routes.createAccountView, page: CreateAccountView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.addressSelectionView, page: AddressSelectionView),
    RouteDef(Routes.carRideView, page: CarRideView),
    RouteDef(Routes.boatRideView, page: BoatRideView),
    RouteDef(Routes.confirmPickUpView, page: ConfirmPickUpView),
    RouteDef(Routes.bookingView, page: BookingView),
    RouteDef(Routes.searchDriverView, page: SearchDriverView),
    RouteDef(Routes.boatConfirmPickUpView, page: BoatConfirmPickUpView),
    RouteDef(Routes.boatSearchDriverView, page: BoatSearchDriverView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      var args = data.getArgs<StartUpViewArguments>(
        orElse: () => StartUpViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => StartUpView(key: args.key),
        settings: data,
      );
    },
    MainScreenView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const MainScreenView(),
        settings: data,
      );
    },
    SecondView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SecondView(),
        settings: data,
      );
    },
    AvenFoodView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const AvenFoodView(),
        settings: data,
      );
    },
    CreateAccountView: (data) {
      var args = data.getArgs<CreateAccountViewArguments>(
        orElse: () => CreateAccountViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => CreateAccountView(key: args.key),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    AddressSelectionView: (data) {
      var args = data.getArgs<AddressSelectionViewArguments>(
        orElse: () => AddressSelectionViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => AddressSelectionView(key: args.key),
        settings: data,
      );
    },
    CarRideView: (data) {
      var args = data.getArgs<CarRideViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => CarRideView(
          key: args.key,
          formType: args.formType,
          isDropLatLng: args.isDropLatLng,
          dropLat: args.dropLat,
          dropLng: args.dropLng,
        ),
        settings: data,
      );
    },
    BoatRideView: (data) {
      var args = data.getArgs<BoatRideViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BoatRideView(
          key: args.key,
          isBoat: args.isBoat,
        ),
        settings: data,
      );
    },
    ConfirmPickUpView: (data) {
      var args = data.getArgs<ConfirmPickUpViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ConfirmPickUpView(
          key: args.key,
          bookingtype: args.bookingtype,
          start: args.start,
          end: args.end,
        ),
        settings: data,
      );
    },
    BookingView: (data) {
      var args = data.getArgs<BookingViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BookingView(
          key: args.key,
          enableAppBar: args.enableAppBar,
          bookingtype: args.bookingtype,
        ),
        settings: data,
      );
    },
    SearchDriverView: (data) {
      var args = data.getArgs<SearchDriverViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => SearchDriverView(
          key: args.key,
          start: args.start,
          end: args.end,
          rideId: args.rideId,
          collectionType: args.collectionType,
          startText: args.startText,
          endText: args.endText,
          time: args.time,
        ),
        settings: data,
      );
    },
    BoatConfirmPickUpView: (data) {
      var args = data.getArgs<BoatConfirmPickUpViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BoatConfirmPickUpView(
          key: args.key,
          start: args.start,
          end: args.end,
        ),
        settings: data,
      );
    },
    BoatSearchDriverView: (data) {
      var args = data.getArgs<BoatSearchDriverViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BoatSearchDriverView(
          key: args.key,
          start: args.start,
          end: args.end,
          rideId: args.rideId,
          collectionType: args.collectionType,
          startText: args.startText,
          endText: args.endText,
          time: args.time,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// StartUpView arguments holder class
class StartUpViewArguments {
  final Key? key;
  StartUpViewArguments({this.key});
}

/// CreateAccountView arguments holder class
class CreateAccountViewArguments {
  final Key? key;
  CreateAccountViewArguments({this.key});
}

/// LoginView arguments holder class
class LoginViewArguments {
  final Key? key;
  LoginViewArguments({this.key});
}

/// AddressSelectionView arguments holder class
class AddressSelectionViewArguments {
  final Key? key;
  AddressSelectionViewArguments({this.key});
}

/// CarRideView arguments holder class
class CarRideViewArguments {
  final Key? key;
  final String formType;
  final bool isDropLatLng;
  final double? dropLat;
  final double? dropLng;
  CarRideViewArguments(
      {this.key,
      required this.formType,
      required this.isDropLatLng,
      this.dropLat,
      this.dropLng});
}

/// BoatRideView arguments holder class
class BoatRideViewArguments {
  final Key? key;
  final bool isBoat;
  BoatRideViewArguments({this.key, required this.isBoat});
}

/// ConfirmPickUpView arguments holder class
class ConfirmPickUpViewArguments {
  final Key? key;
  final String bookingtype;
  final LatLng start;
  final LatLng end;
  ConfirmPickUpViewArguments(
      {this.key,
      required this.bookingtype,
      required this.start,
      required this.end});
}

/// BookingView arguments holder class
class BookingViewArguments {
  final Key? key;
  final bool enableAppBar;
  final String bookingtype;
  BookingViewArguments(
      {this.key, required this.enableAppBar, required this.bookingtype});
}

/// SearchDriverView arguments holder class
class SearchDriverViewArguments {
  final Key? key;
  final LatLng start;
  final LatLng end;
  final String rideId;
  final String collectionType;
  final String startText;
  final String endText;
  final String time;
  SearchDriverViewArguments(
      {this.key,
      required this.start,
      required this.end,
      required this.rideId,
      required this.collectionType,
      required this.startText,
      required this.endText,
      required this.time});
}

/// BoatConfirmPickUpView arguments holder class
class BoatConfirmPickUpViewArguments {
  final Key? key;
  final LatLng start;
  final LatLng end;
  BoatConfirmPickUpViewArguments(
      {this.key, required this.start, required this.end});
}

/// BoatSearchDriverView arguments holder class
class BoatSearchDriverViewArguments {
  final Key? key;
  final LatLng start;
  final LatLng end;
  final String rideId;
  final String collectionType;
  final String startText;
  final String endText;
  final String time;
  BoatSearchDriverViewArguments(
      {this.key,
      required this.start,
      required this.end,
      required this.rideId,
      required this.collectionType,
      required this.startText,
      required this.endText,
      required this.time});
}
