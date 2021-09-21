import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CarSelectionMapViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final navigationService = locator<NavigationService>();
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(carTypes[0].price);
  double storedprice = 0.0;
  NameIMG selectedCar = NameIMG('AVR', Assets.car1, '100.0');

  String submitBtnText = 'AVR';

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
}
