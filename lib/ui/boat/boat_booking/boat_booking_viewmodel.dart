import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/boat/boat_selection_map/boat_selection_map_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

class BoatBookingViewModel extends BaseViewModel {
  final _userService = locator<UserService>();

  final _navigationService = locator<NavigationService>();
  TextEditingController currentText = TextEditingController();
  TextEditingController destinationText = TextEditingController();
  TextEditingController stop1Text = TextEditingController();
  TextEditingController stop2Text = TextEditingController();
  FocusNode currentFocusNode = FocusNode();
  FocusNode destinationFocusNode = FocusNode();
  FocusNode stop1FocusNode = FocusNode();
  FocusNode stop2FocusNode = FocusNode();
  bool isDest = true, isCurr = false;
  String scheduledDate = '', scheduledTime = '';
  late WaterLoc start, end, stop1Loc, stop2Loc;
  Position? currentPosition;
  String placeRates = '', placeDistances = '', duration = '', rate = '';
  final log = getLogger('BoatBookingViewModel');
  late LatLng loc1, loc2, stop1loc3, stop2loc4;
  List<PlacesAutoCompleteResult> _autoCompleteResults = [];
  List<PlacesAutoCompleteResult> get autoCompleteResults =>
      _autoCompleteResults;
  List<WaterLoc> searchList = [];
  bool get hasAutoCompleteResults => _autoCompleteResults.isNotEmpty;
  double stopCounter = 0, appBarHeight = 150;
  bool stop1 = false, stop2 = false;

  Future<void> _getAutoCompleteResults() async {
    if (destinationFocusNode.hasFocus) {
      if (destinationText.value.text != '') {
        final d = boatLoc
            .where(
              (food) => food.loc.toLowerCase().contains(
                    destinationText.text.toLowerCase(),
                  ),
            )
            .toList();
        searchList = d;
        notifyListeners();
      }
    }
    if (stop1FocusNode.hasFocus) {
      if (stop1Text.value.text != '') {
        final s1 = boatLoc
            .where(
              (food) => food.loc.toLowerCase().contains(
                    stop1Text.text.toLowerCase(),
                  ),
            )
            .toList();
        searchList = s1;
        notifyListeners();
      }
    }
    if (stop2FocusNode.hasFocus) {
      if (stop2Text.value.text != '') {
        final s2 = boatLoc
            .where(
              (food) => food.loc.toLowerCase().contains(
                    stop2Text.text.toLowerCase(),
                  ),
            )
            .toList();
        searchList = s2;
        notifyListeners();
      }
    }
    if (currentFocusNode.hasFocus) {
      if (currentText.value.text != '') {
        final c = boatLoc
            .where(
              (food) => food.loc.toLowerCase().contains(
                    currentText.text.toLowerCase(),
                  ),
            )
            .toList();
        searchList = c;
        notifyListeners();
      }
    }
  }

  void setCurrentLoc() async {
    setBusy(true);
    await _getAutoCompleteResults();
    currentFocusNode.requestFocus();
    destinationText.addListener(() {
      if (destinationFocusNode.hasFocus) {
        _getAutoCompleteResults();
      }
    });
    currentText.addListener(() {
      if (currentFocusNode.hasFocus) {
        _getAutoCompleteResults();
      }
    });
    stop1Text.addListener(() {
      if (stop1FocusNode.hasFocus) {
        _getAutoCompleteResults();
      }
    });
    stop2Text.addListener(() {
      if (stop2FocusNode.hasFocus) {
        _getAutoCompleteResults();
      }
    });
    currentFocusNode.addListener(() {});
    destinationFocusNode.addListener(() {});
    stop1FocusNode.addListener(() {});
    stop2FocusNode.addListener(() {});
    setBusy(false);
  }

  void runDispose() {
    autoCompleteResults.clear();
    currentText.dispose();
    destinationText.dispose();
    currentFocusNode.dispose();
    destinationFocusNode.dispose();
    stop1Text.dispose();
    stop1FocusNode.dispose();
    stop2Text.dispose();
    stop2FocusNode.dispose();
  }

  Future<void> saveData() async {
    if (currentText.text != '' && destinationText.text != '') {
      final currentUser = _userService.currentUser;
      String time = formatDate(
          DateTime(DateTime.now().year, DateTime.now().day,
              DateTime.now().month, DateTime.now().hour, DateTime.now().minute),
          [hh, ':', nn, " ", am]).toString();
      String date = DateFormat.yMd().format(DateTime.now()).toString();
      Map<String, dynamic> result = {
        'pickLocation': start.loc,
        'dropLocation': end.loc,
        'price': '1000.00',
        'scheduleTime': time,
        'scheduledDate': date,
        'userId': currentUser.id,
        'drivers': null,
        'paymentStatus': 'Confirmed',
        'pushToken': currentUser.pushToken,
        'pickupLat': start.latd,
        'pickupLong': start.long,
        'dropoffLat': end.latd,
        'dropoffLong': end.long,
        'rideType': 'private',
      };
      Increment(result);
      log.v(result);
      _navigationService.navigateToView(
        BoatSelectionMapView(
          start: LatLng(start.latd, start.long),
          end: LatLng(end.latd, end.long),
        ),
      );
    }
  }

  void setAddStop(double count) {
    if (count == 0) {
      stop1 = true;
      stopCounter = 1;
      appBarHeight = appBarHeight + 80;
    }
    if (count == 1) {
      stop2 = true;
      stopCounter = 2;
      appBarHeight = appBarHeight + 80;
    }
    notifyListeners();
  }

  void removeStop() {
    if (stopCounter == 1) {
      stop1 = false;
      stopCounter = 0;
      appBarHeight = appBarHeight - 80;
    }
    if (stopCounter == 2) {
      stop2 = false;
      stopCounter = 1;
      appBarHeight = appBarHeight - 80;
    }
    notifyListeners();
  }

  void onLocSelected(WaterLoc srhLt) async {
    if (currentFocusNode.hasFocus) {
      currentText.text = srhLt.loc;
      searchList.clear();
      start = srhLt;
      notifyListeners();
      currentFocusNode.nextFocus();
    }
    if (stop1FocusNode.hasFocus) {
      stop1Text.text = srhLt.loc;
      searchList.clear();
      stop1Loc = srhLt;
      notifyListeners();
      stop1FocusNode.nextFocus();
    }
    if (stop2FocusNode.hasFocus) {
      stop2Text.text = srhLt.loc;
      searchList.clear();
      stop2Loc = srhLt;
      notifyListeners();
      stop2FocusNode.nextFocus();
    }
    if (destinationFocusNode.hasFocus) {
      destinationText.text = srhLt.loc;
      searchList.clear();
      end = srhLt;
      notifyListeners();
      destinationFocusNode.unfocus();
    }
    await saveData();
  }
}
