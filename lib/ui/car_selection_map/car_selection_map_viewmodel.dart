import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CarSelectionMapViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  void openCars() async {
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
