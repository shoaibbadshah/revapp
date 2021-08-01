import 'package:avenride/app/router_names.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:avenride/main.dart';
import 'package:avenride/ui/car_ride/car_ride_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class CarRideView extends StatelessWidget {
  final String formType;
  CarRideView({Key? key, required this.formType}) : super(key: key);
  TextEditingController _dateController =
      TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController _timeController = TextEditingController(
      text: formatDate(
          DateTime(DateTime.now().year, DateTime.now().day,
              DateTime.now().month, DateTime.now().hour, DateTime.now().minute),
          [hh, ':', nn, " ", am]).toString());

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CarRideViewModel>.reactive(
      onModelReady: (model) {
        model.formtype_set = formType;
        MyStore store = VxState.store as MyStore;
        store.carride = {};
      },
      builder: (context, model, child) {
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
          body: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: ListView(
              children: [
                Center(
                  child: Text(
                    formType,
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
                            visible:
                                model.selectedPlace.formattedAddress != null
                                    ? true
                                    : false,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                model.selectedPlace.formattedAddress.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () async {
                              model.navigateToMapPicker(true);
                            },
                            child: model.isbusy
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  )
                                : Text(
                                    model.selectedPlace.formattedAddress == null
                                        ? 'Select PickUp Address'
                                        : 'Change PickUp Address',
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
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: model.dropoffplace.formattedAddress != null
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                model.dropoffplace.formattedAddress.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              model.navigateToMapPicker(false);
                            },
                            child: model.isbusy1
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  )
                                : Text(
                                    model.dropoffplace.formattedAddress == null
                                        ? 'Select DropOff Address'
                                        : 'Change DropOff Address',
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
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
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
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
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
                formType == DeliveryService
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
                formType == Ambulance
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    'Are you booking for yourself:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RadioGroup<String>.builder(
                                  groupValue: model.verticalGroupValue,
                                  onChanged: (value) {
                                    if (value != null) {
                                      model.setoptions(value);
                                    }
                                  },
                                  items: [
                                    'Yes',
                                    'no',
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
                formType == Cartype
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    'Set Ride Type:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RadioGroup<String>.builder(
                                  groupValue: model.ridetype,
                                  onChanged: (value) {
                                    if (value != null) {
                                      model.setRideType(value);
                                    }
                                  },
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
                formType == Ambulance && model.verticalGroupValue == 'no'
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    'No of patients:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          int a = int.parse(value);
                                          model.setpatients = a;
                                          model.setPrice((model.rate * a + 1)
                                              .toStringAsFixed(2));
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          // labelText: 'Time',
                                          contentPadding: EdgeInsets.all(5),
                                        ),
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
                formType == DeliveryService
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
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          model.setLaguageSize = value;
                                        },
                                        decoration: InputDecoration(
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
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
                            'Duration:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${model.duration}',
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
                            '${model.placeRates} Naira',
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
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 60),
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () =>
                        model.submitForm(formtype: formType, context: context),
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
        );
      },
      viewModelBuilder: () => CarRideViewModel(),
    );
  }
}
