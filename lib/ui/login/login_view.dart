import 'package:avenride/ui/dumb_widgets/authentication_layout.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_view.form.dart';
import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) {
        return Scaffold(
            body: AuthenticationLayout(
          busy: model.isBusy,
          onMainButtonTapped: () {
            model.saveData();
          },
          onCreateAccountTapped: model.navigateToCreateAccount,
          validationMessage: model.validationMessage,
          mainButtonTitle: 'SIGN IN',
          form: Column(
            children: [
              Container(
                height: 200,
                width: screenWidth(context) / 1.5,
                child: CircleAvatar(
                  child: ClipOval(
                    child: new FlareActor(
                      "assets/teddy_test.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: model.animationType,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              verticalSpaceSmall,
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: passwordController,
              ),
            ],
          ),
          onForgotPassword: () {},
          onSignInWithGoogle: () {
            model.useGoogleAuthentication();
          },
          onSignInWithApple: model.useAppleAuthentication,
        ));
      },
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
