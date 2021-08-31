import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/ui/base/authentication_viewmodel.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import 'login_view.form.dart';

class LoginViewModel extends AuthenticationViewModel {
  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  String pass = "admin";
  String animationType = "idle";
  LoginViewModel() : super(successRoute: Routes.startUpView);

  updatePass(String val) {
    pass = val;
    notifyListeners();
  }

  updateAnimationType(String val) {
    print(val);
    animationType = val;
    notifyListeners();
  }

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService!.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );

  void navigateToCreateAccount() =>
      navigationService.navigateTo(Routes.createAccountView);
}
