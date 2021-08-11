import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/user_service.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class CarRideViewModel extends BaseViewModel {
  final log = getLogger('CarRideViewModel');
  final _firestoreApi = locator<FirestoreApi>();
  Position? currentPosition;
  PickResult _selectedPlace = PickResult();
  late PickResult _dropoffplace = PickResult();
  bool isbusy = false;
  bool isbusy1 = false;
  bool isbusy2 = false;
  PickResult get selectedPlace => _selectedPlace;
  PickResult get dropoffplace => _dropoffplace;
  final navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _calculate = locator<Calculate>();
  String placeDistances = '';
  String duration = '';
  String placeRates = '';
  String initialRate = '';
  String get placeDistance => placeDistances;
  String get placeRate => placeRates;
  late String formtype;
  String verticalGroupValue = 'Yes';
  String ridetype = 'private';
  int setpatients = 0;
  num rate = 0;
  // ignore: non_constant_identifier_names
  String get formtype_get => formtype;

  // ignore: non_constant_identifier_names
  set formtype_set(String name) {
    this.formtype = name;
  }

  checkPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.permissionchecker,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Select Car Type',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (sheetResponse != null) {
        if (sheetResponse.confirmed) {
          await Permission.locationWhenInUse.request();
          return true;
        }
      }
      return false;
    } else {
      return true;
    }
  }

  getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        currentPosition = Position(
            longitude: position.longitude,
            latitude: position.latitude,
            timestamp: position.timestamp,
            accuracy: position.accuracy,
            altitude: position.altitude,
            heading: position.heading,
            speed: position.speed,
            speedAccuracy: position.speedAccuracy);
      }).catchError((e) {
        print(e);
      });
      log.v('CURRENT POS: $currentPosition');
      return currentPosition;
    }
  }

  onPlacePicked(PickResult result) {
    _selectedPlace = result;
    isbusy = false;
    notifyListeners();
    return navigationService.back();
  }

  setPlacePicked(PickResult result) {
    _selectedPlace = result;
    isbusy = false;
    notifyListeners();
  }

  setDropPicked(PickResult result) async {
    _dropoffplace = result;
  }

  onDropPicked(PickResult result) async {
    _dropoffplace = result;
    await Calculate()
        .calculateDis(
      dropoffplac: _dropoffplace,
      selectedPlac: _selectedPlace,
      formtype: formtype_get,
    )
        .then((value) {
      placeDistances = value['distance'];
      placeRates = value['placeRate'];
      initialRate = value['placeRate'];
      duration = value['duration'];
      rate = value['rate'];
    });
    navigationService.back();
    isbusy1 = false;
    notifyListeners();
  }

  Future<void> setPickUpAddress() async {
    setBusy(true);
    var googleGeocoding = GoogleGeocoding(
      env['GOOGLE_MAPS_API_KEY']!,
    );
    await getCurrentLocation();
    var risult = await googleGeocoding.geocoding.getReverse(
        LatLon(currentPosition!.latitude, currentPosition!.longitude));
    GeocodingResult re = risult!.results![0];
    print(re.formattedAddress);
    await setPlacePicked(PickResult(formattedAddress: re.formattedAddress));
    setBusy(false);
  }

  Future<void> setDropOffAddress(LatLng data) async {
    setBusy(true);
    var googleGeocoding = GoogleGeocoding(
      env['GOOGLE_MAPS_API_KEY']!,
    );
    var risult = await googleGeocoding.geocoding
        .getReverse(LatLon(data.latitude, data.longitude));
    GeocodingResult re = risult!.results![0];
    print(re.formattedAddress);
    _dropoffplace = PickResult(formattedAddress: re.formattedAddress);
    await Calculate()
        .calculateDistan(
      dropoffplac1: data.latitude,
      dropoffplac2: data.longitude,
      selectedPlac1: currentPosition!.latitude,
      selectedPlac2: currentPosition!.longitude,
      formtype: formtype_get,
    )
        .then((value) {
      placeDistances = value['distance'];
      placeRates = value['placeRate'];
      initialRate = value['placeRate'];
      duration = value['duration'];
      rate = value['rate'];
    });
    isbusy1 = false;
    setBusy(false);
    notifyListeners();
  }

  navigateToMapPicker(bool pickup) async {
    pickup ? isbusy = true : isbusy1 = true;
    notifyListeners();
    final status = await checkPermission();
    if (status) {
      await getCurrentLocation();
      navigationService.navigateToView(PlacePicker(
        apiKey: env['GOOGLE_MAPS_API_KEY']!,
        initialPosition:
            LatLng(currentPosition!.latitude, currentPosition!.longitude),
        useCurrentLocation: true,
        selectInitialPosition: true,
        onPlacePicked: (result) =>
            pickup ? onPlacePicked(result) : onDropPicked(result),
      ));
    }
    pickup ? isbusy = false : isbusy1 = false;
    notifyListeners();
  }

  String? _hour, _minute, _time;
  DateTime selectedDate = DateTime.now();
  double? height;
  double? width;

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

  final _userService = locator<UserService>();

  submitForm({required String formtype, required BuildContext context}) async {
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
    if (selectedPlace.formattedAddress == null ||
        dropoffplace.formattedAddress == null) {
      return validaterror('Please fill the above details!');
    }
    if (formtype == DeliveryService) {
      if (selectedPlace.formattedAddress == null ||
          dropoffplace.formattedAddress == null ||
          setLaguageSize == null ||
          setLaguageType == null) {
        return validaterror('Please fill the above details!');
      }
    }
    if (formtype == Ambulance) {
      if (selectedPlace.formattedAddress == null ||
          dropoffplace.formattedAddress == null) {
        return validaterror('Please fill the above details!');
      }
      if (verticalGroupValue == 'no' && setpatients == 0) {
        return validaterror('Please fill the above details!');
      }
      if (verticalGroupValue == 'Yes' && placeRate == '1.00') {
        return validaterror('Please fill the above details!');
      }
    }
    if (_userService.hasLoggedInUser) {
      final currentUser = _userService.currentUser;
      Map<String, dynamic> result;
      if (formtype == DeliveryService) {
        result = {
          'startLocation': selectedPlace.formattedAddress,
          'destination': dropoffplace.formattedAddress,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser.id,
          'price': placeRate,
          'laguageType': setLaguageType,
          'laguageSize': setLaguageSize,
          'distace': placeDistance,
          'paymentStatus': 'Pending',
          'drivers': null,
          'selectedPlace': [
            _selectedPlace.geometry!.location.lat.toDouble(),
            _selectedPlace.geometry!.location.lng.toDouble()
          ],
          'dropoffplace': [
            _dropoffplace.geometry!.location.lat.toDouble(),
            _dropoffplace.geometry!.location.lng.toDouble()
          ],
          'pushToken': currentUser.pushToken,
        };
      } else if (formtype == Ambulance) {
        result = {
          'startLocation': selectedPlace.formattedAddress,
          'destination': dropoffplace.formattedAddress,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser.id,
          'price': placeRate,
          'distace': placeDistance,
          'paymentStatus': 'Pending',
          'drivers': null,
          'selectedPlace': [
            _selectedPlace.geometry!.location.lat.toDouble(),
            _selectedPlace.geometry!.location.lng.toDouble()
          ],
          'dropoffplace': [
            _dropoffplace.geometry!.location.lat.toDouble(),
            _dropoffplace.geometry!.location.lng.toDouble()
          ],
          'pushToken': currentUser.pushToken,
          'personal': verticalGroupValue,
          'patients': setpatients,
        };
      } else if (formtype == Cartype) {
        result = {
          'startLocation': selectedPlace.formattedAddress,
          'destination': dropoffplace.formattedAddress,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser.id,
          'price': placeRate,
          'distace': placeDistance,
          'paymentStatus': 'Pending',
          'drivers': null,
          'selectedPlace': [
            _selectedPlace.geometry!.location.lat.toDouble(),
            _selectedPlace.geometry!.location.lng.toDouble()
          ],
          'dropoffplace': [
            _dropoffplace.geometry!.location.lat.toDouble(),
            _dropoffplace.geometry!.location.lng.toDouble()
          ],
          'rideType': ridetype,
          'pushToken': currentUser.pushToken,
        };
      } else {
        result = {
          'startLocation': selectedPlace.formattedAddress,
          'destination': dropoffplace.formattedAddress,
          'scheduleTime': time,
          'scheduledDate': DateFormat.yMd().format(selectedDate),
          'userId': currentUser.id,
          'price': placeRate,
          'distace': placeDistance,
          'paymentStatus': 'Pending',
          'drivers': null,
          'selectedPlace': [
            _selectedPlace.geometry!.location.lat.toDouble(),
            _selectedPlace.geometry!.location.lng.toDouble()
          ],
          'dropoffplace': [
            _dropoffplace.geometry!.location.lat.toDouble(),
            _dropoffplace.geometry!.location.lng.toDouble()
          ],
          'pushToken': currentUser.pushToken,
        };
      }
      log.v('Final : $result');
      Increment(result);
      return showCustomBottomSheet(formtype, context);
    }
  }

  bool validate = false;
  validaterror(String error) {
    validate = true;
    isbusy2 = false;
    notifyListeners();
  }

  setoptions(String val) {
    verticalGroupValue = val;
    if (verticalGroupValue == 'Yes') {
      setPrice(initialRate);
    }
    notifyListeners();
  }

  setRideType(String val) {
    ridetype = val;
    notifyListeners();
  }

  setPrice(String val) {
    placeRates = val;
    notifyListeners();
  }

  Future showCustomBottomSheet(String formtype, BuildContext context) async {
    if (formtype == Cartype) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.floating,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Select Car Type',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (sheetResponse!.confirmed) {
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
            log.i('Positio ${_selectedPlace.geometry}');
            _firestoreApi
                .createCarRide(
                    carride: store.carride, user: _userService.currentUser)
                .then((value) {
              if (value) {
                navigationService.back();
                return showBottomFlash(context: context);
              }
            });
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
    if (formtype == DeliveryService) {
      var deliveryResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.deliverytype,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Select Delivery Type',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (deliveryResponse!.confirmed) {
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
            log.i('Positio ${_selectedPlace.geometry}');
            _firestoreApi
                .createDeliveryServices(
                    carride: store.carride, user: _userService.currentUser)
                .then((value) {
              if (value) {
                navigationService.back();
                return showBottomFlash(context: context);
              }
            });
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
    if (formtype == Taxi) {
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
          _firestoreApi
              .createTaxiRide(
                  carride: store.carride, user: _userService.currentUser)
              .then((value) {
            if (value) {
              navigationService.back();
              return showBottomFlash(context: context);
            }
          });
        }
      } else {
        isbusy2 = false;
        notifyListeners();
      }
    }
    if (formtype == Ambulance) {
      var ambulanceemercyResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.ambulanceemergency,
        enableDrag: false,
        barrierDismissible: true,
        title: 'Select Medical Emergency ',
        mainButtonTitle: 'Continue',
        secondaryButtonTitle: 'This is cool',
      );
      if (ambulanceemercyResponse!.confirmed) {
        var ambulanceResponse = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.ambulance,
          enableDrag: false,
          barrierDismissible: true,
          title: 'Select extra service',
          mainButtonTitle: 'Continue',
          secondaryButtonTitle: 'This is cool',
        );
        if (ambulanceResponse!.confirmed) {
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
              _firestoreApi
                  .createAmbulance(
                      carride: store.carride, user: _userService.currentUser)
                  .then((value) {
                if (value) {
                  navigationService.back();
                  return showBottomFlash(context: context);
                }
              });
            }
          } else {
            isbusy2 = false;
            notifyListeners();
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
}
