// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/address_selection/address_selection_view.dart';
import '../ui/boat_ride/boat_ride_view.dart';
import '../ui/booking/booking_view.dart';
import '../ui/car_ride/car_ride_view.dart';
import '../ui/create_account/create_account_view.dart';
import '../ui/login/login_view.dart';
import '../ui/mainScreen/mainScreenView.dart';
import '../ui/second/second_view.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String mainScreenView = '/main-screen-view';
  static const String secondView = '/second-view';
  static const String createAccountView = '/create-account-view';
  static const String loginView = '/login-view';
  static const String addressSelectionView = '/address-selection-view';
  static const String carRideView = '/car-ride-view';
  static const String boatRideView = '/boat-ride-view';
  static const String bookingView = '/booking-view';
  static const all = <String>{
    startUpView,
    mainScreenView,
    secondView,
    createAccountView,
    loginView,
    addressSelectionView,
    carRideView,
    boatRideView,
    bookingView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.mainScreenView, page: MainScreenView),
    RouteDef(Routes.secondView, page: SecondView),
    RouteDef(Routes.createAccountView, page: CreateAccountView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.addressSelectionView, page: AddressSelectionView),
    RouteDef(Routes.carRideView, page: CarRideView),
    RouteDef(Routes.boatRideView, page: BoatRideView),
    RouteDef(Routes.bookingView, page: BookingView),
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
    BookingView: (data) {
      var args = data.getArgs<BookingViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BookingView(
          key: args.key,
          enableAppBar: args.enableAppBar,
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
  CarRideViewArguments({this.key, required this.formType});
}

/// BoatRideView arguments holder class
class BoatRideViewArguments {
  final Key? key;
  final bool isBoat;
  BoatRideViewArguments({this.key, required this.isBoat});
}

/// BookingView arguments holder class
class BookingViewArguments {
  final Key? key;
  final bool enableAppBar;
  BookingViewArguments({this.key, required this.enableAppBar});
}
