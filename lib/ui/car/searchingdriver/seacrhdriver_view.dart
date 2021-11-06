import 'dart:ui';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/car/searchingdriver/seacrhdriver_viewmodel.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class SearchDriverView extends StatelessWidget {
  SearchDriverView({
    Key? key,
    required this.start,
    required this.end,
    required this.rideId,
    required this.collectionType,
    required this.startText,
    required this.endText,
    required this.time,
  }) : super(key: key);
  final LatLng start, end;
  final String rideId, collectionType, startText, endText, time;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchDriverViewModel>.reactive(
      onModelReady: (model) {
        model.setSrcDest(
          startText,
          endText,
          time,
        );
      },
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: DecoratedBox(
            decoration: new BoxDecoration(
              color: Colors.amber[50],
            ),
            child: model.loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                  )
                : StreamProvider<CarModelRideDetail>.value(
                    value:
                        model.firestoreApi.streamRide(collectionType, rideId),
                    initialData: CarModelRideDetail(
                      drivers: '',
                      destination: 'destination',
                      distace: 'distace',
                      rideEnded: false,
                      otp: '',
                      selectedPlace: GeoPoint(00, 00),
                      dropoffplace: GeoPoint(00, 00),
                      price: 'price',
                      pushToken: 'pushToken',
                      carType: 'carType',
                      paymentStatus: 'paymentStatus',
                      id: 'id',
                      paymentType: 'paymentType',
                      startLocation: 'startLocation',
                      scheduleTime: 'scheduleTime',
                      rideType: 'rideType',
                      scheduledDate: 'scheduledDate',
                    ),
                    builder: (context, child) {
                      CarModelRideDetail car =
                          Provider.of<CarModelRideDetail>(context);
                      return SnappingSheet(
                        snappingPositions: [
                          SnappingPosition.factor(
                            positionFactor: 0.6,
                            snappingCurve: Curves.bounceOut,
                            snappingDuration: Duration(seconds: 1),
                            grabbingContentOffset: GrabbingContentOffset.bottom,
                          ),
                          SnappingPosition.factor(
                            positionFactor: 0.45,
                            snappingCurve: Curves.elasticOut,
                            snappingDuration: Duration(seconds: 1),
                          ),
                        ],
                        initialSnappingPosition: SnappingPosition.factor(
                          positionFactor: 0.45,
                          snappingCurve: Curves.elasticOut,
                          snappingDuration: Duration(milliseconds: 1750),
                        ),
                        grabbingHeight: 60,
                        grabbing: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              verticalSpaceRegular,
                              Container(
                                width: 40,
                                color: Colors.grey,
                                height: 5,
                              ),
                              verticalSpaceTiny,
                              Center(
                                child: Text(
                                  car.drivers != '' || !car.rideEnded
                                      ? 'Arriving in 5 min'
                                      : 'Looking for a Driver..',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sheetBelow: SnappingSheetContent(
                          draggable: true,
                          child: Container(
                            color: Colors.white,
                            child: car.drivers != ''
                                ? StreamProvider<DriverModel>.value(
                                    value: model.firestoreApi
                                        .streamDriver(car.drivers),
                                    initialData: DriverModel(
                                      id: 'id',
                                      email: 'email',
                                      defaultAddress: 'defaultAddress',
                                      name: 'name',
                                      totalpayout: '',
                                      mobileNo: '',
                                      photourl:
                                          'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
                                      personaldocs: 'personaldocs',
                                      bankdocs: 'bankdocs',
                                      vehicle: 'vehicle',
                                      isBoat: false,
                                      isVehicle: false,
                                      vehicledocs: 'vehicledocs',
                                      rides: [],
                                      cargo: [],
                                      vehicleDetails: {},
                                      ambulance: [],
                                      car: [],
                                      delivery: [],
                                      taxi: [],
                                    ),
                                    builder: (context, child) {
                                      DriverModel driver =
                                          Provider.of<DriverModel>(context);
                                      return ListView(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    driver.isVehicle
                                                        ? Row(
                                                            children: [
                                                              Text(
                                                                driver.vehicleDetails[
                                                                        'vehicleColor'] ??
                                                                    'color',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              horizontalSpaceTiny,
                                                              Center(
                                                                child:
                                                                    Container(
                                                                  width: 5,
                                                                  height: 5,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              horizontalSpaceTiny,
                                                              Text(
                                                                driver.vehicleDetails[
                                                                        'model'] ??
                                                                    'car',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : SizedBox(),
                                                    verticalSpaceTiny,
                                                    Text(
                                                      driver.vehicleDetails[
                                                              'numberPlate'] ??
                                                          'NumberPlate',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(0.5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      model.navigationService
                                                          .navigateToView(
                                                        DetailScreen(
                                                          imgUrl:
                                                              driver.photourl,
                                                        ),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      radius: 30,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Hero(
                                                          tag: 'imageHero',
                                                          child: Image.network(
                                                              driver.photourl),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Your driver is ${driver.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '4,597 rides',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          verticalSpaceRegular,
                                          Text(
                                            'Your otp is ${car.otp}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          verticalSpaceRegular,
                                          Text(
                                            car.paymentType,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          verticalSpaceRegular,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  launch(
                                                      "tel://${driver.mobileNo}");
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          30,
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Icon(
                                                        Icons.person,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Contact',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              horizontalSpaceMedium,
                                              GestureDetector(
                                                onTap: () {
                                                  Share.share(
                                                      'https://avenweb.web.app/');
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          30,
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Icon(
                                                        Icons.location_on_sharp,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Share Ride Info',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              horizontalSpaceMedium,
                                              Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        30,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(
                                                      Icons
                                                          .cancel_presentation_rounded,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cancel Ride',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  )
                                : Container(
                                    width: screenWidth(context),
                                    height: 600,
                                    child: Column(
                                      children: [
                                        AvatarGlow(
                                          glowColor: Colors.green,
                                          endRadius: 90.0,
                                          duration:
                                              Duration(milliseconds: 2000),
                                          repeat: true,
                                          repeatPauseDuration:
                                              Duration(milliseconds: 100),
                                          child: Text(''),
                                        ),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     model.changeStatus();
                                        //   },
                                        //   child: Text('data'),
                                        // ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: screenHeight(context) / 1.5,
                              child: BookingMap(
                                DEST_LOCATION: end,
                                SOURCE_LOCATION: start,
                                source: model.source,
                                destination: model.destination,
                                duration: model.time.toInt(),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  model.navigationService.back();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => SearchDriverViewModel(),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.imgUrl}) : super(key: key);
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
