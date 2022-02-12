import 'dart:convert';

import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_io/io.dart';
import 'package:avenride/ui/paymentui/creditcard_view.dart';

import 'package:http/http.dart' as http;

String backendUrl =
    'https://us-central1-unique-nuance-310113.cloudfunctions.net/paystackapi';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
String paystackPublicKey = 'pk_test_d91d74717418dad1833022dab04e1bea744a9666';
const String appName = 'Avenride';

class ChargeCard {
  final plugin = PaystackPlugin();

  void initialize() {
    plugin.initialize(publicKey: paystackPublicKey);
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  startAfreshCharge(PaymentCard card, int amount, BuildContext context,
      {required Function(bool resp) onFinish}) async {
    final userService = locator<UserService>();
    Charge charge = Charge();
    charge.card = card;

    // Set transaction params directly in app (note that these params
    // are only used if an access_code is not set. In debug mode,
    // setting them after setting an access code would throw an exception

    charge
      ..amount = (amount * 100) // In base currency
      ..email = userService.currentUser!.email
      ..reference = _getReference()
      ..putCustomField('Charged From', 'Avenride Inc.');
    await _chargeCard(
      charge,
      context,
      onFinish: (bool res) {
        onFinish(res);
      },
    );
  }

  _verifyOnServer(String? reference) async {
    String url = '$backendUrl/verify/$reference';
    print(url);
    try {
      http.Response response = await http.get(Uri.parse(url));
      var body = response.body;
      return body;
    } catch (e) {}
  }

  _chargeCard(Charge charge, BuildContext context,
      {required Function(bool res) onFinish}) async {
    final response = await plugin.chargeCard(context, charge: charge);
    final navigationService = locator<NavigationService>();
    final reference = response.reference;
    final firestoreApi = locator<FirestoreApi>();

    // Checking if the transaction is successful
    if (response.status) {
      final res = await _verifyOnServer(reference);
      Map body = json.decode(res);
      await firestoreApi.createCustomerPayment(data: body);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text('Payment successful, congratulations!'),
        duration: Duration(seconds: 3),
        action: new SnackBarAction(
            label: 'CLOSE',
            onPressed: () =>
                ScaffoldMessenger.of(context).removeCurrentSnackBar()),
      ));
      return onFinish(response.status);
    }
    return onFinish(response.status);
  }
}
