import 'package:avenride/ui/referalcode/referalcode_viewmodel.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class ReferalCodeView extends StatelessWidget {
  const ReferalCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReferalCodeViewModel>.reactive(
      onModelReady: (model) {
        model.generateReferalCode();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Referal Code'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpaceLarge,
              Center(
                child: Text(
                  'Referal Code:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              verticalSpaceRegular,
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    model.referalCode,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              verticalSpaceRegular,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'share this referal with your friends and family to get special offers. *terms and condition applied*',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              verticalSpaceRegular,
              ElevatedButton(
                onPressed: () {
                  Share.share(
                    'https://play.google.com/store/apps/details?id=com.bitcc.revapp  Download the app, enter the code ${model.referalCode} to get free rides',
                  );
                },
                child: Text('Tap to Share Now'),
              ),
              verticalSpaceLarge,
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ReferalCodeViewModel(),
    );
  }
}
