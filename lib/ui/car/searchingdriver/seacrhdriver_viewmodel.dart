import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/car/barcodescanner/barcodescanner_view.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchDriverViewModel extends BaseViewModel {
  final log = getLogger('SearchDriverViewModel');
  final navigationService = locator<NavigationService>();

  final _userService = locator<UserService>();
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

  showReferalPageAlert(BuildContext context) {
    if (_userService.currentUser != null) {
      Alert(
        context: context,
        title: "Refer Avenride app to family and friends to enjoy free rides",
        buttons: <DialogButton>[
          DialogButton(
            color: Colors.blue,
            child: Text("Not now"),
            onPressed: () {
              navigationService.back();
            },
          ),
          DialogButton(
            child: Text("Continue"),
            onPressed: () {
              // navigationService.replaceWithTransition(
              //   ReferalCodeView(),
              //   transition: 'rightToLeft',
              // );
            },
          ),
        ],
      ).show();
    }
  }

  navigateToScanner() {
    navigationService.navigateToView(QRViewExample());
  }
}
