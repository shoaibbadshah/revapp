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
import 'package:avenride/ui/boat_ride/boat_ride_view.dart';
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
            value: _firestoreApi.streamdelivery(_userService.currentUser.id),
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
              return Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    _navigationService.navigateToView(
                      MyMap(
                        DEST_LOCATION:
                            LatLng(delivery.pickupLat, delivery.pickupLong),
                        SOURCE_LOCATION:
                            LatLng(delivery.dropoffLat, delivery.dropoffLong),
                        isBoat: true,
                      ),
                    );
                  },
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
                            startLocation: delivery.pickLocation,
                            paymentStatus: delivery.paymentStatus,
                            onMainButtonTapped: () {
                              _firestoreApi
                                  .deleteBooking(
                                      collectionName: 'delivery',
                                      user: _userService.currentUser,
                                      docId: delivery.id)
                                  .then((value) {
                                _navigationService.back();
                              });
                            },
                          ),
                          verticalSpaceSmall,
                          EndLocationLabel(
                            destination: delivery.dropLocation,
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
                                'Laguage Type:',
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
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              horizontalSpaceMedium,
                              Text(
                                'Laguage Size:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              horizontalSpaceMedium,
                              Text(
                                delivery.laguageSize,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
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
                                '${delivery.price} Nan',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              horizontalSpaceSmall
                            ],
                          ),
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
                          verticalSpaceMedium,
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
