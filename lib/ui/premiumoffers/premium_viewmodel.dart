import 'package:avenride/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PremiumViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  int index = 0;
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;

  setIndex(int ind) {
    index = ind;
    notifyListeners();
  }

  setIndex1(int ind) {
    index1 = ind;
    notifyListeners();
  }

  setIndex2(int ind) {
    index2 = ind;
    notifyListeners();
  }

  setIndex3(int ind) {
    index3 = ind;
    notifyListeners();
  }

  setIndex4(int ind) {
    index4 = ind;
    notifyListeners();
  }
}
