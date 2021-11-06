import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/ui/startup/delivery_ride.dart';
import 'package:avenride/ui/startup/delivery_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/ambulance_ride.dart';
import 'package:avenride/ui/startup/boat_ride.dart';
import 'package:avenride/ui/startup/car_ride.dart';
import 'package:avenride/ui/startup/taxi_ride.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class BookingView extends StatefulWidget {
  bool enableAppBar = false;
  final String bookingtype;
  BookingView({Key? key, required this.enableAppBar, required this.bookingtype})
      : super(key: key);
  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  ScrollController controller = new ScrollController();

  final _userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
        body: widget.bookingtype == Cartype
            ? StreamProvider<List<CarModel>>.value(
                value: firestoreApi.streamcar(_userService.currentUser!.id),
                initialData: [],
                child: CarList(),
              )
            : widget.bookingtype == Taxi
                ? StreamProvider<List<TaxiModel>>.value(
                    value:
                        firestoreApi.streamtaxi(_userService.currentUser!.id),
                    initialData: [],
                    builder: (context, child) {
                      return TaxiList();
                    },
                  )
                : widget.bookingtype == Ambulance
                    ? StreamProvider<List<AmbulanceModel>>.value(
                        value: firestoreApi.streamambulance(
                          _userService.currentUser!.id,
                        ),
                        initialData: [],
                        child: AmbulanceList(),
                      )
                    : widget.bookingtype == DeliveryService
                        ? StreamProvider<List<DeliveryServicesModel>>.value(
                            value: firestoreApi.streamdeliveryservices(
                              _userService.currentUser!.id,
                            ),
                            initialData: [],
                            child: DeliveryServicesList(),
                          )
                        : widget.bookingtype == BoatRidetype
                            ? StreamProvider<List<BoatModel>>.value(
                                value: firestoreApi
                                    .streamboat(_userService.currentUser!.id),
                                initialData: [],
                                child: BoatList(),
                              )
                            : widget.bookingtype == WaterCargo
                                ? StreamProvider<List<DeliveryModel>>.value(
                                    value: firestoreApi.streamdelivery(
                                        _userService.currentUser!.id),
                                    initialData: [],
                                    child: Container(
                                      child: DeliveryList(),
                                    ),
                                  )
                                : Card(
                                    child: ListTile(
                                      title: Text('item'),
                                    ),
                                  ),
      ),
      viewModelBuilder: () => BookingViewModel(),
    );
  }
}

class BookingSubScreen extends StatefulWidget {
  BookingSubScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BookingSubScreenState createState() => _BookingSubScreenState();
}

class _BookingSubScreenState extends State<BookingSubScreen> {
  List<Item> _items = [
    generateItems(headerText: 'Car Ride'),
    generateItems(headerText: 'Bus/Taxi Ride'),
    generateItems(headerText: 'Ambulance'),
    generateItems(headerText: 'Delivery Services'),
    generateItems(headerText: 'Boat Ride'),
    generateItems(headerText: 'Water Cargo'),
  ];

  final _userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _items[index].isExpanded = !isExpanded;
                });
              },
              children: _items.map<ExpansionPanel>(
                (Item item) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          item.headerValue,
                          style: ktsMediumGreyBodyText,
                        ),
                      );
                    },
                    body: item.headerValue == 'Car Ride'
                        ? StreamProvider<List<CarModel>>.value(
                            value: firestoreApi
                                .streamcar(_userService.currentUser!.id),
                            initialData: [],
                            child: Container(
                              height: 360,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CarList(),
                            ),
                          )
                        : item.headerValue == 'Bus/Taxi Ride'
                            ? StreamProvider<List<TaxiModel>>.value(
                                value: firestoreApi
                                    .streamtaxi(_userService.currentUser!.id),
                                initialData: [],
                                child: Container(
                                  height: 350,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: TaxiList(),
                                ),
                              )
                            : item.headerValue == 'Ambulance'
                                ? StreamProvider<List<AmbulanceModel>>.value(
                                    value: firestoreApi.streamambulance(
                                      _userService.currentUser!.id,
                                    ),
                                    initialData: [],
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height: 360,
                                      child: AmbulanceList(),
                                    ),
                                  )
                                : item.headerValue == 'Delivery Services'
                                    ? StreamProvider<
                                        List<DeliveryServicesModel>>.value(
                                        value:
                                            firestoreApi.streamdeliveryservices(
                                                _userService.currentUser!.id),
                                        initialData: [],
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 340,
                                              child: DeliveryServicesList(),
                                            ),
                                            verticalSpaceMedium
                                          ],
                                        ),
                                      )
                                    : item.headerValue == 'Boat Ride'
                                        ? StreamProvider<List<BoatModel>>.value(
                                            value: firestoreApi.streamboat(
                                                _userService.currentUser!.id),
                                            initialData: [],
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 300,
                                                  child: BoatList(),
                                                ),
                                                verticalSpaceMedium
                                              ],
                                            ),
                                          )
                                        : item.headerValue == 'Water Cargo'
                                            ? StreamProvider<
                                                List<DeliveryModel>>.value(
                                                value: firestoreApi
                                                    .streamdelivery(_userService
                                                        .currentUser!.id),
                                                initialData: [],
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 300,
                                                      child: DeliveryList(),
                                                    ),
                                                    verticalSpaceMedium
                                                  ],
                                                ),
                                              )
                                            : Card(
                                                child: ListTile(
                                                  title:
                                                      Text(item.expandedValue),
                                                ),
                                              ),
                    isExpanded: item.isExpanded,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
