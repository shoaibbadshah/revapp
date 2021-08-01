import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class BookingViewModel extends BaseViewModel {
  final log = getLogger('BookingViewModel');
  final firestoreApi = locator<FirestoreApi>();
}
