import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/BottomSheetUi/ambulance_extra_service.dart';
import 'package:avenride/ui/car/car_selection_map/selectpassengers.dart';
import 'package:avenride/ui/paymentui/payment_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class CarSelectionMapViewModel extends BaseViewModel {
  final log = getLogger('CarSelectionMapViewModel');
  final _bottomSheetService = locator<BottomSheetService>();
  final navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _firestoreApi = locator<FirestoreApi>();
  String type = '';
  MyStore store = VxState.store as MyStore;
  int selectedIndex = 0;
  bool isbusy = false;
  String paymentMethod = 'Cash', bookingType = '';
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(carTypes[0].price);
  double storedprice = 0.0;
  NameIMG selectedCar = NameIMG('AVR', Assets.car1, '100.0');
  String source = '', destination = '';
  double time = 0;
  String submitBtnText = '';

  String rideType = 'Personal Ride';

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

  onConfirmPressed(LatLng st, LatLng en) async {
    if (type == Ambulance) {
      await showAmbulanceoptions();
    }
    if (type == Cartype) {
      store.carride.addAll({
        'PaymentType': paymentMethod,
        'price': price,
        'ridepreference': rideType,
        'CarType': selectedCar.name,
      });
    } else if (type == DeliveryService) {
      store.carride.addAll({
        'PaymentType': paymentMethod,
        'price': price,
        'ridepreference': rideType,
        'CarType': selectedCar.name,
      });
    } else {
      store.carride.addAll({
        'PaymentType': paymentMethod,
        'price': price,
        'ridepreference': rideType,
      });
    }
    if (type == Ambulance) {
      navigationService.navigateToView(
        SelectAmbulancePassengers(en: en, st: st),
      );
    }
    navigationService.replaceWith(
      Routes.confirmPickUpView,
      arguments: ConfirmPickUpViewArguments(
        end: en,
        start: st,
        bookingtype: bookingType,
      ),
    );
  }

  Future<void> showAmbulanceoptions() async {
    if (type == Ambulance) {
      var ambulanceemercyResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.ambulanceemergency,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Select Medical Emergency ',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (ambulanceemercyResponse!.confirmed) {
        var ambulanceResponse = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.ambulance,
          enableDrag: false,
          barrierDismissible: true,
          title: 'Select extra service',
          mainButtonTitle: 'Continue',
          secondaryButtonTitle: 'This is cool',
        );
      } else {}
    } else {}
  }
}
