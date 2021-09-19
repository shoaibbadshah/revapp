import 'package:avenride/main.dart';
import 'package:avenride/ui/car_selection_map/car_selection_map_viewmodel.dart';
import 'package:avenride/ui/pointmap/bookingMap.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CarSelectionMapView extends StatelessWidget {
  CarSelectionMapView({Key? key, required this.start, required this.end})
      : super(key: key);

  final LatLng start, end;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CarSelectionMapViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.black,
                width: 4,
              ),
            ),
          ),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth(context) / 1.4,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Continue'),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                color: Colors.black,
                child: Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        body: SnappingSheet(
          snappingPositions: [
            SnappingPosition.factor(
              positionFactor: 0.8,
              snappingCurve: Curves.bounceOut,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.bottom,
            ),
            SnappingPosition.factor(
              positionFactor: 0.47,
              snappingCurve: Curves.bounceOut,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.bottom,
            ),
          ],
          initialSnappingPosition: SnappingPosition.factor(
            positionFactor: 0.8,
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
          ),
          grabbingHeight: 20,
          grabbing: Container(
            color: Colors.amber.shade300,
            child: Center(
              child: Container(
                height: 5,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Colors.black45,
                ),
              ),
            ),
          ),
          sheetBelow: SnappingSheetContent(
            draggable: true,
            child: Container(
              color: Colors.amber,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: carTypes.length,
                itemBuilder: (context, index) {
                  NameIMG car = carTypes[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: InkWell(
                          onTap: () {
                            // setState(() {
                            //   selectedIndex = index;
                            //   sprice = double.parse(car.price);
                            //   price = storedprice + sprice;
                            //   selectedCar = car;
                            //   print(price);
                            // });
                          },
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                      ),
                    ),
                  );
                },
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
                      children: [
                        Container(
                          height: screenHeight(context) / 2,
                          child: BookingMap(
                            DEST_LOCATION: end,
                            SOURCE_LOCATION: start,
                          ),
                        ),
                      ],
                    ),
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
