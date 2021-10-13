import 'dart:ui';

import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/api/paystack_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TransferToDriverViewModel extends BaseViewModel {
  final _paystackApiService = locator<PaystackApi>();
  final firestoreApi = locator<FirestoreApi>();
  final userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmNameController = TextEditingController();
  List banks = [];
  bool loading = true, isNameVisible = false;
  String choosenBank = '', accountNo = '', birthDay = '', bankCode = '';
  Color confirmAccount = Colors.black;
  listAllBanks() async {
    final data = await _paystackApiService.getAllBanks();
    banks = data;
    choosenBank = banks[0]['name'];
    loading = false;
    notifyListeners();
  }

  void setValue(
    String? value,
  ) {
    choosenBank = value!;
    for (var i = 0; i < banks.length; i++) {
      if (choosenBank == banks[i]['name']) {
        bankCode = banks[i]['code'];
      }
    }
    notifyListeners();
  }

  void setAccountNo(String val) {
    accountNo = val;
    notifyListeners();
  }

  void setConfirmState(bool bool) {
    if (bool) {
      confirmAccount = Colors.green;
    } else {
      confirmAccount = Colors.red;
    }
    notifyListeners();
  }

  void setBirthDay(String val) {
    birthDay = val;
    notifyListeners();
  }

  void handleSubmit(BuildContext context) async {
    if (isNameVisible == false) {
      loading = true;
      notifyListeners();
      final data = await _paystackApiService.verifyUserAccount(
        bankCode: bankCode,
        accountNo: accountNoController.text,
      );
      final snackBar = SnackBar(content: Text(data['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (data['status']) {
        isNameVisible = true;
        nameController.text = data['data']['account_name'];
      }
      loading = false;
      notifyListeners();
    }
    // if (isNameVisible) {
    //   await firestoreApi.updateRider(
    //     data: {
    //       'bankDetails': {
    //         "bankName": choosenBank,
    //         "accountNo": accountNoController.text,
    //         "name": nameController.text,
    //       }
    //     },
    //     user: userService.currentUser.id,
    //   );
    //   _navigationService.back();
    // }
  }
}
