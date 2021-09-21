import 'package:avenride/ui/car_booking/car_booking_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/back_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CarBookingView extends StatelessWidget {
  CarBookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CarBookingViewModel>.reactive(
      onModelReady: (model) {
        model.setCurrentLoc();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: model.appBarHeight,
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: screenWidth(context) / 1.6,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Enter your location',
                        labelText: 'Enter your location',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your location' : null,
                      controller: model.currentText,
                      focusNode: model.currentFocusNode,
                    ),
                  ),
                  Visibility(
                    visible: model.stop1,
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Container(
                              width: screenWidth(context) / 1.6,
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Enter stop 1',
                                  labelText: 'Enter stop 1',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter stop 1' : null,
                                controller: model.stop1Text,
                                focusNode: model.stop1FocusNode,
                              ),
                            ),
                            IconButton(
                              onPressed: model.removeStop,
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: model.stop2,
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Container(
                              width: screenWidth(context) / 1.6,
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Enter stop 2',
                                  labelText: 'Enter stop 2',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter stop 2' : null,
                                controller: model.stop2Text,
                                focusNode: model.stop2FocusNode,
                              ),
                            ),
                            IconButton(
                              onPressed: model.removeStop,
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Container(
                        width: screenWidth(context) / 1.6,
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: 'Enter destination',
                            labelText: 'Enter destination',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter destination' : null,
                          controller: model.destinationText,
                          focusNode: model.destinationFocusNode,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          model.setAddStop(model.stopCounter);
                        },
                        icon: Icon(Icons.add_outlined),
                      ),
                    ],
                  ),
                ],
              ),
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
              positionFactor: 0.4,
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1750),
            ),
            grabbingHeight: 20,
            grabbing: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: Container(
                color: Colors.white,
                child: model.hasAutoCompleteResults
                    ? ListView.builder(
                        itemCount: model.autoCompleteResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey.shade100,
                            child: ListTile(
                              onTap: () {
                                final s =
                                    model.autoCompleteResults[index].mainText;
                                model.setSearchAdddress(
                                  s!,
                                  model.autoCompleteResults[index].placeId
                                      .toString(),
                                );
                              },
                              title: Text(
                                  model.autoCompleteResults[index].mainText ??
                                      ''),
                              subtitle: Text(model.autoCompleteResults[index]
                                      .secondaryText ??
                                  ''),
                            ),
                          );
                        },
                      )
                    : ListView(
                        children: [
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0.0,
                            child: ListTile(
                              title: Text('save this location'),
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0.0,
                            child: ListTile(
                              title: Text('select from map'),
                              onTap: model.selectFromMap,
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0.0,
                            child: ListTile(
                              title: Text('MMIA Lag Int Airpt'),
                              onTap: () {
                                model.setAirport(MMIA,
                                    'Murtala Muhammed International Airport');
                              },
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0.0,
                            child: ListTile(
                              title: Text('Abj Int Airpt'),
                              onTap: () {
                                model.setAirport(
                                    Abj, 'Abuja-Nnamdi Azikiwe Airport');
                              },
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0.0,
                            child: ListTile(
                              title: Text('PH Int Airpt'),
                              onTap: () {
                                model.setAirport(
                                    PH, 'Port Harcourt International Airport');
                              },
                            ),
                          ),
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
                          BackMap(),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
      onDispose: (model) {
        model.runDispose();
      },
      viewModelBuilder: () => CarBookingViewModel(),
    );
  }
}
