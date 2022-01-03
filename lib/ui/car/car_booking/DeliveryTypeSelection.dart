import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/main.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/car/car_selection_map/car_selection_map_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryTypeSelection extends StatefulWidget {
  DeliveryTypeSelection({
    Key? key,
    required this.en,
    required this.st,
  }) : super(key: key);
  final LatLng en, st;
  @override
  _DeliveryTypeSelectionState createState() => _DeliveryTypeSelectionState();
}

class _DeliveryTypeSelectionState extends State<DeliveryTypeSelection> {
  final navigationService = locator<NavigationService>();
  int index = 1, _selectdeIndex = -1, _selectedSecondIndex = -1;
  MyStore store = VxState.store as MyStore;
  double price = 0;
  double sprice = 0;
  String setLaguageType = '', setLaguageSize = '';
  @override
  void initState() {
    price = double.parse(store.carride["price"]);
    sprice = double.parse(store.carride["price"]);
    super.initState();
  }

  List<Item> _items = [
    generateItems(headerText: 'Food & Groceries'),
    generateItems(headerText: 'House Hold Items'),
    generateItems(headerText: 'Heavy Duty Items'),
  ];
  List fg = [
    "Pizza",
    "Ckicken & Rice",
  ];
  List hhi = [
    "Electronic",
    "Furniture",
  ];
  final _userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.amberAccent,
                    child: Text(
                      'Total - $sprice',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
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
                      if (_selectdeIndex != -1 || _selectedSecondIndex != -1) {
                        store.carride['price'] = price.toString();
                        store.carride['laguageType'] = setLaguageType;
                        store.carride['laguageSize'] = setLaguageSize;
                        navigationService.navigateToView(CarSelectionMapView(
                          bookingtype: GetBookinType().perform(),
                          end: widget.en,
                          start: widget.st,
                        ));
                      } else {
                        setState(() {
                          btnText = 'Complete form';
                        });
                      }
                    },
                    child: Text(btnText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          verticalSpaceMedium,
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _items[index].isExpanded = !isExpanded;
                  });
                },
                children: _items.map<ExpansionPanel>(
                  (Item item) {
                    return ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            item.headerValue,
                            style: ktsMediumGreyBodyText,
                          ),
                        );
                      },
                      body: item.headerValue == 'Food & Groceries'
                          ? Container(
                              height: 140,
                              child: ListView.builder(
                                itemCount: fg.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: _selectdeIndex == index
                                        ? Colors.grey
                                        : Colors.white,
                                    elevation: 5,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          _selectedSecondIndex = -1;
                                          _selectdeIndex = index;
                                          sprice = price + 150;
                                          setLaguageSize = "5kg";
                                          setLaguageType = fg[index];
                                        });
                                      },
                                      title: Text(fg[index]),
                                    ),
                                  );
                                },
                              ),
                            )
                          : item.headerValue == "House Hold Items"
                              ? Container(
                                  height: 140,
                                  child: ListView.builder(
                                    itemCount: hhi.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: _selectedSecondIndex == index
                                            ? Colors.grey
                                            : Colors.white,
                                        elevation: 5,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            setState(() {
                                              _selectdeIndex = -1;
                                              _selectedSecondIndex = index;
                                              sprice = price + 1000;
                                              setLaguageSize = "20kg";
                                              setLaguageType = hhi[index];
                                            });
                                          },
                                          title: Text(hhi[index]),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListTile(
                                    title: Text(item.expandedValue),
                                  ),
                                ),
                      isExpanded: item.isExpanded,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
          //   child: Card(
          //     elevation: 5,
          //     child: Padding(
          //       padding: EdgeInsets.all(20.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Text(
          //             'Laguage type:',
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           Container(
          //             width: 100,
          //             height: 40,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(color: Colors.grey[200]),
          //             child: TextFormField(
          //               textAlign: TextAlign.center,
          //               onChanged: (value) {
          //                 setState(() {
          //                   setLaguageType = value;
          //                 });
          //               },
          //               keyboardType: TextInputType.text,
          //               decoration: InputDecoration(
          //                   disabledBorder: UnderlineInputBorder(
          //                       borderSide: BorderSide.none),
          //                   // labelText: 'Time',
          //                   contentPadding: EdgeInsets.all(5)),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
          //   child: Card(
          //     elevation: 5,
          //     child: Padding(
          //       padding: EdgeInsets.all(20.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Text(
          //             'Laguage size:',
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           Row(
          //             children: [
          //               Container(
          //                 width: 100,
          //                 height: 40,
          //                 alignment: Alignment.center,
          //                 decoration: BoxDecoration(color: Colors.grey[200]),
          //                 child: TextFormField(
          //                   textAlign: TextAlign.center,
          //                   onChanged: (value) {
          //                     setState(() {
          //                       setLaguageSize = value;
          //                     });
          //                   },
          //                   decoration: InputDecoration(
          //                       disabledBorder: UnderlineInputBorder(
          //                           borderSide: BorderSide.none),
          //                       // labelText: 'Time',
          //                       contentPadding: EdgeInsets.all(5)),
          //                 ),
          //               ),
          //               Text(
          //                 'Kg',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           'Add Patients',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //         Row(
          //           children: [
          //             IconButton(
          //               onPressed: () {
          //                 if (index > 1) {
          //                   setState(() {
          //                     index = index - 1;
          //                     price = price - 100;
          //                   });
          //                 }
          //               },
          //               icon: Icon(Icons.cancel_outlined),
          //             ),
          //             Text('$index'),
          //             IconButton(
          //               onPressed: () {
          //                 if (index < 5) {
          //                   setState(() {
          //                     index = index + 1;
          //                     price = price + 100;
          //                   });
          //                 }
          //               },
          //               icon: Icon(Icons.add_rounded),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
