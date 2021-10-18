import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/paymentui/payment_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class BoatSelectionMapViewModel extends BaseViewModel {
  final log = getLogger('BoatSelectionMapViewModel');
  final _bottomSheetService = locator<BottomSheetService>();
  final navigationService = locator<NavigationService>();
  MyStore store = VxState.store as MyStore;
  int selectedIndex = 0;
  bool isbusy = false;
  String paymentMethod = 'Cash';
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(carTypes[0].price);
  double storedprice = 0.0;
  NameIMG selectedCar = NameIMG('AV Boat 75', Assets.boat1, '200.0');
  String source = '', destination = '';
  double time = 0;
  String submitBtnText = 'AV Boat 75';

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
    var sheetResponse = await _bottomSheetService.showCustomSheet(
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
        log.v('message ${store.paymentMethod} and ${store.rideType}');
        rideType = store.rideType;
        paymentMethod = store.paymentMethod;
        notifyListeners();
        navigationService.back();
      },
    ));
  }

  void onConfirmPressed(LatLng st, LatLng en) {
    store.carride.addAll({
      'PaymentType': paymentMethod,
      'price': price,
      'rideType': rideType,
      'BoatType': selectedCar.name,
    });
    log.v(store.carride);
    navigationService.replaceWith(
      Routes.boatConfirmPickUpView,
      arguments: BoatConfirmPickUpViewArguments(end: en, start: st),
    );
  }
}
