import 'dart:async';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/car_booking/car_booking_view.dart';
import 'package:avenride/ui/mainScreen/FlightRideCard.dart';
import 'package:avenride/ui/mainScreen/food_card.dart';
import 'package:avenride/ui/mainScreen/mainScreenView.dart';
import 'package:avenride/ui/profile/profile_view.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/back_map.dart';
import 'package:avenride/ui/startup/current_rides.dart';
import 'package:avenride/ui/startup/side_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  StartUpView({Key? key}) : super(key: key);
  final String logo = Assets.bgimg;
  final String logo1 = Assets.btnbgimg;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) async {
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
          await model.runStartupLogic();
          model.checkData(context);
        });
        FirebaseMessaging.onMessage
            .listen((RemoteMessage message) => model.messageHandler(message));
      },
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(model.index == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              label: 'Rides',
              icon: Icon(model.index == 1
                  ? Icons.local_taxi_sharp
                  : Icons.local_taxi_outlined),
            ),
            BottomNavigationBarItem(
              icon: Icon(model.index == 2
                  ? Icons.person
                  : Icons.person_add_alt_1_outlined),
              label: 'My Profile',
            ),
          ],
          currentIndex: model.index,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.amber[200],
          onTap: (value) {
            model.updateBottomNav(value);
          },
        ),
        body: model.index == 2
            ? ProfileSub()
            : model.index == 1
                ? BookingSubScreen()
                : screenfirst(model),
        key: _scaffoldKey,
        drawer: StartUpSideDraer(
          model: model,
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
      initialSnappingPosition: SnappingPosition.factor(
        positionFactor: 0.8,
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
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: model.navigateToCardRide,
                    title: Text(
                      'Where to?',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpaceSmall,
              CarRideCard(
                model: model,
              ),
              // BoatRideCard(
              //   model: model,
              // ),
              FlightRideCard(
                model: model,
              ),
              // FoodCard(
              //   model: model,
              // ),
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
                    BackMap(
                      onLocationChange: () {},
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
