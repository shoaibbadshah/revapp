import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/paymentui/payment_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:search_page/search_page.dart';
import 'package:stacked/stacked.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:http/http.dart' as http;

class BoatConfirmPickUpViewModel extends BaseViewModel {
  final log = getLogger('BoatSelectionMapViewModel');
  final _bottomSheetService = locator<BottomSheetService>();
  final navigationService = locator<NavigationService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _userService = locator<UserService>();
  MyStore store = VxState.store as MyStore;
  int selectedIndex = 0;
  bool isbusy = false;
  String paymentMethod = 'Cash';
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
    log.v("VALUE IS $distanceTime");
    final val = distanceTime.split(" ");
    log.v("VALUE IS $val");
    time = double.parse(distanceTime);
    setInitialData();
  }

  void setInitialData() {
    log.v(store.carride);
    dropOffAddress = store.carride['dropLocation'];
    pickUpAddess = store.carride['pickLocation'];
    distance = '100';
    scheduleTime = store.carride['scheduleTime'];
    scheduledDate = store.carride['scheduledDate'];
    notifyListeners();
  }

  Future buildShowSearch(BuildContext context, String labeltext, bool isDrop) {
    return showSearch(
      context: context,
      delegate: SearchPage(
        onQueryUpdate: (s) => print(s),
        items: boatLoc,
        searchLabel: labeltext,
        suggestion: ListView.builder(
          itemCount: boatLoc.length,
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.amber, width: 1)),
              ),
              child: ListTile(
                title: Text(
                  boatLoc[index].loc,
                  style: ktsMediumGreyBodyText,
                ),
                onTap: () {
                  if (!isDrop) {
                    pickUpAddess = boatLoc[index].loc;
                  }
                  if (isDrop) {
                    dropOffAddress = boatLoc[index].loc;
                  }
                },
              ),
            );
          },
        ),
        failure: Center(
          child: Text('No location found :('),
        ),
        filter: (boatLoc) => [
          boatLoc.loc,
        ],
        builder: (boatLoc) => DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.amber, width: 1)),
          ),
          child: ListTile(
            title: Text(
              boatLoc.loc,
              style: ktsMediumGreyBodyText,
            ),
            onTap: () {
              if (!isDrop) {
                pickUpAddess = boatLoc.loc;
              }
              if (isDrop) {
                dropOffAddress = boatLoc.loc;
              }
            },
          ),
        ),
      ),
    );
  }

  void navigateToPayment() {
    navigationService.navigateToView(PaymentView(
      updatePreferences: () {
        log.v('message ${store.paymentMethod} and ${store.rideType}');
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
        print(e);
      });
      log.v('CURRENT POS: $currentPosition');
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
        if (pickup) {
          pickUpAddess = result.formattedAddress!;
        }
        if (!pickup) {
          dropOffAddress = result.formattedAddress!;
        }
        notifyListeners();
      },
    ));
    pickup ? isbusy = false : isbusy1 = false;
    notifyListeners();
  }

  void onConfirmOrder(BuildContext context, LatLng st, LatLng en) async {
    await _firestoreApi
        .createBoatRide(carride: store.carride, user: _userService.currentUser!)
        .then((value) async {
      if (value) {
        SetBookinType(bookingtype: "");
        final response = await http.get(Uri.parse(
            'https://us-central1-unique-nuance-310113.cloudfunctions.net/notifywhenbooking'));
        navigationService.replaceWith(
          Routes.boatSearchDriverView,
          arguments: BoatSearchDriverViewArguments(start: st, end: en),
        );
        final snackBar = SnackBar(
            content: Text('Booking is successful view in rides section!'));
        return ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
