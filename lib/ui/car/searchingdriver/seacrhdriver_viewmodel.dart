import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchDriverViewModel extends BaseViewModel {
  final log = getLogger('SearchDriverViewModel');
  final navigationService = locator<NavigationService>();
  final firestoreApi = locator<FirestoreApi>();
  String source = '', destination = '', otp = 'NA';
  bool loading = true, isDriver = false;
  double time = 0.0;
  void setSrcDest(String src, String dest, String distanceTime) {
    source = src;
    destination = dest;
    time = double.parse(distanceTime);
    loading = false;
    notifyListeners();
  }

  void changeStatus() {
    isDriver = true;
    notifyListeners();
  }

  void updateDriver() {
    isDriver = !isDriver;
    notifyListeners();
  }
}
