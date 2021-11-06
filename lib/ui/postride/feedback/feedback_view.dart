import 'package:avenride/ui/postride/feedback/feedback_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FeedBackView extends StatelessWidget {
  final Function(String value) feedbackValue;
  const FeedBackView({Key? key, required this.feedbackValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedBackViewModel>.reactive(
      builder: (context, model, child) => Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            verticalSpaceRegular,
            Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'How was your experience?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            ToggleButtons(
              selectedBorderColor: Colors.black,
              selectedColor: Colors.grey,
              children: <Widget>[
                Text(
                  "1",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "2",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "3",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "4",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "5",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
              onPressed: (int index) {
                model.setButton(index);
                feedbackValue(model.title[index]);
              },
              isSelected: model.isSelected,
            ),
            verticalSpaceRegular,
          ],
        ),
      ),
      viewModelBuilder: () => FeedBackViewModel(),
    );
  }
}
