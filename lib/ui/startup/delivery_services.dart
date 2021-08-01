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

class DeliveryServices extends StatefulWidget {
  DeliveryServices({Key? key}) : super(key: key);

  @override
  _DeliveryServicesState createState() => _DeliveryServicesState();
}

class _DeliveryServicesState extends State<DeliveryServices> {
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
            'Delivery Services',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        verticalSpaceSmall,
        Expanded(
          child: StreamProvider<List<DeliveryServicesModel>>.value(
            value: _firestoreApi
                .streamdeliveryservices(_userService.currentUser.id),
            initialData: [],
            child: DeliveryServicesList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(CarRideView(
          formType: DeliveryService,
        )),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class DeliveryServicesList extends StatefulWidget {
  DeliveryServicesList({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryServicesListState createState() => _DeliveryServicesListState();
}

class _DeliveryServicesListState extends State<DeliveryServicesList> {
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
          payfor: 'deliveryservices',
        ));
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    var deliveries = Provider.of<List<DeliveryServicesModel>>(context);
    return deliveries.length == 0
        ? NotAvailable()
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: deliveries.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DeliveryServicesModel delivery = deliveries[index];
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
                          startLocation: delivery.startLocation,
                          paymentStatus: delivery.paymentStatus,
                          onMainButtonTapped: () {
                            _firestoreApi
                                .deleteBooking(
                                    collectionName: 'deliveryservices',
                                    user: _userService.currentUser,
                                    docId: delivery.id)
                                .then((value) {
                              _navigationService.back();
                            });
                          },
                        ),
                        verticalSpaceSmall,
                        EndLocationLabel(
                          destination: delivery.destination,
                        ),
                        verticalSpaceSmall,
                        DateLabel(scheduledDate: delivery.scheduledDate),
                        verticalSpaceSmall,
                        TimeLabel(scheduleTime: delivery.scheduleTime),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpaceMedium,
                            Text(
                              'Vehicle Type:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            horizontalSpaceMedium,
                            Text(
                              delivery.carType,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpaceMedium,
                            Text(
                              'Package Type:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            horizontalSpaceMedium,
                            Text(
                              delivery.laguageType,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpaceMedium,
                            Text(
                              'Package Size:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            horizontalSpaceMedium,
                            Text(
                              '${delivery.laguageSize} kgs',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        PaymentStatusLabel(
                          busy: isBusy,
                          onButtonTapped: () {
                            setState(() {
                              isBusy = true;
                            });
                            startPayment(
                                price: delivery.price, id: delivery.id);
                          },
                          paymentStatus: delivery.paymentStatus,
                          price: delivery.price,
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
