import 'package:avenride/main.dart';
import 'package:avenride/ui/car/car_selection_map/car_selection_map_viewmodel.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CarSelectionMapView extends StatelessWidget {
  CarSelectionMapView({Key? key, required this.start, required this.end})
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
    return ViewModelBuilder<CarSelectionMapViewModel>.reactive(
      onModelReady: (model) {
        MyStore store = VxState.store as MyStore;
        model.rideType = store.rideType;
        model.paymentMethod = store.paymentMethod;
        model.setSrcDest(store.carride['startLocation'],
            store.carride['destination'], store.carride['distace']);
        double storedprice = double.parse(store.carride['price']);
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
                              itemCount: carTypes.length,
                              itemBuilder: (context, index) {
                                NameIMG car = carTypes[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    color: model.selectedIndex == index
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                    child: ListTile(
                                      title: InkWell(
                                        onTap: () {
                                          model.setCar(car: car, index: index);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                    car.imagePath,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                horizontalSpaceTiny,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      car.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    Text(
                                                      'Increased Demand',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: screenWidth(context) / 2.3,
                                              child: Text(
                                                '₦${(model.storedprice - double.parse(car.price)).toString()} - ${(model.storedprice + double.parse(car.price)).toString()}',
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
                                        '₦1000 Already discounted on this trip',
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
                                            'Avenride cares about you dear esteem customer. Having you in mind, we have discounted this trip with ₦1000. Please have a safe trip.Avenride - we are near you',
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
      viewModelBuilder: () => CarSelectionMapViewModel(),
    );
  }
}

class CarTypesSelection extends StatefulWidget {
  const CarTypesSelection({Key? key}) : super(key: key);

  @override
  _CarTypesSelectionState createState() => _CarTypesSelectionState();
}

class _CarTypesSelectionState extends State<CarTypesSelection> {
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(carTypes[0].price);
  NameIMG selectedCar = NameIMG('AVR', Assets.car1, '100.0');

  @override
  Widget build(BuildContext context) {
    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price']);
    price = storedprice + sprice;

    return ListView.builder(
      itemCount: carTypes.length,
      itemBuilder: (context, index) {
        NameIMG car = carTypes[index];
        return InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
              sprice = double.parse(car.price);
              price = storedprice + sprice;
              selectedCar = car;
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
                        car.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      car.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${car.price}Nan',
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
