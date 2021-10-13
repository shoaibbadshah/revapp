import 'package:avenride/main.dart';
import 'package:avenride/ui/paymentui/payment_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentView extends StatelessWidget {
  PaymentView({Key? key, required this.updatePreferences}) : super(key: key);
  final Function() updatePreferences;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
      onModelReady: (model) {
        MyStore store = VxState.store as MyStore;
        model.choosenRide = store.rideType;
        model.choosenPaymentMethod = store.paymentMethod;
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appbg,
          leading: SizedBox(),
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
          height: 80,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                updatePreferences();
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
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
                height: 120,
                child: ListView.builder(
                  itemCount: model.rides.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        model.setRideType(model.rides[index]);
                      },
                      child: Card(
                        color: model.choosenRide == model.rides[index]
                            ? Colors.grey[200]
                            : Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                model.setRideType(model.rides[index]);
                              },
                              child: Text(
                                model.rides[index],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Visibility(
                                visible: model.choosenRide == model.rides[index]
                                    ? true
                                    : false,
                                child: Icon(Icons.check),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                height: 230,
                child: ListView.builder(
                  itemCount: model.paymentMethods.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        model.setPaymentType(model.paymentMethods[index]);
                      },
                      child: Card(
                        color: model.choosenPaymentMethod ==
                                model.paymentMethods[index]
                            ? Colors.grey[200]
                            : Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                model.setPaymentType(
                                  model.paymentMethods[index],
                                );
                                // model.navigateTo(index);
                              },
                              child: Text(
                                model.paymentMethods[index],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Visibility(
                                visible: model.choosenPaymentMethod ==
                                        model.paymentMethods[index]
                                    ? true
                                    : false,
                                child: Icon(Icons.check),
                              ),
                            ),
                          ],
                        ),
                      ),
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
