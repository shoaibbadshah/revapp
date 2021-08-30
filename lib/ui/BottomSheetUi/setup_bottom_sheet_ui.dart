import 'dart:convert';
import 'dart:ui';
import 'dart:io';

import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/ui/BottomSheetUi/ambulance_extra_service.dart';
import 'package:avenride/ui/BottomSheetUi/permission_checker.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.payment: (context, sheetRequest, completer) =>
        Pay(request: sheetRequest, completer: completer),
    BottomSheetType.boattype: (context, sheetRequest, completer) =>
        BoatType(request: sheetRequest, completer: completer),
    BottomSheetType.cargotype: (context, sheetRequest, completer) =>
        CargoType(request: sheetRequest, completer: completer),
    BottomSheetType.deliverytype: (context, sheetRequest, completer) =>
        DeliveryServicesType(request: sheetRequest, completer: completer),
    BottomSheetType.ambulance: (context, sheetRequest, completer) =>
        AmbulanceExtraService(request: sheetRequest, completer: completer),
    BottomSheetType.ambulanceemergency: (context, sheetRequest, completer) =>
        AmbulanceEmergency(request: sheetRequest, completer: completer),
    BottomSheetType.permissionchecker: (context, sheetRequest, completer) =>
        PermissionChecker(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class FloatingBoxBottomSheet extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  FloatingBoxBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _FloatingBoxBottomSheetState createState() => _FloatingBoxBottomSheetState();
}

class _FloatingBoxBottomSheetState extends State<FloatingBoxBottomSheet> {
  final _userService = locator<UserService>();
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
    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request!.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
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
                            : Colors.transparent,
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
                        )
                        //  ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       selectedIndex = index;
                        //     });
                        //   },
                        //   leading: Text(
                        //     carTypes[index],
                        //   ),
                        //   title: Container(
                        //     width: 30,
                        //     height: 50,
                        //     child: Image.asset(
                        //       Assets.bananaBoat,
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),

                        // ),
                        ),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Total - $price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            verticalSpaceRegular,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_userService.hasLoggedInUser) {
                      setState(() {
                        fp = price.toString();
                        isbusy = true;
                      });
                      Increment({
                        'CarType': selectedCar.name,
                        'price': fp,
                      });
                      print(store.carride);
                      widget.completer!(
                          SheetResponse(confirmed: true, data: price));
                    }
                  },
                  child: isbusy
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Text(
                          widget.request!.mainButtonTitle!,
                          style: TextStyle(color: Colors.black),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Pay extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const Pay({Key? key, this.request, this.completer}) : super(key: key);
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  MyStore store = VxState.store as MyStore;
  final _userService = locator<UserService>();
  int selectedIndex = 0;
  bool isbusy = false;
  String _chosenValue = 'Cash';
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request!.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Total - ${store.carride['price']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment type:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                verticalSpaceRegular,
                Container(
                  color: Colors.amberAccent,
                  padding: const EdgeInsets.only(left: 5),
                  child: DropdownButton<String>(
                    value: _chosenValue,
                    elevation: 5,
                    style: TextStyle(color: Colors.black),
                    items: <String>[
                      'Cash',
                      'Online Banking',
                      'Credit Card',
                      'Debit Card'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenValue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_userService.hasLoggedInUser) {
                      setState(() {
                        isbusy = true;
                      });
                      Increment({
                        'PaymentType': _chosenValue,
                      });

                      widget.completer!(
                          SheetResponse(confirmed: true, data: 'ho gya'));
                    }
                  },
                  child: isbusy
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Text(
                          widget.request!.mainButtonTitle!,
                          style: TextStyle(color: Colors.black),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Payweb extends StatefulWidget {
  final String payurl;
  final String ref;
  final String docid;
  final String payfor;
  const Payweb(
      {Key? key,
      required this.payurl,
      required this.ref,
      required this.docid,
      required this.payfor})
      : super(key: key);
  @override
  _PaywebState createState() => _PaywebState();
}

class _PaywebState extends State<Payweb> {
  final _navigationService = locator<NavigationService>();
  MyStore store = VxState.store as MyStore;
  final _firestoreApi = locator<FirestoreApi>();
  final _userService = locator<UserService>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: widget.payurl,
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'Flutter;Webview',
          navigationDelegate: (navigation) async {
            if (navigation.url.contains("https://standard.paystack.co/close")) {
              bool istrue = await verifyTransaction(navigation.url);
              if (istrue) {
                _navigationService.back();
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  Future<bool> verifyTransaction(String url) async {
    print(url);
    final str = url;
    final start = 'trxref=';
    final end = '&';
    final start1 = 'reference=';
    final startIndex = str.indexOf(start);
    final startIndex1 = str.indexOf(start1);
    final endIndex = str.indexOf(end);
    final trxref = str.substring(startIndex + start.length, endIndex).trim();
    final ref = str.substring(startIndex1 + start1.length).trim();
    print(trxref);
    print(ref);
    final response = await http.post(
        Uri.parse(
            'https://us-central1-unique-nuance-310113.cloudfunctions.net/verifyPayment'),
        body: {"ref": widget.ref});

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      if (data['status']) {
        if (widget.payfor == 'taxi') {
          _firestoreApi.updateTaxiPaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        if (widget.payfor == 'car') {
          _firestoreApi.updateCarPaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        if (widget.payfor == 'ambulance') {
          _firestoreApi.updateAmbulancePaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        if (widget.payfor == 'boat') {
          _firestoreApi.updateBoatPaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        if (widget.payfor == 'delivery') {
          _firestoreApi.updateDeliveryPaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        if (widget.payfor == 'deliveryservices') {
          _firestoreApi.updateDeliveryServicesPaymentInfo(data: {
            'paymentStatus': Confirmed,
            'paymentDetails': {
              'transactionId': data['data']['id'],
              'reference': data['data']['reference'],
            },
          }, user: _userService.currentUser, docId: widget.docid);
        }
        return true;
      }
    } else {
      throw Exception('Failed to load album');
    }
    return false;
  }
}

class BoatType extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  BoatType({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _BoatTypeState createState() => _BoatTypeState();
}

class _BoatTypeState extends State<BoatType> {
  int selectedIndex = 0;
  bool isbusy = false;
  NameIMG selectedBoat = NameIMG('AV Boat 75', Assets.boat1, '200.0');

  double price = 0.0;
  String fp = '';
  double sprice = double.parse(boatTypes[0].price);
  @override
  Widget build(BuildContext context) {
    final _userService = locator<UserService>();
    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price']);
    price = storedprice + sprice;
    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request!.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: boatTypes.length,
                itemBuilder: (context, index) {
                  NameIMG boat = boatTypes[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedBoat = boat;
                        sprice = double.parse(boat.price);
                        price = storedprice + sprice;
                        print(price);
                      });
                    },
                    child: Container(
                        color: (selectedIndex == index)
                            ? Colors.amber.withOpacity(0.5)
                            : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                horizontalSpaceTiny,
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
                        )
                        //  ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       selectedIndex = index;
                        //     });
                        //   },
                        //   title: Text(boat.name),
                        // ),
                        ),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Total - $price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_userService.hasLoggedInUser) {
                      setState(() {
                        fp = price.toString();
                        isbusy = true;
                      });
                      Increment({
                        'BoatType': selectedBoat.name,
                        'price': fp,
                      });
                      print(store.carride);
                      widget.completer!(SheetResponse(confirmed: true));
                    }
                  },
                  child: isbusy
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Text(
                          widget.request!.mainButtonTitle!,
                          style: TextStyle(color: Colors.black),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CargoType extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  CargoType({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _CargoTypeState createState() => _CargoTypeState();
}

class _CargoTypeState extends State<CargoType> {
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(cargoboatTypes[0].price);
  NameIMG selectedCargo = NameIMG('AV Cargo Eko 75', Assets.cargo5, '100.0');
  @override
  Widget build(BuildContext context) {
    final _userService = locator<UserService>();

    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price']);
    price = storedprice + sprice;

    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request!.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: cargoboatTypes.length,
                itemBuilder: (context, index) {
                  NameIMG cargoboat = cargoboatTypes[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        sprice = double.parse(cargoboat.price);
                        price = storedprice + sprice;
                        selectedCargo = cargoboat;
                        print(price);
                      });
                    },
                    child: Container(
                        color: (selectedIndex == index)
                            ? Colors.amber.withOpacity(0.5)
                            : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                horizontalSpaceTiny,
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    cargoboat.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  cargoboat.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '${cargoboat.price} Nan',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        // ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       selectedIndex = index;
                        //     });
                        //   },
                        //   title: Text(cargoboat.name),
                        // ),
                        ),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Total - $price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_userService.hasLoggedInUser) {
                      setState(() {
                        fp = price.toString();
                        isbusy = true;
                      });
                      Increment({
                        'cargoboatType': selectedCargo.name,
                        'price': fp,
                      });
                      print(store.carride);
                      widget.completer!(SheetResponse(confirmed: true));
                    }
                  },
                  child: isbusy
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Text(
                          widget.request!.mainButtonTitle!,
                          style: TextStyle(color: Colors.black),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryServicesType extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  DeliveryServicesType({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _DeliveryServicesTypeState createState() => _DeliveryServicesTypeState();
}

class _DeliveryServicesTypeState extends State<DeliveryServicesType> {
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  double sprice = double.parse(deliveryTypes[0].price);
  NameIMG selected = NameIMG('Motorcycle', Assets.ride1, '200.0');
  @override
  Widget build(BuildContext context) {
    final _userService = locator<UserService>();

    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price']);
    price = storedprice + sprice;
    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request!.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: deliveryTypes.length,
                itemBuilder: (context, index) {
                  NameIMG ride = deliveryTypes[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        sprice = double.parse(ride.price);
                        price = storedprice + sprice;
                        selected = ride;
                        print(price);
                      });
                    },
                    child: Container(
                        color: (selectedIndex == index)
                            ? Colors.amber.withOpacity(0.5)
                            : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                horizontalSpaceTiny,
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    ride.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  ride.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '${ride.price}Nan',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        // ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       selectedIndex = index;
                        //     });
                        //   },
                        //   title: Text(deliveryTypes[index]),
                        // ),
                        ),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                color: Colors.amberAccent,
                padding: EdgeInsets.all(5),
                child: Text(
                  'Total - $price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () async {
                    if (_userService.hasLoggedInUser) {
                      setState(() {
                        isbusy = true;
                      });
                      Increment({
                        'deliveryType': selected.name,
                        'price': price.toString(),
                      });
                      print(store.carride);
                      widget.completer!(SheetResponse(confirmed: true));
                    }
                  },
                  child: isbusy
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Text(
                          widget.request!.mainButtonTitle!,
                          style: TextStyle(color: Colors.black),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
