import 'package:avenride/app/app.locator.dart';
import 'package:avenride/ui/addbank/add_bank_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();

  String paymentMethod = 'Cash';
  List rides = [
    "Personal Ride",
    "Shared Ride",
  ];
  List paymentMethods = [
    "Bank Account",
    "Cash",
  ];

  void navigateTo(int index) {
    if (index == 0) {
      navigationService.navigateToView(AddBankView());
    }
  }
}
