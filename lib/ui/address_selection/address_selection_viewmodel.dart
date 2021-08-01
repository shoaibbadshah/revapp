import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:places_service/places_service.dart';

import 'address_selection_view.form.dart';

class AddressSelectionViewModel extends FormViewModel {
  final _placesService = locator<PlacesService>();
  final log = getLogger('StartUpViewModel');
  List<PlacesAutoCompleteResult> _autoCompleteResults = [];

  List<PlacesAutoCompleteResult> get autoCompleteResults =>
      _autoCompleteResults;

  bool get hasAutoCompleteResults => _autoCompleteResults.isNotEmpty;

  @override
  void setFormStatus() {
    _getAutoCompleteResults();
  }

  Future<void> _getAutoCompleteResults() async {
    if (addressValue != null) {
      final placesResults = await _placesService.getAutoComplete(addressValue!);

      _autoCompleteResults = placesResults;
      log.v('sleeted place: $_autoCompleteResults');
      notifyListeners();
    }
  }
}
