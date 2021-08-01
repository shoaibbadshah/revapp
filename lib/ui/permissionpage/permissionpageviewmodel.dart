import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.logger.dart';
import 'package:avenride/ui/startup/startup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked_services/stacked_services.dart';

class PermissionPageViewModel extends BaseViewModel {
  final log = getLogger('Permission Page');
  final _navigationService = locator<NavigationService>();

  void runStartupLogic(BuildContext context) async {
    log.v('Permission section started');
    Alert(
      context: context,
      title: "Requesting access to location in the background",
      desc:
          "This app collects location data to enable features like car booking , boat booking even when the app is closed or not in use.",
      buttons: [
        DialogButton(
          child: Text(
            "ok",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () async {
            log.v('Asking for');
            _navigationService.navigateToView(StartUpView());
          },
          width: 120,
        )
      ],
    ).show();
  }
}
