import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/paymentui/payment_view.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:avenride/services/chargec_card.dart';

class PremiumViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
  int index = 0;
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;
  int amount = 0;
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

  void increaseAmount(int i) {
    amount = amount + i;
    notifyListeners();
  }

  void decreaseAmount(int i) {
    amount = amount - i;
    notifyListeners();
  }

  void onSubmit(BuildContext context, List cards) async {
    if (cards.length == 0) {
      return navigationService.navigateToView(PaymentView(
        updatePreferences: () {},
      ));
    }
    final cardApi = locator<ChargeCard>();
    await cardApi.startAfreshCharge(
      PaymentCard(
          cvc: cards[0]['cvc'],
          expiryMonth: cards[0]['expiryMonth'],
          expiryYear: cards[0]['expiryYear'],
          number: cards[0]['number']),
      amount,
      context,
      onFinish: (resp) {
        navigationService.clearStackAndShow(Routes.startUpView);
      },
    );
    // if (res == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //     content: new Text('Payment Failed, try again!'),
    //     duration: Duration(seconds: 3),
    //     action: new SnackBarAction(
    //         label: 'CLOSE',
    //         onPressed: () =>
    //             ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    //   ));
    //   return;
    // }
    // if (res) {
    //   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //     content: new Text('Payment successful, congratulations!'),
    //     duration: Duration(seconds: 3),
    //     action: new SnackBarAction(
    //         label: 'CLOSE',
    //         onPressed: () =>
    //             ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    //   ));
    //   navigationService.clearStackAndShow(Routes.startUpView);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //     content: new Text('Payment Failed, try again!'),
    //     duration: Duration(seconds: 3),
    //     action: new SnackBarAction(
    //         label: 'CLOSE',
    //         onPressed: () =>
    //             ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    //   ));
    // }
  }

  stream() {
    return firestoreApi.streamuser(userService.currentUser!.id);
  }
}
