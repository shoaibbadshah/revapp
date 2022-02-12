import 'package:avenride/app/app.router.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/car/userreview/review_viewmodel.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';

class ReviewView extends StatelessWidget {
  ReviewView({Key? key, required this.driver}) : super(key: key);
  final DriverModel driver;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReviewViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          final snackBar = SnackBar(
            content: Text('Please submit your response'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                //   model.navigationService.clearStackAndShow(Routes.startUpView);
                model.navigationService.back();
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text('Rating'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                verticalSpaceLarge,
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(driver.photourl),
                      ),
                      verticalSpaceRegular,
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      verticalSpaceRegular,
                      AddDriverButton(
                        model: model,
                        driverid: driver,
                      ),
                      verticalSpaceRegular,
                      verticalSpaceSmall,
                      Text(
                        'What could be improved?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      verticalSpaceRegular,
                      Wrap(
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          RatingButton(
                            text: 'Cleanliness',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Navigation',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Price',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Pickup',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Route',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Driving',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Service Quality',
                          ),
                          horizontalSpaceSmall,
                          RatingButton(
                            text: 'Other',
                          ),
                        ],
                      ),
                      verticalSpaceRegular,
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) / 6,
                vertical: 10,
              ),
              child: ElevatedButton(
                onPressed: () {
                  model.navigationService.clearStackAndShow(Routes.startUpView);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    horizontalSpaceSmall,
                    Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ReviewViewModel(),
    );
  }
}

class RatingButton extends StatefulWidget {
  const RatingButton({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends State<RatingButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1,
          ),
          color: isSelected ? Colors.amber.shade400 : Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
              fontSize: 19,
              color: isSelected ? Colors.black : Colors.grey.shade600),
        ),
      ),
    );
  }
}

class AddDriverButton extends StatefulWidget {
  const AddDriverButton({
    Key? key,
    required this.model,
    required this.driverid,
  }) : super(key: key);
  final ReviewViewModel model;
  final DriverModel driverid;
  @override
  State<AddDriverButton> createState() => _AddDriverButtonState();
}

class _AddDriverButtonState extends State<AddDriverButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.model.addFavorite(widget.driverid);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? Colors.amber.shade400 : Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),
        child: Text(
          isSelected ? 'Added to Favourites' : "Add to Favourite",
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
