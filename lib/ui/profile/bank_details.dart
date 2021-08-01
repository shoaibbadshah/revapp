import 'package:flutter/material.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  String bankName = '';
  String accountHolderName = '';
  String accountNumber = '';
  String swiftIFSCCode = '';
  bool loading = false;
  bool isTrue = false;

  final _userService = locator<UserService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();

  MyStore store = VxState.store as MyStore;
  @override
  void initState() {
    super.initState();
    store.carride = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: logoAppBar(),
      body: ListView(
        children: [
          verticalSpaceMedium,
          Center(
            child: Text(
              'Bank Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          verticalSpaceSmall,
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Bank Name',
                labelText: 'Bank Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your Bank name' : null,
              onChanged: (val) {
                bankName = val;
                print(bankName);
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Account Holder Name',
                labelText: 'Account Holder Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your Account Holder Name' : null,
              onChanged: (val) {
                accountHolderName = val;
                print(accountHolderName);
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Account Number',
                labelText: 'Account Number',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter Account Number' : null,
              onChanged: (val) {
                accountNumber = val;
                print(accountNumber);
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Swift/IFSC Code',
                labelText: 'Swift/IFSC Code',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter Swift/IFSC Code' : null,
              onChanged: (val) {
                swiftIFSCCode = val;
                print(swiftIFSCCode);
              },
            ),
          ),
          verticalSpaceMedium,
          termsCondition(context),
          verticalSpaceSmall,
          isTrue
              ? Center(
                  child: Text(
                  'Complete the above form',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ))
              : SizedBox(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ElevatedButton(
              onPressed: () async {
                // ignore: unnecessary_null_comparison
                if (bankName != null ||
                    // ignore: unnecessary_null_comparison
                    accountHolderName != null ||
                    // ignore: unnecessary_null_comparison
                    accountNumber != null ||
                    // ignore: unnecessary_null_comparison
                    swiftIFSCCode != null) {
                  setState(() {
                    loading = true;
                    isTrue = false;
                  });
                  Increment({
                    'bankdetails': {
                      'bankName': bankName,
                      'accountHolderName': accountHolderName,
                      'accountNumber': accountNumber,
                      'swiftIFSCCode': swiftIFSCCode,
                    },
                    'bankdocs': Confirmed,
                  });
                  await _firestoreApi
                      .updateRider(
                          data: store.carride,
                          user: _userService.currentUser.id)
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    _navigationService.back();
                  });
                } else {
                  setState(() {
                    isTrue = true;
                  });
                }
              },
              child: loading ? loadingButton() : Text('Submit'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 3,
                    10,
                    MediaQuery.of(context).size.width / 3,
                    10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
