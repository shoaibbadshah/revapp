// Horizontal Spacing
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/ui/booking/booking_view.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:stacked_services/stacked_services.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);

// Screen Size helpers

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

Widget termsCondition(BuildContext context) {
  return Center(
    child: Container(
      width: screenWidth(context) / 1.2,
      child: Text(
        'By continuing, You confirm that I have read & agree to the Terms & conditions and Privacy policy',
      ),
    ),
  );
}

loadingButton() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.white),
  );
}

void showBottomFlash({
  bool persistent = true,
  EdgeInsets margin = EdgeInsets.zero,
  required BuildContext context,
}) {
  final _navigationService = locator<NavigationService>();
  showFlash(
    context: context,
    persistent: persistent,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        margin: margin,
        behavior: FlashBehavior.fixed,
        position: FlashPosition.bottom,
        borderRadius: BorderRadius.circular(8.0),
        borderColor: Colors.blue,
        boxShadows: kElevationToShadow[8],
        backgroundGradient: RadialGradient(
          colors: [Colors.amber.shade300, Colors.amber.shade300],
          center: Alignment.topLeft,
          radius: 5,
        ),
        onTap: () => controller.dismiss(),
        forwardAnimationCurve: Curves.easeInCirc,
        reverseAnimationCurve: Curves.bounceIn,
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          child: FlashBar(
            title: Text(
              'Complete Payment here',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text(
              '',
            ),
            indicatorColor: Colors.red,
            primaryAction: Column(
              children: [
                IconButton(
                  color: Colors.red,
                  onPressed: () => controller.dismiss(),
                  icon: Icon(Icons.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.dismiss();
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                verticalSpaceMedium
              ],
            ),
          ),
        ),
      );
    },
  ).then((_) {
    if (_ != null) {}
  });
}

AppBar logoAppBar() {
  return AppBar(
    backgroundColor: appbg,
    title: Container(
      height: 50,
      child: Image.asset(
        Assets.firebase,
        fit: BoxFit.scaleDown,
      ),
    ),
    centerTitle: true,
  );
}

class ListFormTile extends StatelessWidget {
  final String text, btnText;
  final Function() onTapped;
  final bool isBusy;
  const ListFormTile({
    Key? key,
    required this.text,
    required this.btnText,
    required this.onTapped,
    required this.isBusy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: screenWidth(context) / 2,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: ElevatedButton(
        onPressed: onTapped,
        child: isBusy
            ? Row(
                children: [
                  Image.asset(
                    Assets.doneimg,
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Selected'),
                ],
              )
            : Text(btnText),
      ),
    );
  }
}

class NotAvailable extends StatelessWidget {
  const NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'please click the yellow button',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Center(
          child: Text(
            'Start your booking now!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class FoodIcon extends StatelessWidget {
  final Function() onTap;
  final String image;
  final String iconText;
  FoodIcon({
    Key? key,
    required this.onTap,
    required this.image,
    required this.iconText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            padding: EdgeInsets.all(2),
            width: 70,
            height: 70,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(image)),
          ),
        ),
        verticalSpaceTiny,
        Text(
          iconText,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class LoadingScrren extends StatelessWidget {
  const LoadingScrren({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class PendingButton extends StatelessWidget {
  final bool busy;
  final void Function() onButtonTapped;
  final String price;
  const PendingButton({
    Key? key,
    required this.busy,
    required this.onButtonTapped,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onButtonTapped,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red[400]),
          ),
          child: busy
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : Text(
                  '$price Nan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
        ),
        Text(
          '(click above to pay)',
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

class SuccessButton extends StatelessWidget {
  final void Function() onButtonTapped;

  const SuccessButton({
    Key? key,
    required this.onButtonTapped,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onButtonTapped,
      style: ButtonStyle(),
      child: Row(
        children: [
          Image.asset(
            Assets.doneimg,
            fit: BoxFit.scaleDown,
            height: 20,
            width: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Paid',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class StartLocationLabel extends StatelessWidget {
  final String startLocation;
  final void Function() onMainButtonTapped;

  final String paymentStatus;
  const StartLocationLabel({
    Key? key,
    required this.startLocation,
    required this.paymentStatus,
    required this.onMainButtonTapped,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        paymentStatus == Pending
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      var baseDialog = BaseAlertDialog(
                          title: "Are you sure?",
                          yesOnPressed: onMainButtonTapped,
                          noOnPressed: () {
                            Navigator.of(context).pop();
                          },
                          yes: "Continue",
                          no: "Cancel");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => baseDialog);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              )
            : SizedBox(),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            horizontalSpaceMedium,
            Text(
              'From:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            horizontalSpaceSmall,
            Container(
              width: screenWidth(context) / 2,
              height: 50,
              child: Text(
                startLocation,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EndLocationLabel extends StatelessWidget {
  final String destination;

  const EndLocationLabel({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        horizontalSpaceMedium,
        Text(
          'To:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        horizontalSpaceSmall,
        Container(
          width: screenWidth(context) / 2,
          height: 35,
          child: Text(
            destination,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class DateLabel extends StatelessWidget {
  final String scheduledDate;

  const DateLabel({Key? key, required this.scheduledDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        horizontalSpaceMedium,
        Text(
          'Date:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        horizontalSpaceMedium,
        Text(
          scheduledDate,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class TimeLabel extends StatelessWidget {
  final String scheduleTime;

  const TimeLabel({Key? key, required this.scheduleTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        horizontalSpaceMedium,
        Text(
          'Time:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        horizontalSpaceMedium,
        Text(
          scheduleTime,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class PaymentStatusLabel extends StatelessWidget {
  final bool busy;
  final void Function() onButtonTapped;
  final String paymentStatus;
  final String price;

  const PaymentStatusLabel({
    Key? key,
    required this.busy,
    required this.onButtonTapped,
    required this.paymentStatus,
    required this.price,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return paymentStatus == Pending
        ? Center(
            child: PendingButton(
              price: price,
              busy: busy,
              onButtonTapped: onButtonTapped,
            ),
          )
        : SuccessButton(
            onButtonTapped: () {},
          );
  }
}

// ignore: must_be_immutable
class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  String? _title;
  // ignore: unused_field
  String? _content;
  String? _yes;
  String? _no;
  Function? _yesOnPressed;
  Function? _noOnPressed;

  BaseAlertDialog(
      {required String title,
      String? content,
      required Function yesOnPressed,
      required Function noOnPressed,
      String yes = "Yes",
      String no = "No"}) {
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this._title!),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new TextButton(
          child: new Text(this._yes!),
          onPressed: () {
            this._yesOnPressed!();
          },
        ),
        new TextButton(
          child: Text(
            this._no!,
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () {
            this._noOnPressed!();
          },
        ),
      ],
    );
  }
}
