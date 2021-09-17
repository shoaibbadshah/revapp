import 'package:avenride/ui/car_booking/car_booking_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
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
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 170,
          title: Container(
            child: Column(
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
                                width: 1.5, color: Colors.greenAccent),
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
                            onTap: model.setCurr,
                          ),
                        ),
                        verticalSpaceSmall,
                        Container(
                          height: 2.0,
                          padding: EdgeInsets.all(0),
                          width: screenWidth(context) / 1.6,
                          color: Colors.grey.shade300,
                          margin: EdgeInsets.only(right: 20),
                        ),
                        verticalSpaceSmall,
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
                            onTap: model.setDest,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: model.hasAutoCompleteResults
            ? ListView.builder(
                itemCount: model.autoCompleteResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      final s = model.autoCompleteResults[index].mainText;

                      model.setSearchAdddress(s!,
                          model.autoCompleteResults[index].placeId.toString());
                    },
                    title:
                        Text(model.autoCompleteResults[index].mainText ?? ''),
                    subtitle: Text(
                        model.autoCompleteResults[index].secondaryText ?? ''),
                  );
                },
              )
            : ListView(
                children: [
                  ListTile(
                    title: Text('save this location'),
                  ),
                  ListTile(
                    title: Text('select from map'),
                    onTap: model.selectFromMap,
                  ),
                ],
              ),
      ),
      onDispose: (model) {
        model.runDispose();
      },
      viewModelBuilder: () => CarBookingViewModel(),
    );
  }
}
