import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';

class ProfileInfo extends StatefulWidget {
  bool isMainScreen = false;
  ProfileInfo({Key? key, required this.isMainScreen}) : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();
  String name = '';
  String email = '';
  String mobileNo = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (userService.currentUser.mobileNo != null) {
        mobileNo = userService.currentUser.mobileNo!;
      }
      if (userService.currentUser.name != null) {
        name = userService.currentUser.name!;
      }
      if (userService.currentUser.email != null) {
        email = userService.currentUser.email!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: logoAppBar(),
      body: ListView(
        children: [
          verticalSpaceRegular,
          Center(
            child: Text(
              'Add Product',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          verticalSpaceMedium,
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Enter Name',
                labelText: 'Enter Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              initialValue: name,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          verticalSpaceSmall,
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Enter Email',
                labelText: 'Enter Email',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter Email' : null,
              initialValue: email,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
          ),
          verticalSpaceSmall,
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Enter Mobile No.',
                labelText: 'Enter Mobile No.',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter Mobile No.' : null,
              initialValue: mobileNo,
              onChanged: (val) {
                setState(() {
                  mobileNo = val;
                });
              },
            ),
          ),
          verticalSpaceSmall,
          Center(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                FocusScope.of(context).requestFocus(FocusNode());
                if (name.isNotEmpty &&
                    email.isNotEmpty &&
                    mobileNo.isNotEmpty) {
                  await firestoreApi.updateRider(data: {
                    "name": name,
                    "email": email,
                    "mobileNo": mobileNo,
                  }, user: userService.currentUser.id);
                  final snackBar = SnackBar(
                    content: Text('Profile Updated Successsfully'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  );
                  await userService.syncUserAccount();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    loading = false;
                  });
                  if (widget.isMainScreen) {
                    _navigationService.navigateTo(Routes.startUpView);
                  } else {
                    _navigationService.back();
                  }
                } else {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Complete Form',
                      style: TextStyle(color: Colors.white),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: Container(
                width: screenWidth(context) / 1.7,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber,
                ),
                child: loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          verticalSpaceSmall,
        ],
      ),
    );
  }
}
