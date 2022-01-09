import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/paymentui/payment_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class ConfirmPickUpViewModel extends BaseViewModel {
  final log = getLogger('CarSelectionMapViewModel');
  final _bottomSheetService = locator<BottomSheetService>();
  final navigationService = locator<NavigationService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _userService = locator<UserService>();
  MyStore store = VxState.store as MyStore;
  int selectedIndex = 0;
  bool isbusy = false, buttonPressed = true;
  String paymentMethod = 'Cash', bookingType = '';
  double price = 0.0;
  String fp = '';
  Position? currentPosition;
  double sprice = double.parse(carTypes[0].price);
  double storedprice = 0.0;
  NameIMG selectedCar = NameIMG('AVR', Assets.car1, '100.0');
  String source = '', destination = '';
  double time = 0;
  String submitBtnText = 'AVR';
  String dropOffAddress = '', pickUpAddess = '';
  String rideType = 'Personal Ride',
      distance = '',
      scheduleTime = '',
      scheduledDate = '';
  bool isbusy1 = false;
  void setCar({required int index, required NameIMG car}) {
    selectedIndex = index;
    sprice = double.parse(car.price);
    price = storedprice + sprice;
    selectedCar = car;
    submitBtnText = '${car.name.toString()} (total: $price)';
    notifyListeners();
  }

  void setInitialPrice(double val) {
    storedprice = val;
    price = storedprice + sprice;
    notifyListeners();
  }

  void setTiemDate() async {
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating,
      enableDrag: false,
      barrierDismissible: true,
      title: 'Select Car Type',
      mainButtonTitle: 'Continue',
      secondaryButtonTitle: 'This is cool',
    );
  }

  void setSrcDest(String src, String dest, String distanceTime) {
    source = src;
    destination = dest;
    time = double.parse(distanceTime);
    setInitialData();
  }

  void setInitialData() {
    log.v(store.carride);
    dropOffAddress = store.carride['destination'];
    pickUpAddess = store.carride['startLocation'];
    distance = store.carride['distace'];
    scheduleTime = store.carride['scheduleTime'];
    scheduledDate = store.carride['scheduledDate'];
    notifyListeners();
  }

  void navigateToPayment() {
    navigationService.navigateToView(PaymentView(
      updatePreferences: () {
        rideType = store.rideType;
        paymentMethod = store.paymentMethod;
        notifyListeners();
        navigationService.back();
      },
    ));
  }

  getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        currentPosition = Position(
            longitude: position.longitude,
            latitude: position.latitude,
            timestamp: position.timestamp,
            accuracy: position.accuracy,
            altitude: position.altitude,
            heading: position.heading,
            speed: position.speed,
            speedAccuracy: position.speedAccuracy);
      }).catchError((e) {
        throw Exception(e);
      });
      return currentPosition;
    }
  }

  navigateToMapPicker(bool pickup) async {
    pickup ? isbusy = true : isbusy1 = true;
    notifyListeners();
    await getCurrentLocation();
    navigationService.navigateToView(PlacePicker(
      apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
      initialPosition:
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
      useCurrentLocation: pickup ? true : false,
      selectInitialPosition: true,
      onPlacePicked: (result) {
        // if (pickup) {
        //   pickUpAddess = result.formattedAddress!;
        // }
        // if (!pickup) {
        //   dropOffAddress = result.formattedAddress!;
        // }
        // notifyListeners();
        navigationService.back();
      },
    ));
    pickup ? isbusy = false : isbusy1 = false;
    notifyListeners();
  }

  void onConfirmOrder(BuildContext context, LatLng st, LatLng en) async {
    buttonPressed = false;
    SetBookinType(bookingtype: "");
    notifyListeners();
    if (bookingType == Taxi) {
      await _firestoreApi
          .createTaxiRide(
        carride: store.carride,
        user: _userService.currentUser!,
      )
          .then((value) async {
        log.v(value);
        if (value != '') {
          final response = await http.get(Uri.parse(
              'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'));
          navigationService.replaceWith(
            Routes.searchDriverView,
            arguments: SearchDriverViewArguments(
              start: st,
              end: en,
              collectionType: 'TaxiRide',
              rideId: value,
              endText: dropOffAddress,
              startText: pickUpAddess,
              time: distance,
            ),
          );
          final snackBar = SnackBar(
              content:
                  Text('Booking is successful view in Bike rides section!'));
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else if (bookingType == Keke) {
      await _firestoreApi
          .createTaxiRide(
        carride: store.carride,
        user: _userService.currentUser!,
      )
          .then((value) async {
        log.v(value);
        if (value != '') {
          final response = await http.get(Uri.parse(
              'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'));
          navigationService.replaceWith(
            Routes.searchDriverView,
            arguments: SearchDriverViewArguments(
              start: st,
              end: en,
              collectionType: 'Keke',
              rideId: value,
              endText: dropOffAddress,
              startText: pickUpAddess,
              time: distance,
            ),
          );
          final snackBar = SnackBar(
              content:
                  Text('Booking is successful view in keke rides section!'));
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else if (bookingType == Cartype) {
      await _firestoreApi
          .createCarRide(
        carride: store.carride,
        user: _userService.currentUser!,
      )
          .then((value) async {
        if (value != '') {
          final response = await http.get(Uri.parse(
              'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'));
          navigationService.replaceWith(
            Routes.searchDriverView,
            arguments: SearchDriverViewArguments(
              start: st,
              end: en,
              collectionType: 'CarRide',
              rideId: value,
              endText: dropOffAddress,
              startText: pickUpAddess,
              time: distance,
            ),
          );
          final snackBar = SnackBar(
              content:
                  Text('Booking is successful view in car rides section!'));
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else if (bookingType == DeliveryService) {
      await _firestoreApi
          .createDeliveryServices(
        carride: store.carride,
        user: _userService.currentUser!,
      )
          .then((value) async {
        if (value != '') {
          final response = await http.get(
            Uri.parse(
                'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'),
          );
          navigationService.replaceWith(
            Routes.searchDriverView,
            arguments: SearchDriverViewArguments(
              start: st,
              end: en,
              collectionType: 'DeliveryServices',
              rideId: value,
              endText: dropOffAddress,
              startText: pickUpAddess,
              time: distance,
            ),
          );
          final snackBar = SnackBar(
            content: Text(
                'Booking is successful view in delivery booking rides section!'),
          );
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else if (bookingType == Ambulance) {
      await _firestoreApi
          .createAmbulance(
        carride: store.carride,
        user: _userService.currentUser!,
      )
          .then((value) async {
        if (value != '') {
          final response = await http.get(
            Uri.parse(
                'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'),
          );
          navigationService.replaceWith(
            Routes.searchDriverView,
            arguments: SearchDriverViewArguments(
              start: st,
              end: en,
              collectionType: 'Ambulance',
              rideId: value,
              endText: dropOffAddress,
              startText: pickUpAddess,
              time: distance,
            ),
          );
          final snackBar = SnackBar(
            content: Text(
                'Booking is successful view in ambulance booking rides section!'),
          );
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }
}
