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

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  String serviceType = '';
  String brand = '';
  String model = '';
  String numberPlate = '';
  String vehicleColor = '';
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
              'Add Vehicle',
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
                hintText: 'Service Type',
                labelText: 'Service Type',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your Service Type' : null,
              onChanged: (val) {
                serviceType = val;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Brand',
                labelText: 'Brand',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter your Brand' : null,
              onChanged: (val) {
                brand = val;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                hintText: 'Model',
                labelText: 'Model',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter Model' : null,
              onChanged: (val) {
                model = val;
              },
            ),
          ),
          // ListTile(
          //   title: TextFormField(
          //     decoration: textInputDecoration.copyWith(
          //       hintStyle: TextStyle(color: Colors.black),
          //       hintText: 'Manufacturer',
          //       labelText: 'Manufacturer',
          //       labelStyle: TextStyle(
          //         fontSize: 20.0,
          //       ),
          //     ),
          //     validator: (value) =>
          //         value!.isEmpty ? 'Enter Manufacturer' : null,
          //     onChanged: (value) {},
          //   ),
          // ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Number Plate',
                labelText: 'Number Plate',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter Number plate' : null,
              onChanged: (val) {
                numberPlate = val;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Vehicle Color ',
                labelText: 'Vehicle Color ',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter  Vehicle Color ' : null,
              onChanged: (val) {
                vehicleColor = val;
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
                if (serviceType != null ||
                    // ignore: unnecessary_null_comparison
                    brand != null ||
                    // ignore: unnecessary_null_comparison
                    model != null ||
                    // ignore: unnecessary_null_comparison
                    numberPlate != null ||
                    // ignore: unnecessary_null_comparison
                    vehicleColor != null) {
                  setState(() {
                    loading = true;
                    isTrue = false;
                  });
                  Increment({
                    'vehicledetails': {
                      'serviceType': serviceType,
                      'brand': brand,
                      'model': model,
                      'numberPlate': numberPlate,
                      'vehicleColor': vehicleColor,
                    },
                    'vehicle': Confirmed,
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
                padding: MaterialStateProperty.all(
                  EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 3,
                    10,
                    MediaQuery.of(context).size.width / 3,
                    10,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ),
          verticalSpaceLarge
        ],
      ),
    );
  }
}
