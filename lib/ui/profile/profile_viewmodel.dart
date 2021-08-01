import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/profile/add_vehicle.dart';
import 'package:avenride/ui/profile/bank_details.dart';
import 'package:avenride/ui/profile/personal_document.dart';
import 'package:avenride/ui/profile/vehicle_document.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();

  navigateToAddVehicle() {
    _navigationService.navigateWithTransition(
      AddVehicle(),
      transition: 'rightToLeft',
    );
  }

  navigateToAddBanKDetials() {
    _navigationService.navigateWithTransition(
      BankDetails(),
      transition: 'rightToLeft',
    );
  }

  navigateToAddPersonalDoc() {
    _navigationService.navigateWithTransition(
      PersonalDocument(),
      transition: 'rightToLeft',
    );
  }

  navigateToAddVehicleDoc() {
    _navigationService.navigateWithTransition(
      VehicleDocument(),
      transition: 'rightToLeft',
    );
  }
}

Future uploadPic({required Map file, required String folderName}) async {
  final _firebaseStorage = FirebaseStorage.instance;
  final _userService = locator<UserService>();
  //Upload to Firebase
  var snapshot = await _firebaseStorage
      .ref()
      .child(
          'Riders/${_userService.currentUser.id}/$folderName/${file['name']}')
      .putFile(file['file']);
  var downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future uploadImage({required String fileName}) async {
  final _imagePicker = ImagePicker();
  PickedFile? image;
  //Check Permissions
  await Permission.photos.request();

  var permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    //Select Image
    image = await _imagePicker.getImage(source: ImageSource.gallery);
    var file = File(image!.path);
    print('Iage seleceted  ad pathe uis $file');

    // ignore: unnecessary_null_comparison
    if (image != null) {
      return file;
    } else {
      print('No Image Path Received');
      return '';
    }
  } else {
    print('Permission not granted. Try Again with permission access');
    return '';
  }
}
