import 'package:avenride/ui/paymentui/payment_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PaymentView extends StatelessWidget {
  PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose ride type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: model.rides.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            model.rides[index],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Shared Ride',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              verticalSpaceRegular,
              Text(
                'Choose payment method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: model.paymentMethods.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            model.navigateTo(index);
                          },
                          child: Text(
                            model.paymentMethods[index],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'Add Bank Account',
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     model.paymentMethod,
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => PaymentViewModel(),
    );
  }
}
