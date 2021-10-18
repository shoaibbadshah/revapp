import 'dart:convert';
import 'package:avenride/ui/pointmap/MyMap.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/main.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/BottomSheetUi/setup_bottom_sheet_ui.dart';
import 'package:avenride/ui/boat/boat_ride/boat_ride_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class DeliveryRide extends StatefulWidget {
  DeliveryRide({Key? key}) : super(key: key);

  @override
  _DeliveryRideState createState() => _DeliveryRideState();
}

class _DeliveryRideState extends State<DeliveryRide> {
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
            'Delivery',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        verticalSpaceSmall,
        Expanded(
          child: StreamProvider<List<DeliveryModel>>.value(
            value: _firestoreApi.streamdelivery(_userService.currentUser!.id),
            initialData: [],
            child: DeliveryList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(BoatRideView(
          isBoat: false,
        )),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class DeliveryList extends StatefulWidget {
  DeliveryList({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  final _userService = locator<UserService>();

  MyStore store = VxState.store as MyStore;

  final _navigationService = locator<NavigationService>();
  final _firestoreApi = locator<FirestoreApi>();

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
          payfor: 'delivery',
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
    var deliveries = Provider.of<List<DeliveryModel>>(context);
    return deliveries.length == 0
        ? NotAvailable()
        : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              DeliveryModel delivery = deliveries[index];
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
                                length: 20,
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
                                child: Text(
                                  delivery.pickLocation,
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
                                width: screenWidth(context) / 1.6,
                                child: Text(
                                  delivery.dropLocation,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpaceTiny,
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
                                Icons.directions_boat,
                              ),
                            ],
                          ),
                          horizontalSpaceSmall,
                          Column(
                            children: [
                              Text(
                                'Laguage',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                delivery.laguageType,
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
                              Text(
                                'Weight',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                '${delivery.laguageSize} kg',
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
                                    delivery.scheduleTime.toLowerCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    delivery.scheduledDate.toLowerCase(),
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
                                  delivery.price,
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
                        price: delivery.price,
                        busy: isBusy,
                        onButtonTapped: () {
                          setState(() {
                            isBusy = true;
                          });
                          startPayment(price: '1000', id: delivery.id);
                        },
                        paymentStatus: delivery.paymentStatus,
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
