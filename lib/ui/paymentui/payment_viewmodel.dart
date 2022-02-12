import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/addbank/add_bank_view.dart';
import 'package:avenride/ui/paymentui/creditCardList.dart';
import 'package:avenride/ui/paymentui/creditcard_view.dart';
import 'package:avenride/ui/transfertodriver/transferto_driver_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentViewModel extends BaseViewModel {
  final log = getLogger('PaymentViewModel');
  final _navigationService = locator<NavigationService>();
  MyStore store = VxState.store as MyStore;
  String choosenPaymentMethod = 'Cash';
  String choosenRide = 'Personal Ride';
  List rides = [
    "Personal Ride",
    "Shared Ride",
  ];
  List paymentMethods = [
    "Cash",
    "Paypal",
    "Credit/Debit Card",
    "Add Your Bank Account",
  ];

  void navigateTo(int index) async {
    if (index == 0) {
      _navigationService.navigateToView(AddBankView());
    }
    if (index == 1) {
      _navigationService.navigateToView(TransferToDriverView());
    }
    if (index == 3) {
      _navigationService.navigateToView(CreditCardList());
    }
    // if (index == 2) {
    //   _navigationService.navigateToView(
    //     PaypalPayment(
    //       onFinish: (number) async {
    //         // payment done
    //         log.v('order id: ' + number);
    //       },
    //     ),
    //   );
    // }
  }

  void setRideType(rid) {
    choosenRide = rid;
    notifyListeners();
    ChangePaymentMethod(choosenPaymentMethod, choosenRide);
  }

  void setPaymentType(paymentMethod) {
    choosenPaymentMethod = paymentMethod;
    notifyListeners();
    ChangePaymentMethod(choosenPaymentMethod, choosenRide);
    if (choosenPaymentMethod == "Add Your Bank Account") {
      navigateTo(0);
    }
    if (choosenPaymentMethod == "Credit/Debit Card") {
      navigateTo(3);
    }
    if (choosenPaymentMethod == "Paypal") {
      navigateTo(2);
    }
  }
}
