import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/distance.dart';
import 'package:avenride/services/location_service.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/car/car_booking/DeliveryTypeSelection.dart';
import 'package:avenride/ui/car/car_selection_map/car_selection_map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class SingleMapEditViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _locationService = locator<LocationService>();
  final _placesService = locator<PlacesService>();
  final _userService = locator<UserService>();
  final _calculate = locator<Calculate>();
  TextEditingController currentText = TextEditingController();
  TextEditingController destinationText = TextEditingController();
  TextEditingController stop1Text = TextEditingController();
  TextEditingController stop2Text = TextEditingController();
  FocusNode currentFocusNode = FocusNode();
  FocusNode destinationFocusNode = FocusNode();
  FocusNode stop1FocusNode = FocusNode();
  FocusNode stop2FocusNode = FocusNode();
  bool isDest = false, isCurr = false;
  String scheduledDate = '', scheduledTime = '';
  String currentPlaceId = '',
      destinationPlaceId = '',
      stop1PlaceId = '',
      stop2PlaceId = '';
  LatLng currentPosition = LatLng(
    51.457838,
    -0.596342,
  );
  String placeRates = '',
      placeDistances = '',
      duration = '',
      rate = '',
      bookingType = '';
  setisDest(bool isit) {
    isDest = isit;
    notifyListeners();
  }

  final log = getLogger('SingleMapEditViewModel');
  late LatLng loc1, loc2, stop1loc3, stop2loc4;
  List<PlacesAutoCompleteResult> _autoCompleteResults = [];
  List<PlacesAutoCompleteResult> get autoCompleteResults =>
      _autoCompleteResults;

  bool get hasAutoCompleteResults => _autoCompleteResults.isNotEmpty;
  double stopCounter = 0, appBarHeight = 150;
  bool stop1 = false, stop2 = false;

  Future<void> _getAutoCompleteResults() async {
    if (destinationFocusNode.hasFocus) {
      if (destinationText.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(destinationText.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
    if (stop1FocusNode.hasFocus) {
      if (stop1Text.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(stop1Text.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
    if (stop2FocusNode.hasFocus) {
      if (stop2Text.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(stop2Text.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
    if (currentFocusNode.hasFocus) {
      if (currentText.value.text != '') {
        final placesResults =
            await _placesService.getAutoComplete(currentText.value.text);
        _autoCompleteResults = placesResults;
        notifyListeners();
      }
    }
  }

  void setLocOnChange() async {
    if (await Permission.location.request().isGranted) {
      final data = _calculate.currentPosition;
      currentPosition = LatLng(data.latitude, data.longitude);
    }
    var googleGeocoding = GoogleGeocoding(
      dotenv.env['GOOGLE_MAPS_API_KEY']!,
    );
    var risult = await googleGeocoding.geocoding.getReverse(
      LatLon(
        currentPosition.latitude,
        currentPosition.longitude,
      ),
    );
    if (risult != null) {
      GeocodingResult re = risult.results![0];
      currentPlaceId = re.placeId!;
      currentText.text = re.formattedAddress!;
      notifyListeners();
    }
  }

  void useCurrentLoc() async {
    setBusy(true);
    _placesService.initialize(
      apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
    );
    if (await Permission.location.request().isGranted) {
      final data = _calculate.currentPosition;
      currentPosition = LatLng(data.latitude, data.longitude);
    }
    var googleGeocoding = GoogleGeocoding(
      dotenv.env['GOOGLE_MAPS_API_KEY']!,
    );
    var risult = await googleGeocoding.geocoding.getReverse(
      LatLon(
        currentPosition.latitude,
        currentPosition.longitude,
      ),
    );
    if (risult != null) {
      GeocodingResult re = risult.results![0];
      if (currentFocusNode.hasFocus) {
        currentPlaceId = re.placeId!;
        currentText.text = re.formattedAddress!;
      } else if (destinationFocusNode.hasFocus) {
        destinationPlaceId = re.placeId!;
        destinationText.text = re.formattedAddress!;
      } else if (stop1FocusNode.hasFocus) {
        stop1PlaceId = re.placeId!;
        stop1Text.text = re.formattedAddress!;
      } else if (stop2FocusNode.hasFocus) {
        stop2PlaceId = re.placeId!;
        stop2Text.text = re.formattedAddress!;
      }
      notifyListeners();
    }
    setBusy(false);
  }

  void setCurrentLoc(LatLng position) async {
    setBusy(true);
    _placesService.initialize(
      apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
    );
    if (await Permission.location.request().isGranted) {
      final data = _calculate.currentPosition;
      currentPosition = LatLng(data.latitude, data.longitude);
    }
    var googleGeocoding = GoogleGeocoding(
      dotenv.env['GOOGLE_MAPS_API_KEY']!,
    );
    var risult = await googleGeocoding.geocoding.getReverse(
      LatLon(
        position.latitude,
        position.longitude,
      ),
    );
    if (risult != null) {
      GeocodingResult re = risult.results![0];
      currentPlaceId = re.placeId!;
      currentText.text = re.formattedAddress!;
      notifyListeners();
    }
    setBusy(true);
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
    currentFocusNode.addListener(() {
      autoCompleteResults.clear();
      notifyListeners();
    });
    currentFocusNode.requestFocus();
    setBusy(false);
  }

  void selectFromMap() {
    _navigationService.navigateToView(PlacePicker(
      apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
      initialPosition: LatLng(_locationService.currentLocation.latitude,
          _locationService.currentLocation.longitude),
      useCurrentLocation: true,
      selectInitialPosition: true,
      onPlacePicked: (result) {
        if (currentFocusNode.hasFocus) {
          currentText.text = result.formattedAddress!;
          currentPlaceId = result.placeId!;
        } else if (stop1FocusNode.hasFocus) {
          stop1Text.text = result.formattedAddress!;
          stop1PlaceId = result.placeId!;
        } else if (stop2FocusNode.hasFocus) {
          stop2Text.text = result.formattedAddress!;
          stop2PlaceId = result.placeId!;
        } else {
          destinationText.text = result.formattedAddress!;
          destinationPlaceId = result.placeId!;
        }
        _navigationService.back();
        notifyListeners();
        getCoordinates();
      },
    ));
  }

  void setSearchAdddress(String address, String placeId) async {
    if (currentFocusNode.hasFocus) {
      currentPlaceId = placeId;
      currentText.text = address;
    }
    currentFocusNode.unfocus();
    autoCompleteResults.clear();

    getCoordinates();
    notifyListeners();
  }

  void getCoordinates() async {
    if (currentPlaceId != '') {
      await _placesService.getPlaceDetails(currentPlaceId).then((value) {
        loc1 = LatLng(value.lat!, value.lng!);
      });
      await saveData();
    }
  }

  void runDispose(BuildContext context) {
    autoCompleteResults.clear();
    currentText.dispose();
    destinationText.dispose();
    currentFocusNode.dispose();
    destinationFocusNode.dispose();
    stop1Text.dispose();
    stop1FocusNode.dispose();
    stop2Text.dispose();
    stop2FocusNode.dispose();
    SetBookinType(bookingtype: '');
  }

  Future<void> saveData() async {
    MyStore store = VxState.store as MyStore;

    if (isDest == false) {
      log.wtf('isDest is false');
      loc2 = LatLng(
          store.carride['dropoffplace'][0], store.carride['dropoffplace'][1]);
      notifyListeners();
      log.wtf(loc1.latitude.toString() + ',' + loc1.longitude.toString());
      log.wtf(loc2.latitude.toString() + ',' + loc2.longitude.toString());
      await Calculate()
          .calculateDistan(
        dropoffplac1: loc2.latitude,
        dropoffplac2: loc2.longitude,
        selectedPlac1: loc1.latitude,
        selectedPlac2: loc1.longitude,
        formtype: Cartype,
      )
          .then((value) {
        placeDistances = value['distance'];
        placeRates = value['placeRate'].toString();
        duration = value['duration'];
        rate = value['rate'].toString();
      });
      store.carride['startLocation'] = currentText.text;
      store.carride['scheduleTime'] = scheduledTime;
      store.carride['scheduledDate'] = scheduledDate;
      store.carride['distace'] = placeDistances;
      store.carride['price'] = double.parse(placeRates);
      store.carride['selectedPlace'] = [
        loc1.latitude,
        loc1.longitude,
      ];

      _navigationService.replaceWith(
        Routes.confirmPickUpView,
        arguments: ConfirmPickUpViewArguments(
          end: loc2,
          start: loc1,
          bookingtype: bookingType,
        ),
      );
    } else {
      log.wtf('isDest is true');
      loc2 = LatLng(
          store.carride['selectedPlace'][0], store.carride['selectedPlace'][1]);
      notifyListeners();
      log.wtf(loc2.latitude.toString() + ',' + loc2.longitude.toString());
      log.wtf(loc1.latitude.toString() + ',' + loc1.longitude.toString());

      await Calculate()
          .calculateDistan(
        dropoffplac1: loc1.latitude,
        dropoffplac2: loc1.longitude,
        selectedPlac1: loc2.latitude,
        selectedPlac2: loc2.longitude,
        formtype: Cartype,
      )
          .then((value) {
        placeDistances = value['distance'];
        placeRates = value['placeRate'].toString();
        duration = value['duration'];
        rate = value['rate'].toString();
      });
      store.carride['destination'] = currentText.text;
      store.carride['scheduleTime'] = scheduledTime;
      store.carride['scheduledDate'] = scheduledDate;
      store.carride['distace'] = placeDistances;
      store.carride['price'] = double.parse(placeRates);
      store.carride['dropoffplace'] = [
        loc1.latitude,
        loc1.longitude,
      ];
      _navigationService.replaceWith(
        Routes.confirmPickUpView,
        arguments: ConfirmPickUpViewArguments(
          end: loc1,
          start: loc2,
          bookingtype: bookingType,
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

  void setAirport(LatLng latLng, String text) async {
    final place = _placesService.getAutoComplete(text);
    await place.then((value) {
      PlacesAutoCompleteResult placesAutoCompleteResult = value[0];
      destinationPlaceId = placesAutoCompleteResult.placeId!;
      destinationText.text = placesAutoCompleteResult.mainText!;
    });
    loc2 = latLng;
    notifyListeners();
    await _placesService.getPlaceDetails(currentPlaceId).then((value) {
      loc1 = LatLng(value.lat!, value.lng!);
    });
    await saveData();
    _navigationService.navigateToView(CarSelectionMapView(
      bookingtype: bookingType,
      end: loc2,
      start: loc1,
    ));
  }
}
