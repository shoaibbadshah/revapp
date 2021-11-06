import 'dart:ui';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/material.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class AmbulanceExtraService extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  AmbulanceExtraService({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _AmbulanceExtraServiceState createState() => _AmbulanceExtraServiceState();
}

class _AmbulanceExtraServiceState extends State<AmbulanceExtraService> {
  int selectedIndex = 0;
  bool isbusy = false;
  double price = 0.0;
  String fp = '';
  num nurse = 0, oxy = 0, doctor = 0;
  double st = 0.0;
  double ox = 0.0;
  double pd = 0.0;
  @override
  Widget build(BuildContext context) {
    final _userService = locator<UserService>();

    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price'].toString());
    price = st + storedprice + ox + pd;
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
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'X $nurse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Text(
                        'Nurse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                nurse = nurse + 1;
                                double a = nurse * 100;
                                st = a;
                              });
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.amberAccent,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          nurse != 0
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      nurse = nurse - 1;
                                      st = st - 100;
                                    });
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'X $oxy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Text(
                        'Oxygen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                oxy = oxy + 1;
                                double a = oxy * 200;
                                ox = a;
                              });
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.amberAccent,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          oxy != 0
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      oxy = oxy - 1;
                                      ox = ox - 200;
                                    });
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'X $doctor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Text(
                        'Professional Doctor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                doctor = doctor + 1;
                                double a = doctor * 300;
                                pd = a;
                              });
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.amberAccent,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          doctor != 0
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      doctor = doctor - 1;
                                      pd = pd - 300;
                                    });
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ],
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

class AmbulanceEmergency extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  AmbulanceEmergency({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _AmbulanceEmergencyState createState() => _AmbulanceEmergencyState();
}

class _AmbulanceEmergencyState extends State<AmbulanceEmergency> {
  int selectedIndex = 0;
  bool isbusy = false, sts = false;
  double price = 0.0;
  String fp = '';
  bool fse = false,
      pie = false,
      cas = false,
      le = false,
      sa = false,
      aae = false;
  @override
  Widget build(BuildContext context) {
    final _userService = locator<UserService>();

    MyStore store = VxState.store as MyStore;
    double storedprice = double.parse(store.carride['price'].toString());
    price = storedprice;
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
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  AddSection(
                    val: 0,
                    name: 'Fire Service Emergency',
                    price: 100,
                    status: (val) {
                      setState(() {
                        print(val);
                        fse = val;
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  AddSection(
                    val: 0,
                    name: 'Physical Injury Emergency ',
                    price: 200,
                    status: (val) {
                      setState(() {
                        print(val);
                        pie = val;
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  AddSection(
                    val: 0,
                    name: 'Cardiac Arrest / Stroke ',
                    price: 300,
                    status: (val) {
                      setState(() {
                        print(val);
                        cas = val;
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  AddSection(
                    val: 0,
                    name: 'Lifeboat Emergency',
                    price: 400,
                    status: (val) {
                      setState(() {
                        print(val);
                        le = val;
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  AddSection(
                    val: 0,
                    name: 'Suicidal Attempts',
                    price: 400,
                    status: (val) {
                      setState(() {
                        print(val);
                        sa = val;
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  AddSection(
                    val: 0,
                    name: 'Automobile Accident Emergency',
                    price: 400,
                    status: (val) {
                      setState(() {
                        print(val);
                        aae = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.amberAccent,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Total - $price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
                ElevatedButton(
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
                        "price": price.toString(),
                        "fse": fse,
                        "pie": pie,
                        "cas": cas,
                        "le": le,
                        "sa": sa,
                        "aae": aae,
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

// ignore: must_be_immutable
class AddSection extends StatefulWidget {
  num val = 0;
  double price = 0;
  final String name;
  Function status;
  AddSection({
    Key? key,
    required this.val,
    required this.name,
    required this.price,
    required this.status,
  }) : super(key: key);

  @override
  _AddSectionState createState() => _AddSectionState();
}

class _AddSectionState extends State<AddSection> {
  double st = 0.0;
  bool sts = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 170,
          child: Text(
            widget.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
          ),
        ),
        FlutterSwitch(
          width: 100.0,
          valueFontSize: 18.0,
          value: sts,
          padding: 8.0,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              sts = !sts;
            });
            widget.status(sts);
          },
          toggleBorder: Border.all(color: Colors.black),
          switchBorder: Border.all(color: Colors.black),
          activeColor: Colors.amber,
          activeText: 'Yes',
          activeTextColor: Colors.black,
          inactiveTextColor: Colors.black,
          inactiveText: 'No',
          inactiveColor: Colors.green,
        ),
      ],
    );
  }
}
