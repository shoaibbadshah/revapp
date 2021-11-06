import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
// ignore: implementation_imports
import 'package:intl/src/intl/date_format.dart';
import 'package:velocity_x/velocity_x.dart';

class BoatRideViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final log = getLogger('BoatRideViewModel');
  final _firestoreApi = locator<FirestoreApi>();
  final _userService = locator<UserService>();
  String pick = 'Search Pick up Location';
  String drop = 'Search Drop Location';
  String? pickuploc;
  String? droploc;
  bool isbusy = false;
  bool isbusy1 = false;
  bool isbusy2 = false;
  double pickupLat = 0.0;
  double pickupLong = 0.0;
  double dropoffLong = 0.0;
  double dropoffLat = 0.0;
  String verticalGroupValue = 'private';
  String placeRate = '0.0';
  popIt(String loc, String loctype, double latd, double long) {
    if (loctype == pick) {
      pickuploc = loc;
      pickupLat = latd;
      pickupLong = long;
    }
    if (loctype == drop) {
      droploc = loc;
      dropoffLat = latd;
      dropoffLong = long;
      if (isBoat!) {
        placeRate = '1000.0';
      } else {
        placeRate = '1500.0';
      }
    }
    _navigationService.back();
    notifyListeners();
  }

  setoptions(String val) {
    verticalGroupValue = val;
    notifyListeners();
  }

  String? _hour, _minute, _time;
  DateTime selectedDate = DateTime.now();
  double? height;
  double? width;
  bool? isBoat;
  String? setTime, setDate, setLaguageType, setLaguageSize;
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    selectedDate = picked!;
    log.v('selected time: ${DateFormat.yMd().format(selectedDate)}');
    return selectedDate;
  }

  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();
    _time = _hour! + ' : ' + _minute!;
    log.v('selected time: $_time');
    return _time!;
  }

  submitForm(BuildContext context) async {
    isbusy2 = true;
    notifyListeners();
    String time = _time == null
        ? formatDate(
            DateTime(
                DateTime.now().year,
                DateTime.now().day,
                DateTime.now().month,
                DateTime.now().hour,
                DateTime.now().minute),
            [hh, ':', nn, " ", am]).toString()
        : _time!;
    if (!isBoat!) {
      if (pickuploc == null ||
          droploc == null ||
          setLaguageSize == null ||
          setLaguageType == null) {
        return validaterror('Please fill the above details!');
      }
      if (_userService.hasLoggedInUser) {
        final currentUser = _userService.currentUser;
        log.v('Laguage Type : $setLaguageType  Laguage Size: $setLaguageSize');
        final result = {
          'pickLocation': pickuploc,
          'dropLocation': droploc,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser!.id,
          'paymentStatus': 'Pending',
          'laguageType': setLaguageType,
          'laguageSize': setLaguageSize,
          'drivers': null,
          'pushToken': currentUser.pushToken,
          'pickupLat': pickupLat,
          'pickupLong': pickupLong,
          'dropoffLat': dropoffLat,
          'dropoffLong': dropoffLong,
          'rideType': verticalGroupValue,
          'price': placeRate,
        };
        log.v('Final : $result');
        Increment(result);
        return showCustomBottomSheet(context);
      }
    } else {
      if (pickuploc == null || droploc == null) {
        return validaterror('Please fill the above details!');
      }
      if (_userService.hasLoggedInUser) {
        final currentUser = _userService.currentUser;
        final result = {
          'pickLocation': pickuploc,
          'dropLocation': droploc,
          'price': placeRate,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser!.id,
          'drivers': null,
          'paymentStatus': 'Pending',
          'pushToken': currentUser.pushToken,
          'pickupLat': pickupLat,
          'pickupLong': pickupLong,
          'dropoffLat': dropoffLat,
          'dropoffLong': dropoffLong,
          'rideType': verticalGroupValue,
        };
        log.v('Final : $result');
        Increment(result);
        return showCustomBottomSheet(context);
      }
    }
  }

  bool validate = false;
  validaterror(String error) {
    validate = true;
    isbusy2 = false;
    notifyListeners();
  }

  final _bottomSheetService = locator<BottomSheetService>();
  Future showCustomBottomSheet(BuildContext context) async {
    var boatypeRespose = await _bottomSheetService.showCustomSheet(
      variant: isBoat! ? BottomSheetType.boattype : BottomSheetType.cargotype,
      enableDrag: false,
      barrierDismissible: true,
      title: isBoat! ? 'Select boat type ' : 'Select cargo type',
      mainButtonTitle: 'Continue',
      secondaryButtonTitle: 'This is cool',
    );
    if (boatypeRespose!.confirmed) {
      var payRespose = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.payment,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Pay ',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (payRespose!.confirmed) {
        if (_userService.hasLoggedInUser) {
          MyStore store = VxState.store as MyStore;
          log.i(store.carride);
          if (await Permission.location.request().isGranted) {
            await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high)
                .then((Position position) async {})
                .catchError((e) {
              print(e);
            });
          }

          if (!isBoat!) {
            _firestoreApi
                .createDeliveryRide(
              carride: store.carride,
              user: _userService.currentUser!,
            )
                .then((value) {
              if (value != '') {
                _navigationService.back();
                return showBottomFlash(context: context);
              }
            });
          } else {
            _firestoreApi
                .createBoatRide(
              carride: store.carride,
              user: _userService.currentUser!,
            )
                .then((value) {
              if (value != '') {
                _navigationService.back();
                return showBottomFlash(context: context);
              }
            });
          }
        }
      } else {
        isbusy2 = false;
        notifyListeners();
      }
    } else {
      isbusy2 = false;
      notifyListeners();
    }
  }
}
