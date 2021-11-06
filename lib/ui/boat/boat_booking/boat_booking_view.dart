import 'package:avenride/main.dart';
import 'package:avenride/ui/boat/boat_booking/boat_booking_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/back_map.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class BoatBookingView extends StatelessWidget {
  BoatBookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoatBookingViewModel>.reactive(
      onModelReady: (model) {
        model.scheduledTime = formatDate(
            DateTime(
                DateTime.now().year,
                DateTime.now().day,
                DateTime.now().month,
                DateTime.now().hour,
                DateTime.now().minute),
            [hh, ':', nn, " ", am]).toString();
        model.scheduledDate =
            DateFormat.yMd().format(DateTime.now()).toString();
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
                  child: model.searchList.length != 0
                      ? ListView.builder(
                          itemCount: model.searchList.length,
                          itemBuilder: (context, index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: Colors.amber,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  model.searchList[index].loc,
                                  style: ktsMediumGreyBodyText,
                                ),
                                onTap: () {
                                  model.onLocSelected(model.searchList[index]);
                                },
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: boatLoc.length,
                          itemBuilder: (context, index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: Colors.amber,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  boatLoc[index].loc,
                                  style: ktsMediumGreyBodyText,
                                ),
                                onTap: () {
                                  model.onLocSelected(boatLoc[index]);
                                },
                              ),
                            );
                          },
                        )),
            ),
            child: SafeArea(
              child: DecoratedBox(
                decoration: BoxDecoration(
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
                          BackMap(
                            onLocationChange: () {
                              print('car_booking');
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
      onDispose: (model) {
        model.runDispose();
        SetBookinType(bookingtype: '');
      },
      viewModelBuilder: () => BoatBookingViewModel(),
    );
  }
}
