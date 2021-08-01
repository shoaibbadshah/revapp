import 'package:flutter/material.dart';
import 'package:avenride/ui/second/second_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key? key}) : super(key: key);

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    return ViewModelBuilder<SecondViewModel>.reactive(
      onModelReady: (model) {
        controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: 2),
          lowerBound: width / 1.1,
          upperBound: width,
          value: width,
        );

        controller.addListener(() {
          setState(() {});
        });

        controller.repeat(reverse: true);
      },
      builder: (context, model, child) => Scaffold(
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
              child: Container(
                  width: controller.value,
                  child: Image.asset(Assets.loadinimg)),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Finding the best ride for you ...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[900],
              ),
            ),
          ],
        )),
      ),
      viewModelBuilder: () => SecondViewModel(),
    );
  }
}
