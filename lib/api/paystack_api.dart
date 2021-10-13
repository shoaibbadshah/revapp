import 'dart:convert';

import 'package:avenride/app/app.logger.dart';
import 'package:avenride/exceptions/firestore_api_exception.dart';
import 'package:http/http.dart' as http;

class PaystackApi {
  final log = getLogger('PaystackApi');
  static String payStackApi = 'https://api.paystack.co';

  Future<List> getAllBanks() async {
    try {
      final response = await http.get(
        Uri.parse('$payStackApi/bank'),
        headers: {
          "Authorization":
              'Bearer pk_test_d91d74717418dad1833022dab04e1bea744a9666'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res["status"]) {
          return res["data"];
        }
      }
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to get all banks',
        devDetails: '$error',
      );
    }
    throw FirestoreApiException(
      message: 'Failed to get all banks',
      devDetails: 'return error',
    );
  }

  Future verifyUserAccount(
      {required String bankCode, required String accountNo}) async {
    try {
      log.v('hello ther');
      final response = await http.get(
        Uri.parse(
            '$payStackApi/bank/resolve?account_number=$accountNo&bank_code=$bankCode'),
        headers: {
          "Authorization":
              'Bearer sk_test_7dc4187b7e2bb6084d9daabbe3a155b5d21a18bd'
        },
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      return res;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to verify the user account',
        devDetails: '$error',
      );
    }
  }
}
