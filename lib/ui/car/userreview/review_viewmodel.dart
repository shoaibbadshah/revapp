import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewViewModel extends BaseViewModel {
  final log = getLogger('SearchDriverViewModel');
  final navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();

  addFavorite(DriverModel driv) async {
    final user =
        await firestoreApi.getUser(userId: _userService.currentUser!.id);
    log.wtf(user);

    final driver = {
      'id': driv.id,
      'name': driv.name,
      'image': driv.photourl,
      'mobileno': driv.mobileNo,
    };
  }
}
