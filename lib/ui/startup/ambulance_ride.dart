import 'dart:convert';

import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/BottomSheetUi/setup_bottom_sheet_ui.dart';
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
            value: _firestoreApi.streamambulance(_userService.currentUser!.id),
            initialData: [],
            child: AmbulanceList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(CarRideView(
          isDropLatLng: false,
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
  final _userService = locator<UserService>();
  MyStore store = VxState.store as MyStore;
  final _navigationService = locator<NavigationService>();
  bool isBusy = false;

  startPayment({required String price, required String id}) async {
    Map headers = {
      "email": _userService.currentUser!.email.toString(),
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: ambulances.length,
            itemBuilder: (context, index) {
              AmbulanceModel ambulance = ambulances[index];
              return Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                height: 18,
                                width: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.5, color: Colors.greenAccent),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  margin: EdgeInsets.all(2),
                                ),
                              ),
                              verticalSpaceTiny,
                              VxDash(
                                direction: Axis.vertical,
                                length: 40,
                                dashLength: 8,
                                dashGap: 4,
                                dashColor: Colors.grey,
                              ),
                              verticalSpaceTiny,
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          horizontalSpaceSmall,
                          Column(
                            children: <Widget>[
                              Container(
                                width: screenWidth(context) / 1.6,
                                height: 40,
                                child: Text(
                                  ambulance.startLocation,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              verticalSpaceSmall,
                              Container(
                                height: 2.0,
                                padding: EdgeInsets.all(0),
                                width: screenWidth(context) / 1.6,
                                color: Colors.grey.shade300,
                                margin: EdgeInsets.only(right: 20),
                              ),
                              verticalSpaceSmall,
                              Container(
                                height: 40,
                                width: screenWidth(context) / 1.6,
                                child: Text(
                                  ambulance.destination,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 1.0,
                          end: 1.0,
                        ),
                        height: 2.0,
                        width: screenWidth(context) / 1.6,
                        color: Colors.grey.shade300,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              verticalSpaceMedium,
                              Icon(
                                Icons.local_taxi,
                              ),
                            ],
                          ),
                          horizontalSpaceSmall,
                          Column(
                            children: [
                              Text(
                                'Distance',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                ambulance.distace,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          horizontalSpaceSmall,
                          Column(
                            children: [
                              verticalSpaceRegular,
                              Text(
                                'Time',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceSmall,
                              Column(
                                children: [
                                  Text(
                                    ambulance.scheduleTime.toLowerCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    ambulance.scheduledDate.toLowerCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          horizontalSpaceSmall,
                          Column(
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceSmall,
                              Container(
                                color: Colors.white,
                                child: Text(
                                  ambulance.price,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 1.0,
                          end: 1.0,
                        ),
                        height: 2.0,
                        width: screenWidth(context) / 1.6,
                        color: Colors.grey.shade300,
                      ),
                      verticalSpaceTiny,
                      PaymentStatusLabel(
                        price: ambulance.price,
                        busy: isBusy,
                        onButtonTapped: () {
                          setState(() {
                            isBusy = true;
                          });
                          startPayment(
                              price: ambulance.price, id: ambulance.id);
                        },
                        paymentStatus: ambulance.paymentStatus,
                      ),
                      verticalSpaceTiny,
                    ],
                  ),
                ),
              );
            },
          );
  }
}
