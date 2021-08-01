import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends BaseViewModel {
  final firestoreApi = locator<FirestoreApi>();
  final userService = locator<UserService>();
}
