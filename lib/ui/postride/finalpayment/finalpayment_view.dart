import 'package:avatar_glow/avatar_glow.dart';
import 'package:avenride/ui/postride/feedback/feedback_view.dart';
import 'package:avenride/ui/postride/finalpayment/finalpayment_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FinalPaymentView extends StatelessWidget {
  final String totalAmount;
  final String paymenttype;
  FinalPaymentView({
    Key? key,
    required this.totalAmount,
    required this.paymenttype,
  }) : super(key: key);
  bool buttonPressed = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FinalPaymentViewModel>.reactive(
      onModelReady: (model) {
        model.setPayment(paymenttype);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appbg,
          title: Container(
            height: 50,
            child: Image.asset(
              Assets.firebase,
              fit: BoxFit.scaleDown,
            ),
          ),
          centerTitle: true,
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 100,
          child: Center(
            child: Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  model.submit(context);
                },
                child: buttonPressed
                    ? Padding(
                        padding: EdgeInsets.all(5.0),
                        child: LoadingScrren(),
                      )
                    : Text('Submit'),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              height: 200,
              child: Center(
                child: AvatarGlow(
                  glowColor: Colors.white,
                  endRadius: 90.0,
                  duration: Duration(milliseconds: 5000),
                  repeat: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalAmount,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'All discount applied!',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      'Mode of Payment :',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    horizontalSpaceSmall,
                    model.paymentmode == "Add Your Bank Account"
                        ? ElevatedButton(
                            onPressed: () {
                              if (model.paymentmode == "Paypal") {
                                model.paywithPaypal();
                              }
                            },
                            child: Text(model.paymentmode == "Paypal"
                                ? "Pay with Paypal"
                                : ' Pay by Bank'),
                          )
                        : Text(
                            paymenttype,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            verticalSpaceSmall,
            FeedBackView(
              feedbackValue: (value) {
                model.setSelectedFeedback(value);
              },
            ),
          ],
        ),
      ),
      viewModelBuilder: () => FinalPaymentViewModel(),
    );
  }
}
