import 'package:avenride/main.dart';
import 'package:avenride/ui/car/confirmpickup/confirmpickup_viewmodel.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ConfirmPickUpView extends StatelessWidget {
  ConfirmPickUpView({
    Key? key,
    required this.bookingtype,
    required this.start,
    required this.end,
  }) : super(key: key);
  final String bookingtype;
  final LatLng start, end;

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    final key1 = GlobalKey<State<Tooltip>>();
    return ViewModelBuilder<ConfirmPickUpViewModel>.reactive(
      onModelReady: (model) {
        model.bookingType = bookingtype;
        MyStore store = VxState.store as MyStore;
        model.rideType = store.rideType;
        model.paymentMethod = store.paymentMethod;
        model.setSrcDest(store.carride['startLocation'],
            store.carride['destination'], store.carride['distace']);
        double storedprice = store.carride['price'];
        model.setInitialPrice(storedprice);
        model.submitBtnText = 'AVR (total: ${storedprice + 100})';
      },
      builder: (context, model, child) => Scaffold(
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      model.navigateToPayment();
                    },
                    child: Container(
                      width: screenWidth(context) / 1.6,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.rideType,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(model.paymentMethod),
                            ],
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  Tooltip(
                    key: key1,
                    preferBelow: false,
                    margin: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    message:
                        'Dear esteem customer. You are guaranteed Multi - Payments options by selecting best payment method of your choice. Avenride we are near you',
                    child: IconButton(
                      onPressed: () => _onTap(key1),
                      icon: Icon(
                        Icons.info,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth(context) / 1.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        model.onConfirmOrder(context, start, end);
                      },
                      child: Text('Confirm your Order'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      model.setTiemDate();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.black,
                      child: Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
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
                    children: [
                      Container(
                        height: screenHeight(context) / 2,
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
                      SlidingSheet(
                        elevation: 8,
                        cornerRadius: 16,
                        snapSpec: SnapSpec(
                          snap: true,
                          snappings: [
                            screenHeight(context) / 2.1,
                            screenHeight(context) / 0.1,
                          ],
                          positioning: SnapPositioning.pixelOffset,
                        ),
                        builder: (context, state) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            height: 350,
                            child: Card(
                              elevation: 5,
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
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
                                                color: Colors.greenAccent,
                                              ),
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
                                          Row(
                                            children: [
                                              Container(
                                                width:
                                                    screenWidth(context) / 1.7,
                                                height: 40,
                                                child: Text(
                                                  model.pickUpAddess,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  model.navigateToMapPicker(
                                                      true);
                                                },
                                                icon: Icon(Icons.edit),
                                              ),
                                            ],
                                          ),
                                          verticalSpaceSmall,
                                          Container(
                                            height: 2.0,
                                            padding: EdgeInsets.all(0),
                                            width: screenWidth(context) / 1.9,
                                            color: Colors.grey.shade300,
                                            margin: EdgeInsets.only(right: 20),
                                          ),
                                          verticalSpaceSmall,
                                          Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width:
                                                    screenWidth(context) / 1.7,
                                                child: Text(
                                                  model.dropOffAddress,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  model.navigateToMapPicker(
                                                      false);
                                                },
                                                icon: Icon(Icons.edit),
                                              ),
                                            ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            model.distance,
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
                                                model.scheduleTime
                                                    .toLowerCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                model.scheduledDate
                                                    .toLowerCase(),
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
                                              model.price.toString(),
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
                                  // Card(
                                  //   elevation: 5,
                                  //   child: Row(
                                  //     children: [
                                  //       Container(
                                  //         margin: EdgeInsets.symmetric(
                                  //           horizontal: 20,
                                  //         ),
                                  //         width: screenWidth(context) / 1.4,
                                  //         child: Text(model.pickUpAddess),
                                  //       ),
                                  //       IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(Icons.edit),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // verticalSpaceSmall,
                                  // Card(
                                  //   elevation: 5,
                                  //   child: Row(
                                  //     children: [
                                  //       Container(
                                  //         margin: EdgeInsets.symmetric(
                                  //           horizontal: 20,
                                  //         ),
                                  //         width: screenWidth(context) / 1.4,
                                  //         child: Text(model.dropOffAddress),
                                  //       ),
                                  //       IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(Icons.edit),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Card(
                                  //   elevation: 5,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Row(
                                  //         children: [
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //               horizontal: 20,
                                  //             ),
                                  //             child: Text('Ride Type:'),
                                  //           ),
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //               horizontal: 20,
                                  //             ),
                                  //             child: Text(model.rideType),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(Icons.edit),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Card(
                                  //   elevation: 5,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Row(
                                  //         children: [
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //               horizontal: 20,
                                  //             ),
                                  //             child: Text('Payment Method:'),
                                  //           ),
                                  //           Container(
                                  //             margin: EdgeInsets.symmetric(
                                  //               horizontal: 20,
                                  //             ),
                                  //             child: Text(model.paymentMethod),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(Icons.edit),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                        headerBuilder: (context, state) {
                          return Container(
                            height: 50,
                            child: Column(
                              children: [
                                verticalSpaceTiny,
                                Center(
                                  child: Text(
                                    'Summary of Ride',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                verticalSpaceTiny,
                                Container(
                                  width: 40,
                                  color: Colors.grey,
                                  height: 4,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => ConfirmPickUpViewModel(),
    );
  }
}
