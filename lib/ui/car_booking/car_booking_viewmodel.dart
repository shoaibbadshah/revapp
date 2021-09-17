import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/location_service.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/car_selection_map/car_selection_map_view.dart';
import 'package:avenride/ui/pointmap/RealTimeMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CarBookingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _locationService = locator<LocationService>();
  final _placesService = locator<PlacesService>();
  final _userService = locator<UserService>();
  TextEditingController currentText = TextEditingController();
  TextEditingController destinationText = TextEditingController();
  bool isDest = true, isCurr = false;
  String currentPlaceId = '', destinationPlaceId = '';
  Position? currentPosition;
  String placeRates = '', placeDistances = '', duration = '', rate = '';
  final log = getLogger('StartUpViewModel');
  late LatLng loc1, loc2;
  List<PlacesAutoCompleteResult> _autoCompleteResults = [];
  List<PlacesAutoCompleteResult> get autoCompleteResults =>
      _autoCompleteResults;

  bool get hasAutoCompleteResults => _autoCompleteResults.isNotEmpty;

  Future<void> _getAutoCompleteResults() async {
    if (isDest) {
      if (destinationText.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(destinationText.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
    if (isCurr) {
      if (currentText.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(currentText.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
  }

  void setCurrentLoc() async {
    setBusy(true);
    _placesService.initialize(
      apiKey: env['GOOGLE_MAPS_API_KEY']!,
    );
    await getCurrentLocation();
    var googleGeocoding = GoogleGeocoding(
      env['GOOGLE_MAPS_API_KEY']!,
    );
    var risult = await googleGeocoding.geocoding.getReverse(
      LatLon(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ),
    );
    if (risult != null) {
      GeocodingResult re = risult.results![0];
      currentPlaceId = re.placeId!;
      currentText.text = re.formattedAddress!;
      notifyListeners();
    }
    destinationText.addListener(() {
      if (isDest) {
        _getAutoCompleteResults();
      }
    });
    currentText.addListener(() {
      if (isCurr) {
        _getAutoCompleteResults();
      }
    });
    setBusy(false);
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

  void selectFromMap() {
    _navigationService.navigateToView(PlacePicker(
      apiKey: env['GOOGLE_MAPS_API_KEY']!,
      initialPosition: LatLng(_locationService.currentLocation.latitude,
          _locationService.currentLocation.longitude),
      useCurrentLocation: true,
      selectInitialPosition: true,
      onPlacePicked: (result) {
        if (isDest) {
          destinationText.text = result.formattedAddress!;
        }
        if (isCurr) {
          currentText.text = result.formattedAddress!;
        }
        _navigationService.back();
        notifyListeners();
      },
    ));
  }

  void setCurr() {
    isCurr = true;
    isDest = false;
    notifyListeners();
  }

  void setDest() {
    isCurr = false;
    isDest = true;
    notifyListeners();
  }

  void setSearchAdddress(String address, String placeId) async {
    print('reached here');
    print(
        'currentPlaceId: $currentPlaceId and destinationPlaceId: $destinationPlaceId');
    if (isDest) {
      isDest = false;
      destinationPlaceId = placeId;
      notifyListeners();
      autoCompleteResults.clear();
      destinationText.text = address;
    }
    if (isCurr) {
      isCurr = false;
      currentPlaceId = placeId;
      notifyListeners();
      autoCompleteResults.clear();
      currentText.text = address;
    }
    if (currentPlaceId != '' && destinationPlaceId != '') {
      print('reached here');
      await _placesService.getPlaceDetails(currentPlaceId).then((value) {
        log.d('Loc 1 : $value');
        loc1 = LatLng(value.lat!, value.lng!);
      });
      await _placesService.getPlaceDetails(destinationPlaceId).then((value) {
        log.d('Loc 2 : $value');
        loc2 = LatLng(value.lat!, value.lng!);
      });
      await saveData();
      _navigationService.navigateToView(CarSelectionMapView(
        end: loc2,
        start: loc1,
      ));
    }
  }

  void runDispose() {
    currentText.dispose();
    destinationText.dispose();
  }

  Future<void> saveData() async {
    final currentUser = _userService.currentUser;
    await Calculate()
        .calculateDistan(
      dropoffplac1: loc2.latitude,
      dropoffplac2: loc2.longitude,
      selectedPlac1: currentPosition!.latitude,
      selectedPlac2: currentPosition!.longitude,
      formtype: Cartype,
    )
        .then((value) {
      placeDistances = value['distance'];
      placeRates = value['placeRate'].toString();
      duration = value['duration'];
      rate = value['rate'].toString();
    });
    Map<String, dynamic> result = {
      'startLocation': currentText.text,
      'destination': destinationText.text,
      'scheduleTime': '',
      'userId': currentUser.id,
      'price': placeRates,
      'distace': placeDistances,
      'paymentStatus': 'Pending',
      'drivers': null,
      'selectedPlace': [
        currentPosition!.latitude,
        currentPosition!.longitude,
      ],
      'dropoffplace': [loc2.latitude, loc2.longitude],
      'rideType': Cartype,
      'pushToken': currentUser.pushToken,
    };
    log.v('Final : $result');
    Increment(result);
  }
}
