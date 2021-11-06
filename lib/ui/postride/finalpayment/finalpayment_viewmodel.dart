import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/ui/paypal/paypalpayment.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FinalPaymentViewModel extends BaseViewModel {
  final log = getLogger('FinalPaymentViewModel');
  final navigationService = locator<NavigationService>();
  String paymentmode = 'Cash';
  bool completePayment = false;
  String selectedFeedback = '-1';
  void setPayment(String paymenttype) {
    paymentmode = paymenttype;
    if (paymenttype == "Cash") {
      completePayment = true;
    }
    notifyListeners();
  }

  void paywithPaypal() {
    navigationService.navigateToView(
      PaypalPayment(
        onFinish: (number) async {
          log.v('order id: ' + number);
        },
      ),
    );
  }

  void setSelectedFeedback(String value) {
    selectedFeedback = value;
    notifyListeners();
    print(selectedFeedback);
  }

  void checkFeedback(BuildContext context) {}

  submit(BuildContext context) {
    if (selectedFeedback == '-1') {
      final snackBar = SnackBar(
        content: Text('Please enter your feedback!'),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (completePayment) {
      return navigationService.clearStackAndShow(Routes.startUpView);
    } else {
      final snackBar = SnackBar(
        content: Text('Please complete your payment!'),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
