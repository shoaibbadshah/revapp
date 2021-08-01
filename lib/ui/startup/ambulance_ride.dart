import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/BottomSheetUi/setup_bottom_sheet_ui.dart';
import 'package:avenride/ui/car_ride/car_ride_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class AmbulanceRide extends StatefulWidget {
  AmbulanceRide({Key? key}) : super(key: key);

  @override
  _AmbulanceRideState createState() => _AmbulanceRideState();
}

class _AmbulanceRideState extends State<AmbulanceRide> {
  final _userService = locator<UserService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbg,
        title: Container(
          height: 50,
          child: Image.asset(
            Assets.firebase,
            fit: BoxFit.scaleDown,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        verticalSpaceSmall,
        Center(
          child: Text(
            'Ambulance',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        verticalSpaceSmall,
        Expanded(
          child: StreamProvider<List<AmbulanceModel>>.value(
            value: _firestoreApi.streamambulance(_userService.currentUser.id),
            initialData: [],
            child: AmbulanceList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(CarRideView(
          formType: Ambulance,
        )),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class AmbulanceList extends StatefulWidget {
  AmbulanceList({
    Key? key,
  }) : super(key: key);

  @override
  _AmbulanceListState createState() => _AmbulanceListState();
}

class _AmbulanceListState extends State<AmbulanceList> {
  final _firestoreApi = locator<FirestoreApi>();

  final _userService = locator<UserService>();
  MyStore store = VxState.store as MyStore;
  final _navigationService = locator<NavigationService>();
  bool isBusy = false;

  startPayment({required String price, required String id}) async {
    Map headers = {
      "email": _userService.currentUser.email.toString(),
      "amount": price,
    };
    final response = await http.post(
      Uri.parse(Assets.getPaymentLink),
      body: headers,
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      if (data['status']) {
        final payurl = data['data']['authorization_url'];
        final ref = data['data']['reference'];
        if (mounted) {
          setState(() {
            isBusy = false;
          });
        }

        _navigationService.navigateToView(Payweb(
          payfor: 'ambulance',
          payurl: payurl,
          ref: ref,
          docid: id,
        ));
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    var ambulances = Provider.of<List<AmbulanceModel>>(context);

    return ambulances.length == 0
        ? NotAvailable()
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: ambulances.length,
            itemBuilder: (context, index) {
              AmbulanceModel ambulance = ambulances[index];
              return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber, width: 2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceSmall,
                        StartLocationLabel(
                          startLocation: ambulance.startLocation,
                          paymentStatus: ambulance.paymentStatus,
                          onMainButtonTapped: () {
                            _firestoreApi
                                .deleteBooking(
                                    collectionName: 'ambulance',
                                    user: _userService.currentUser,
                                    docId: ambulance.id)
                                .then((value) {
                              _navigationService.back();
                            });
                          },
                        ),
                        verticalSpaceSmall,
                        EndLocationLabel(
                          destination: ambulance.destination,
                        ),
                        verticalSpaceSmall,
                        DateLabel(scheduledDate: ambulance.scheduledDate),
                        verticalSpaceSmall,
                        TimeLabel(scheduleTime: ambulance.scheduleTime),
                        PaymentStatusLabel(
                          price: ambulance.price.toString(),
                          busy: isBusy,
                          onButtonTapped: () {
                            setState(() {
                              isBusy = true;
                            });
                            startPayment(
                              price: ambulance.price.toString(),
                              id: ambulance.id,
                            );
                          },
                          paymentStatus: ambulance.paymentStatus,
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
