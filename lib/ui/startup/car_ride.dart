import 'dart:convert';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:avenride/ui/pointmap/RealTimeMap.dart';
import 'package:avenride/ui/postride/feedback/feedback_view.dart';
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

class CarRide extends StatefulWidget {
  CarRide({Key? key}) : super(key: key);

  @override
  _CarRideState createState() => _CarRideState();
}

class _CarRideState extends State<CarRide> {
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
            'Car Ride',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        verticalSpaceSmall,
        Expanded(
          child: StreamProvider<List<CarModel>>.value(
            value: _firestoreApi.streamcar(_userService.currentUser!.id),
            initialData: [],
            child: CarList(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigationService.navigateToView(
          CarRideView(
            isDropLatLng: false,
            formType: Cartype,
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

class CarList extends StatefulWidget {
  CarList({
    Key? key,
  }) : super(key: key);

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
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
          payurl: payurl,
          ref: ref,
          docid: id,
          payfor: 'car',
        ));
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    var cars = Provider.of<List<CarModel>>(context);
    return cars.length == 0
        ? NotAvailable()
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              CarModel car = cars[index];
              return InkWell(
                onTap: () {
                  if (car.rideEnded) {
                    _navigationService.navigateToView(FeedBackView());
                  } else {
                    _navigationService.navigateTo(
                      Routes.searchDriverView,
                      arguments: SearchDriverViewArguments(
                        start: LatLng(
                          car.selectedPlace.latitude,
                          car.selectedPlace.longitude,
                        ),
                        end: LatLng(
                          car.dropoffplace.latitude,
                          car.dropoffplace.longitude,
                        ),
                        rideId: car.id,
                        collectionType: 'CarRide',
                        endText: car.destination,
                        startText: car.startLocation,
                        time: car.distace,
                      ),
                    );
                  }
                },
                child: Card(
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
                                    car.startLocation,
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
                                    car.destination,
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
                                  car.distace,
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
                                      car.scheduleTime.toLowerCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      car.scheduledDate.toLowerCase(),
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
                                    car.price,
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
                        verticalSpaceTiny,
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
