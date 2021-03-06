import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/boat/boat_selection_map/boat_selection_map_viewmodel.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class BoatSelectionMapView extends StatelessWidget {
  BoatSelectionMapView({Key? key, required this.start, required this.end})
      : super(key: key);

  final LatLng start, end;
  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    final key1 = GlobalKey<State<Tooltip>>();
    return ViewModelBuilder<BoatSelectionMapViewModel>.reactive(
      onModelReady: (model) {
        MyStore store = VxState.store as MyStore;
        model.rideType = store.rideType;
        model.paymentMethod = store.paymentMethod;
        model.setSrcDest(store.carride['pickLocation'],
            store.carride['dropLocation'], '100');
        double storedprice = double.parse(store.carride['price']);
        model.setInitialPrice(storedprice);
        model.submitBtnText = store.rideType == BoatRidetype
            ? 'AV Boat 75 (total: ${storedprice + 100})'
            : 'AV Cargo Eko 75 (total: ${storedprice + 100})';
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
                      onPressed: () {
                        model.onConfirmPressed(start, end);
                      },
                      child: Text('Confirm ${model.submitBtnText}'),
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
                            screenHeight(context) / 1.7,
                            screenHeight(context) / 0.1,
                          ],
                          positioning: SnapPositioning.pixelOffset,
                        ),
                        builder: (context, state) {
                          return Container(
                            height: 500,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            color: Colors.white,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.store.bookingType == BoatRidetype
                                  ? boatTypes.length
                                  : cargoboatTypes.length,
                              itemBuilder: (context, index) {
                                NameIMG boat =
                                    model.store.bookingType == BoatRidetype
                                        ? boatTypes[index]
                                        : cargoboatTypes[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    color: model.selectedIndex == index
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                    child: ListTile(
                                      title: InkWell(
                                        onTap: () {
                                          model.setCar(car: boat, index: index);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                    boat.imagePath,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                horizontalSpaceTiny,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: Text(
                                                        boat.name,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '7 mins',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        horizontalSpaceTiny,
                                                        Icon(
                                                          Icons.person,
                                                          size: 12,
                                                        ),
                                                        Text(
                                                          '4 seats',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Text(
                                                    //   'Increased Demand',
                                                    //   style: TextStyle(
                                                    //     fontSize: 12,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: screenWidth(context) / 2.3,
                                              child: Text(
                                                '???${(model.storedprice - double.parse(boat.price)).toString()} - ${(model.storedprice + double.parse(boat.price)).toString()}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        headerBuilder: (context, state) {
                          return Container(
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  color: Colors.blue,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '???1000 Already discounted on this trip',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Tooltip(
                                        key: key,
                                        preferBelow: false,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        message:
                                            'Avenride cares about you dear esteem customer. Having you in mind, we have discounted this trip with ???1000. Please have a safe trip.Avenride - we are near you',
                                        child: IconButton(
                                          onPressed: () => _onTap(key),
                                          icon: Icon(
                                            Icons.info,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  color: Colors.blue,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    height: 30,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        verticalSpaceTiny,
                                        Container(
                                          width: 40,
                                          color: Colors.grey,
                                          height: 4,
                                        ),
                                        verticalSpaceTiny,
                                        Text(
                                          'swipe up to see more!',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
      viewModelBuilder: () => BoatSelectionMapViewModel(),
    );
  }
}

class BoatTypesSelection extends StatefulWidget {
  BoatTypesSelection({Key? key}) : super(key: key);

  @override
  _BoatTypesSelectionState createState() => _BoatTypesSelectionState();
}

class _BoatTypesSelectionState extends State<BoatTypesSelection> {
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(carTypes[0].price);
  NameIMG selectedBoat = NameIMG('AV Boat 75', Assets.boat1, '200.0');

  @override
  Widget build(BuildContext context) {
    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price']);
    price = storedprice + sprice;

    return ListView.builder(
      itemCount: boatTypes.length,
      itemBuilder: (context, index) {
        NameIMG boat = boatTypes[index];
        return InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
              sprice = double.parse(boat.price);
              price = storedprice + sprice;
              selectedBoat = boat;
              print(price);
            });
          },
          child: Container(
            color: (selectedIndex == index)
                ? Colors.amber.withOpacity(0.5)
                : Colors.white,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        boat.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      boat.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${boat.price}Nan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectPassengers extends StatefulWidget {
  SelectPassengers({
    Key? key,
    required this.en,
    required this.isCargo,
    required this.st,
  }) : super(key: key);
  final LatLng en, st;
  final bool isCargo;
  @override
  _SelectPassengersState createState() => _SelectPassengersState();
}

class _SelectPassengersState extends State<SelectPassengers> {
  final navigationService = locator<NavigationService>();
  int index = 1;
  MyStore store = VxState.store as MyStore;
  double price = 0;
  String setLaguageType = '', setLaguageSize = '';
  @override
  void initState() {
    price = store.carride["price"];
    super.initState();
  }

  String btnText = 'Confirm';
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
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: screenWidth(context) / 1.4,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      btnText == 'Complete form' ? Colors.red : Colors.amber),
                ),
                onPressed: () {
                  if (widget.isCargo) {
                    if (setLaguageSize != '' || setLaguageType != '') {
                      store.carride['laguageType'] = setLaguageType;
                      store.carride['laguageSize'] = setLaguageSize;
                      print(store.carride);
                      navigationService.replaceWith(
                        Routes.boatConfirmPickUpView,
                        arguments: BoatConfirmPickUpViewArguments(
                          end: widget.en,
                          start: widget.st,
                        ),
                      );
                    } else {
                      setState(() {
                        btnText = 'Complete form';
                      });
                    }
                  } else {
                    store.carride['price'] = price;
                    print(store.carride);
                    navigationService.replaceWith(
                      Routes.boatConfirmPickUpView,
                      arguments: BoatConfirmPickUpViewArguments(
                        end: widget.en,
                        start: widget.st,
                      ),
                    );
                  }
                },
                child: Text(btnText),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          verticalSpaceMedium,
          widget.isCargo
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Laguage type:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  setLaguageType = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.all(5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          widget.isCargo
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Laguage size:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      setLaguageSize = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.all(5)),
                                ),
                              ),
                              Text(
                                'Kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          !widget.isCargo
              ? Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Passengers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (index > 1) {
                                  setState(() {
                                    index = index - 1;
                                    price = price - 100;
                                  });
                                }
                              },
                              icon: Icon(Icons.cancel_outlined),
                            ),
                            Text('$index'),
                            IconButton(
                              onPressed: () {
                                if (index < 5) {
                                  setState(() {
                                    index = index + 1;
                                    price = price + 100;
                                  });
                                }
                              },
                              icon: Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Total - $price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
