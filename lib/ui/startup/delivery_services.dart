import 'dart:convert';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                .streamdeliveryservices(_userService.currentUser!.id),
            initialData: [],
            child: DeliveryServicesList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(
          CarRideView(
            isDropLatLng: false,
            formType: DeliveryService,
          ),
        ),
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
            itemCount: deliveries.length,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              DeliveryServicesModel delivery = deliveries[index];
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    print(delivery.id);
                    _navigationService.navigateTo(
                      Routes.searchDriverView,
                      arguments: SearchDriverViewArguments(
                        start: LatLng(
                          delivery.selectedPlace.latitude,
                          delivery.selectedPlace.longitude,
                        ),
                        end: LatLng(
                          delivery.dropoffplace.latitude,
                          delivery.dropoffplace.longitude,
                        ),
                        rideId: delivery.id,
                        collectionType: 'DeliveryServices',
                        endText: delivery.destination,
                        startText: delivery.startLocation,
                        time: delivery.distace,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                          width: 1.5,
                                          color: Colors.greenAccent),
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
                                      delivery.startLocation,
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
                                      delivery.destination,
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
                                  Text(
                                    'Vehicle',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    delivery.carType,
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
                                    'Distance',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    delivery.distace,
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
