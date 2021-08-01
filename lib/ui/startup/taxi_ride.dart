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
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class TaxiRide extends StatefulWidget {
  TaxiRide({Key? key}) : super(key: key);

  @override
  _TaxiRideState createState() => _TaxiRideState();
}

class _TaxiRideState extends State<TaxiRide> {
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
            'Bus/Taxi Ride',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        verticalSpaceSmall,
        Expanded(
          child: StreamProvider<List<TaxiModel>>.value(
            value: _firestoreApi.streamtaxi(_userService.currentUser.id),
            initialData: [],
            child: TaxiList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(CarRideView(
          formType: Taxi,
        )),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class TaxiList extends StatefulWidget {
  TaxiList({
    Key? key,
  }) : super(key: key);

  @override
  _TaxiListState createState() => _TaxiListState();
}

class _TaxiListState extends State<TaxiList> {
  final _userService = locator<UserService>();
  MyStore store = VxState.store as MyStore;
  final _navigationService = locator<NavigationService>();
  bool isBusy = false;
  final _firestoreApi = locator<FirestoreApi>();

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
          payurl: payurl,
          ref: ref,
          docid: id,
          payfor: 'taxi',
        ));
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    var taxis = Provider.of<List<TaxiModel>>(context);
    return taxis.length == 0
        ? NotAvailable()
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: taxis.length,
            itemBuilder: (context, index) {
              TaxiModel taxi = taxis[index];
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
                          startLocation: taxi.startLocation,
                          paymentStatus: taxi.paymentStatus,
                          onMainButtonTapped: () {
                            _firestoreApi
                                .deleteBooking(
                                    collectionName: 'taxi',
                                    user: _userService.currentUser,
                                    docId: taxi.id)
                                .then((value) {
                              _navigationService.back();
                            });
                          },
                        ),
                        verticalSpaceSmall,
                        EndLocationLabel(
                          destination: taxi.destination,
                        ),
                        verticalSpaceSmall,
                        DateLabel(scheduledDate: taxi.scheduledDate),
                        verticalSpaceSmall,
                        TimeLabel(scheduleTime: taxi.scheduleTime),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            horizontalSpaceMedium,
                            Text(
                              'Distance:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            horizontalSpaceMedium,
                            Text(
                              '${taxi.distace} min',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            horizontalSpaceSmall
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            horizontalSpaceMedium,
                            Text(
                              'Price:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            horizontalSpaceMedium,
                            Text(
                              '${taxi.price} Nan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            horizontalSpaceSmall
                          ],
                        ),
                        verticalSpaceSmall,
                        PaymentStatusLabel(
                          price: taxi.price,
                          busy: isBusy,
                          onButtonTapped: () {
                            setState(() {
                              isBusy = true;
                            });
                            startPayment(price: taxi.price, id: taxi.id);
                          },
                          paymentStatus: taxi.paymentStatus,
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
