import 'package:avenride/ui/help/help_view.dart';
import 'package:avenride/ui/premiumoffers/premium_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumView extends StatelessWidget {
  PremiumView({Key? key}) : super(key: key);
  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  List form = <Widget>[];
  List form1 = <Widget>[];
  @override
  Widget build(BuildContext context) {
    final key3 = GlobalKey<State<Tooltip>>();
    final key2 = GlobalKey<State<Tooltip>>();
    final key4 = GlobalKey<State<Tooltip>>();
    final key5 = GlobalKey<State<Tooltip>>();
    return ViewModelBuilder<PremiumViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                Container(
                  child: Center(child: Image.asset(Assets.userbg)),
                  height: 300,
                ),
                verticalSpaceRegular,
                Card(
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: screenWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            horizontalSpaceRegular,
                            horizontalSpaceSmall,
                            Text(
                              'Super User',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        verticalSpaceSmall,
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    key: key4,
                                    preferBelow: false,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 5,
                                    ),
                                    message:
                                        'Many Avenride users are looking for new ways to travel around the city, particularly when they start commuting back to base and Aven prime User gives you that discounted package. Subscribe to Aven Prime User and enjoy 50% on all hailable services.',
                                    child: IconButton(
                                      onPressed: () => _onTap(key4),
                                      icon: Icon(
                                        Icons.info,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Personal',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '#14.60',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (model.index1 > 0) {
                                        model.setIndex1(model.index1 - 1);
                                      }
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                  Text(
                                    model.index1.toString(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (model.index1 < 1) {
                                        model.setIndex1(model.index1 + 1);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    key: key5,
                                    preferBelow: false,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    message:
                                        'Many Avenride users are looking for new ways to travel around the city, particularly when they start commuting back to base and Aven prime User gives you that discounted package. Subscribe to Aven Prime User and enjoy 50% on all hailable services.',
                                    child: IconButton(
                                      onPressed: () => _onTap(key5),
                                      icon: Icon(
                                        Icons.info,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add another user',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '#12.10',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (model.index2 > 0) {
                                        model.setIndex2(model.index2 - 1);
                                        form.removeAt(model.index2);
                                      }
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                  Text(
                                    model.index2.toString(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      model.setIndex2(model.index2 + 1);
                                      form.add(
                                        ListTile(
                                          title: TextField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Enter name of ${model.index2} user'),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        for (Widget item in form) item,
                        verticalSpaceSmall,
                        model.index2 > 0 || model.index1 > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('continue'),
                                  ),
                                  horizontalSpaceSmall,
                                  horizontalSpaceTiny,
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                verticalSpaceRegular,
                Card(
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: screenWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            horizontalSpaceRegular,
                            horizontalSpaceSmall,
                            Text(
                              'Prime User',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    key: key3,
                                    preferBelow: false,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    message:
                                        '25% reduction on Ambulance service and any other available services of thier choice at avenride control service ratio, rationale. optional water transportation.',
                                    child: IconButton(
                                      onPressed: () => _onTap(key3),
                                      icon: Icon(
                                        Icons.info,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Personal',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '#14.60',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (model.index3 > 0) {
                                        model.setIndex3(model.index3 - 1);
                                      }
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                  Text(
                                    model.index3.toString(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (model.index3 < 1) {
                                        model.setIndex3(model.index3 + 1);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    key: key2,
                                    preferBelow: false,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    message:
                                        '25% reduction on Ambulance service and any other available services of thier choice at avenride control service ratio, rationale. optional water transportation.',
                                    child: IconButton(
                                      onPressed: () => _onTap(key2),
                                      icon: Icon(
                                        Icons.info,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add another user',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '#12.10',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (model.index4 > 0) {
                                        model.setIndex4(model.index4 - 1);
                                        form1.removeAt(model.index4);
                                      }
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                  Text(
                                    model.index4.toString(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      model.setIndex4(model.index4 + 1);
                                      form1.add(
                                        ListTile(
                                          title: TextField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Enter name of ${model.index4} user'),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        for (Widget item in form1) item,
                        verticalSpaceSmall,
                        model.index3 > 0 || model.index4 > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('continue'),
                                  ),
                                  horizontalSpaceSmall,
                                  horizontalSpaceTiny,
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                verticalSpaceRegular,
                RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text:
                            'You are about to Subscribe and become an Avenride Super User. Please read the',
                        style: new TextStyle(color: Colors.black),
                      ),
                      new TextSpan(
                        text: 'Terms & Conditions',
                        style: new TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://us-central1-unique-nuance-310113.cloudfunctions.net/policy');
                          },
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                TextButton(
                  onPressed: () {
                    model.navigationService.navigateToView(HelpView());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'Help & Support ->',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                verticalSpaceLarge,
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => PremiumViewModel(),
    );
  }
}
