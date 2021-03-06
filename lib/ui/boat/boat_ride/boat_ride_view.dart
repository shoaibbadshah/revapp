import 'package:avenride/ui/boat/boat_ride/boat_ride_viewmodel.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:search_page/search_page.dart';
import 'package:stacked/stacked.dart';
// ignore: implementation_imports
import 'package:intl/src/intl/date_format.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class BoatRideView extends StatelessWidget {
  final bool isBoat;
  BoatRideView({Key? key, required this.isBoat}) : super(key: key);
  TextEditingController _dateController =
      TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController _timeController = TextEditingController(
    text: formatDate(
        DateTime(DateTime.now().year, DateTime.now().day, DateTime.now().month,
            DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString(),
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoatRideViewModel>.reactive(
      onModelReady: (model) {
        model.isBoat = isBoat;
        MyStore store = VxState.store as MyStore;
        store.carride = {};
      },
      builder: (context, model, child) => Scaffold(
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  isBoat ? 'Boat Ride' : 'Water Cargo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: model.pickuploc != null ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              model.pickuploc.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () =>
                              _buildShowSearch(context, model, model.pick),
                          child: Text(
                            model.pickuploc == null
                                ? 'Select Pickup location'
                                : 'Change Pickup location',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: model.droploc != null ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              model.droploc.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () =>
                              _buildShowSearch(context, model, model.drop),
                          child: Text(
                            model.droploc == null
                                ? 'Select Drop location'
                                : 'Change Drop location',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              !isBoat
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
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    model.setLaguageType = value;
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
              !isBoat
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
                                        model.setLaguageSize = value;
                                      },
                                      keyboardType: TextInputType.number,
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Select Date:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            model.selectDate(context).then((value) {
                              _dateController.text =
                                  DateFormat.yMd().format(value);
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateController,
                              onSaved: (String? val) {
                                model.setDate = val;
                              },
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(top: 0.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Select Time:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            model.selectTime(context).then((value) {
                              _timeController.text = value;
                              _timeController.text = formatDate(
                                  DateTime(
                                      DateTime.now().year,
                                      DateTime.now().day,
                                      DateTime.now().month,
                                      model.selectedTime.hour,
                                      model.selectedTime.minute),
                                  [hh, ':', nn, " ", am]).toString();
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              onSaved: (String? val) {
                                model.setTime = val;
                              },
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _timeController,
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.all(5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isBoat
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
                                'Set Ride Type:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RadioGroup<String>.builder(
                                groupValue: model.verticalGroupValue,
                                onChanged: (value) {
                                  if (value != null) {
                                    model.setoptions(value);
                                  }
                                },
                                // setState(() {
                                //   _verticalGroupValue = value!;
                                // }),
                                items: [
                                  'private',
                                  'shared',
                                ],
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Visibility(
                visible: model.validate,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Center(
                    child: Text(
                      'Please fill the above details',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${model.placeRate} Naira',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 10, 50, 60),
                child: ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () => model.submitForm(context),
                  child: model.isbusy2
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BoatRideViewModel(),
    );
  }

  Future _buildShowSearch(
      BuildContext context, BoatRideViewModel model, String labeltext) {
    return showSearch(
      context: context,
      delegate: SearchPage(
        onQueryUpdate: (s) => print(s),
        items: boatLoc,
        searchLabel: labeltext,
        suggestion: ListView.builder(
          itemCount: boatLoc.length,
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.amber, width: 1)),
              ),
              child: ListTile(
                title: Text(
                  boatLoc[index].loc,
                  style: ktsMediumGreyBodyText,
                ),
                onTap: () => model.popIt(boatLoc[index].loc, labeltext,
                    boatLoc[index].latd, boatLoc[index].long),
              ),
            );
          },
        ),
        failure: Center(
          child: Text('No location found :('),
        ),
        filter: (boatLoc) => [
          boatLoc.loc,
        ],
        builder: (boatLoc) => DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.amber, width: 1)),
          ),
          child: ListTile(
            title: Text(
              boatLoc.loc,
              style: ktsMediumGreyBodyText,
            ),
            onTap: () =>
                model.popIt(boatLoc.loc, labeltext, boatLoc.latd, boatLoc.long),
          ),
        ),
      ),
    );
  }
}
