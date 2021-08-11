import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  FoodCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  StartUpViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        child: ListTile(
          title: Column(
            children: [
              verticalSpaceSmall,
              Row(
                children: [
                  Container(
                    width: screenWidth(context) / 1.3,
                    child: Text(
                      'Are you hungry or want some groceries?',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Container(
                    width: screenWidth(context) / 1.3,
                    child: Text(
                      'We have a wide range of food restaurants and grocery stores',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  horizontalSpaceSmall,
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Shop Now'),
                  ),
                ],
              ),
              verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}
