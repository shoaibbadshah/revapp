import 'package:avenride/main.dart';
import 'package:avenride/ui/boat/boatsearchingdriver/boat_seacrhdriver_viewmodel.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class BoatSearchDriverView extends StatelessWidget {
  BoatSearchDriverView({Key? key, required this.start, required this.end})
      : super(key: key);
  final LatLng start, end;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoatSearchDriverViewModel>.reactive(
      onModelReady: (model) {
        MyStore store = VxState.store as MyStore;
        model.setSrcDest(store.carride['pickLocation'],
            store.carride['dropLocation'], '100');
      },
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SnappingSheet(
            snappingPositions: [
              SnappingPosition.factor(
                positionFactor: 0.8,
                snappingCurve: Curves.bounceOut,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
              SnappingPosition.factor(
                positionFactor: 0.5,
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
            ],
            initialSnappingPosition: SnappingPosition.factor(
              positionFactor: 0.4,
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1750),
            ),
            grabbingHeight: 60,
            grabbing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                  children: [
                    verticalSpaceRegular,
                    Container(
                      width: 40,
                      color: Colors.blueGrey,
                      height: 5,
                    ),
                    verticalSpaceTiny,
                    Center(
                      child: Text(
                        model.isDriver
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
            ),
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      model.isDriver
                          ? Container(
                              width: screenWidth(context),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Gray',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                horizontalSpaceTiny,
                                                Center(
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                                horizontalSpaceTiny,
                                                Text(
                                                  'Toyota Corolla',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'BDG 960 FU',
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
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(0.5),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image.network(
                                                  'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Your driver is Dada',
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
                                    'Your otp is 123456',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  verticalSpaceRegular,
                                  Text(
                                    'Cash',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  verticalSpaceRegular,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          UrlLauncher.launch(
                                              "tel://+918082050623");
                                        },
                                        child: Column(
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
                                              Icons.cancel_presentation_rounded,
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
                              ),
                            )
                          : Container(
                              width: screenWidth(context),
                              child: Column(
                                children: [
                                  AvatarGlow(
                                    glowColor: Colors.green,
                                    endRadius: 90.0,
                                    duration: Duration(milliseconds: 2000),
                                    repeat: true,
                                    repeatPauseDuration:
                                        Duration(milliseconds: 100),
                                    child: Text(''),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      model.changeStatus();
                                    },
                                    child: Text('data'),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
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
                  : Stack(
                      children: [
                        Container(
                          height: screenHeight(context) / 1.4,
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
            ),
          ),
        ),
      ),
      viewModelBuilder: () => BoatSearchDriverViewModel(),
    );
  }
}
