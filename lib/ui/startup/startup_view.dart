import 'dart:async';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/car_ride/car_ride_viewmodel.dart';
import 'package:avenride/ui/mainScreen/FlightRideCard.dart';
import 'package:avenride/ui/mainScreen/food_card.dart';
import 'package:avenride/ui/mainScreen/mainScreenView.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:bottom_bar/bottom_bar.dart';

class StartUpView extends StatefulWidget {
  StartUpView({Key? key}) : super(key: key);

  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  final String logo = Assets.bgimg;
  final String logo1 = Assets.btnbgimg;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();

  // ignore: non_constant_identifier_names
  late LatLng SOURCE_LOCATION;

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  late FirebaseMessaging messaging;

  runstartup() async {}

  @override
  void initState() {
    super.initState();

    runstartup();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('######################## $value');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {});
  }

  Future<void> messageHandler(RemoteMessage message) async {
    final userService = locator<UserService>();
    final firestoreApi = locator<FirestoreApi>();
    List data = [];
    if (userService.currentUser.notification != null) {
      print('add available data to data');
      data = userService.currentUser.notification!;
      print('added the data $data');
    }
    print('background message ${message.notification!.body}');
    data.add({
      'data': message.data,
      'title': message.notification!.title == null
          ? ''
          : message.notification!.title,
      'body':
          message.notification!.body == null ? '' : message.notification!.body,
    });
    print('Updating user to update database $data');
    firestoreApi.updateRider(data: {
      'notification': data,
    }, user: userService.currentUser.id);
    print('Message clicked!');
    print(message);
    data = [];
  }

  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) async {
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          model.runStartupLogic();
        });
      },
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: BottomBar(
          backgroundColor: Colors.amber.shade200,
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.blue,
            ),
            BottomBarItem(
              title: Text('My Bookings'),
              icon: Icon(Icons.book),
              activeColor: Colors.greenAccent.shade700,
            ),
            BottomBarItem(
              icon: Icon(Icons.person),
              title: Text('My Profile'),
              activeColor: Colors.orange,
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: [
            screenfirst(model),
            BookingSubScreen(),
            ProfileSub(),
          ],
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
        ),
        key: _scaffoldKey,
        drawer: SafeArea(
          child: Container(
            width: screenWidth(context) / 1.8,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  model.userService.hasLoggedInUser && model.userId != null
                      ? StreamProvider<List<Users>>.value(
                          value: model.firestoreApi
                              .streamuser(model.userService.currentUser.id),
                          initialData: [
                            Users(
                              id: 'id',
                              email: 'email',
                              defaultAddress: 'defaultAddress',
                              name: 'name',
                              photourl:
                                  'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
                              personaldocs: 'personaldocs',
                              bankdocs: 'bankdocs',
                              vehicle: 'vehicle',
                              isBoat: false,
                              isVehicle: false,
                              vehicledocs: 'vehicledocs',
                              notification: [],
                            )
                          ],
                          builder: (context, child) {
                            var users = Provider.of<List<Users>>(context);
                            if (users.length == 0) {
                              return NotAvailable();
                            }
                            Users user = users.first;
                            return users.length == 0
                                ? NotAvailable()
                                : Container(
                                    color: appbg,
                                    child: Column(
                                      children: [
                                        verticalSpaceLarge,
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                          ),
                                          radius: 50,
                                        ),
                                        verticalSpaceMedium,
                                        Center(
                                          child: Text(
                                            user.name,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        verticalSpaceMedium,
                                      ],
                                    ),
                                  );
                          },
                        )
                      : SizedBox(),
                  DrawerItem(
                    title: 'Home',
                    icon: Icons.home,
                    onTapped: () => model.navigateToHome(),
                  ),
                  DrawerItem(
                    title: 'My Bookings',
                    icon: Icons.list,
                    onTapped: () => model.navigateToBooking(),
                  ),
                  DrawerItem(
                    title: 'My Profile',
                    icon: Icons.person,
                    onTapped: () => model.navigateToProfile(),
                  ),
                  DrawerItem(
                    title: 'Logout',
                    icon: Icons.login,
                    onTapped: model.logout,
                  ),
                ],
              ),
            ),
          ),
        ),
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          backgroundColor: appbg,
          leading: IconButton(
            icon: Icon(Icons.format_align_left_rounded),
            onPressed: _openDrawer,
          ),
          title: Container(
            height: 50,
            child: Image.asset(
              Assets.firebase,
              fit: BoxFit.scaleDown,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  model.navigateToNotification();
                },
                icon: Icon(Icons.notifications))
          ],
          centerTitle: true,
        ),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }

  Widget screenfirst(StartUpViewModel model) {
    return SnappingSheet(
      snappingPositions: [
        SnappingPosition.factor(
          positionFactor: 0.8,
          snappingCurve: Curves.bounceOut,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          positionFactor: 0.4,
          snappingCurve: Curves.bounceOut,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          positionFactor: 0.1,
          snappingCurve: Curves.elasticOut,
          snappingDuration: Duration(seconds: 1),
        ),
      ],
      initialSnappingPosition: SnappingPosition.pixels(
        positionPixels: 240,
        snappingCurve: Curves.elasticOut,
        snappingDuration: Duration(milliseconds: 1750),
      ),
      grabbingHeight: 40,
      grabbing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: model.status ? Colors.amber : Colors.green,
        ),
        child: Center(
          child: Container(
            height: 8,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.black,
            ),
          ),
        ),
      ),
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: Container(
          color: model.status ? Colors.amber : Colors.green,
          child: ListView(
            children: [
              !model.status ? BoatRideCard(model: model) : SizedBox(),
              model.status ? CarRideCard(model: model) : SizedBox(),
              FlightRideCard(
                model: model,
              ),
              FoodCard(
                model: model,
              ),
              // !model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToBoatRide(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Boat Ride',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
              // model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToCardRide(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Car Ride',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
              // model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToTaxiRide(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Bus/Taxi Ride',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
              // model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToAmbulanceRide(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Ambulance',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
              // !model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToDelivery(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Water Cargo',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
              // model.status
              //     ? Padding(
              //         padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              //         child: GestureDetector(
              //           onTap: () => model.navigateToDeliveryServices(),
              //           child: Card(
              //             elevation: 10,
              //             child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //               child: Center(
              //                 child: Text(
              //                   'Delivery Services',
              //                   style: TextStyle(
              //                     fontSize: 30,
              //                     backgroundColor: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : SizedBox(),
            ],
          ),
        ),
      ),
      child: SafeArea(
        child: DecoratedBox(
          decoration: new BoxDecoration(
            color: Colors.amber[50],
          ),
          child: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: model.initialLocation,
                      onMapCreated: onMapCreated,
                    ),
                    Positioned(
                      top: 40,
                      child: FlutterSwitch(
                        width: 125.0,
                        height: 45.0,
                        valueFontSize: 20.0,
                        value: model.status,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          model.setStatus(val);
                        },
                        toggleBorder: Border.all(color: Colors.black),
                        switchBorder: Border.all(color: Colors.black),
                        activeColor: Colors.amber,
                        activeText: 'Vehicel',
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.black,
                        inactiveText: 'Boat',
                        inactiveColor: Colors.green,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTapped;
  const DrawerItem(
      {required this.title, required this.icon, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapped,
      leading: Icon(
        icon,
        color: Colors.amber,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
