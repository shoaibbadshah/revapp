import 'dart:math';

import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReferalCodeViewModel extends BaseViewModel {
  final log = getLogger('ReferalCodeViewModel');
  final userService = locator<UserService>();
  final navigationService = locator<NavigationService>();
  String referalCode = 'referalcoed';
  generateReferalCode() {
    String firstname = userService.currentUser!.name!.substring(0, 3);
    Random random = new Random();
    String randomNumber = random.nextInt(1000).toString();
    final data = firstname + randomNumber;
    setReferalCode(data);
  }

  void setReferalCode(String code) {
    referalCode = code;
    notifyListeners();
  }
}
