import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BarCodeScannerViewModel extends BaseViewModel {
  final log = getLogger('BarCodeScannerViewModel');
  final _userService = locator<UserService>();
  final navigationService = locator<NavigationService>();
  final firestoreApi = locator<FirestoreApi>();
  bool isError = false;
  String errorText = '';
  Driver driver = Driver(
    mobileNo: '',
    name: '',
    carColor: '',
    carModel: '',
    carNumber: '',
    isSuperDriver: false,
    isVerified: false,
    photoUrl: 'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
  );
  void getData(String code) async {
    final data = await firestoreApi.getDriver(userId: code);
    final type = data.runtimeType.toString();
    if (data != null) {
      if (type == "_InternalLinkedHashMap<String, dynamic>") {
        setUser(
          Driver(
            name: data['name'],
            mobileNo: data['mobileNo'],
            carColor: data['vehicledetails']['vehicleColor'],
            carModel: data['vehicledetails']['brand'],
            carNumber: data['vehicledetails']['numberPlate'],
            isSuperDriver: data['superdriver'],
            isVerified: data['alldocs'],
            photoUrl: data['photourl'],
          ),
        );
        log.wtf(driver.toString());
      } else {
        setIsError(true);
      }
    }
  }

  setIsError(bool sta) {
    isError = sta;
    notifyListeners();
  }

  setErrorText(String text) {
    errorText = text;
    notifyListeners();
  }

  setUser(Driver user) {
    driver = user;
    notifyListeners();
  }
}

class Driver {
  final String name;
  final String mobileNo;
  final String photoUrl;
  final String carModel;
  final String carNumber;
  final String carColor;
  final bool isVerified;
  final bool isSuperDriver;
  Driver({
    required this.carColor,
    required this.carModel,
    required this.carNumber,
    required this.isSuperDriver,
    required this.isVerified,
    required this.mobileNo,
    required this.name,
    required this.photoUrl,
  });
}
