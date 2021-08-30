import 'package:avenride/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AvenFoodViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  int chipvalue = -1;
  setChip(bool selected, int index) {
    chipvalue = index;
    notifyListeners();
  }
}
