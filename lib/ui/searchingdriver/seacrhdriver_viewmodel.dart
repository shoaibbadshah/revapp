import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchDriverViewModel extends BaseViewModel {
  final log = getLogger('CarSelectionMapViewModel');
  final navigationService = locator<NavigationService>();
  String source = '', destination = '';
  bool loading = true, isDriver = false;
  double time = 0.0;
  void setSrcDest(String src, String dest, String distanceTime) {
    source = src;
    destination = dest;
    log.v("VALUE IS $distanceTime");
    final val = distanceTime.split(" ");
    log.v("VALUE IS $val");
    time = double.parse(distanceTime);
    loading = false;
    notifyListeners();
  }

  void changeStatus() {
    isDriver = true;
    notifyListeners();
  }
}
