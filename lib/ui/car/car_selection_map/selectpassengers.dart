import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectAmbulancePassengers extends StatefulWidget {
  SelectAmbulancePassengers({
    Key? key,
    required this.en,
    required this.st,
    required this.isDelivery,
  }) : super(key: key);
  final LatLng en, st;
  final bool isDelivery;
  @override
  _SelectAmbulancePassengersState createState() =>
      _SelectAmbulancePassengersState();
}

class _SelectAmbulancePassengersState extends State<SelectAmbulancePassengers> {
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
                    btnText == 'Complete form' ? Colors.red : Colors.amber,
                  ),
                ),
                onPressed: () {
                  if (widget.isDelivery) {
                    if (setLaguageSize != '' || setLaguageType != '') {
                      store.carride['laguageType'] = setLaguageType;
                      store.carride['laguageSize'] = setLaguageSize;
                      navigationService.replaceWith(
                        Routes.confirmPickUpView,
                        arguments: ConfirmPickUpViewArguments(
                          end: widget.en,
                          start: widget.st,
                          bookingtype: GetBookinType().perform(),
                        ),
                      );
                    } else {
                      setState(() {
                        btnText = 'Complete form';
                      });
                    }
                  } else {
                    store.carride['price'] = price;
                    navigationService.replaceWith(
                      Routes.confirmPickUpView,
                      arguments: ConfirmPickUpViewArguments(
                        end: widget.en,
                        start: widget.st,
                        bookingtype: GetBookinType().perform(),
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
          widget.isDelivery
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
          widget.isDelivery
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
          !widget.isDelivery
              ? Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Patients',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.amberAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Total - $price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
