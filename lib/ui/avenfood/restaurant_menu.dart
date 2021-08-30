import 'package:avenride/ui/avenfood/avenfood_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RestaurantMenu extends StatelessWidget {
  RestaurantMenu({Key? key, required this.restaurantName}) : super(key: key);
  final String restaurantName;

  List chips = [
    'Sharing Buckets',
    'Box Meals',
    'Burgers',
  ];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AvenFoodViewModel>.reactive(
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
        body: ListView(
          children: [
            verticalSpaceRegular,
            Center(
              child: Text(
                restaurantName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 50,
              width: screenWidth(context) / 1.2,
              padding: EdgeInsets.only(left: 20),
              child: Wrap(
                children: List<Widget>.generate(
                  3,
                  (int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: Colors.white,
                        selectedColor: Colors.teal.shade300,
                        selectedShadowColor: Colors.black,
                        labelStyle: TextStyle(color: Colors.black),
                        label: Text(
                          chips[index],
                        ),
                        selected: model.chipvalue == index,
                        onSelected: (bool selected) =>
                            model.setChip(selected, index),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
            verticalSpaceTiny,
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
            verticalSpaceTiny,
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
            verticalSpaceTiny,
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
            verticalSpaceTiny,
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
            verticalSpaceTiny,
            RestaurantMenuCard(
              heading: 'Dipping Boneless Feast:8 pc',
              description:
                  '8 of our 100% chicken breast Mini Fillers, large Popcorn, Chicken and a mini...',
              price: '16',
              image: Assets.hamburger,
            ),
          ],
        ),
      ),
      viewModelBuilder: () => AvenFoodViewModel(),
    );
  }
}

class RestaurantMenuCard extends StatelessWidget {
  final String heading;
  final String description;
  final String price;
  final String image;

  RestaurantMenuCard(
      {Key? key,
      required this.heading,
      required this.description,
      required this.price,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: screenWidth(context) / 1.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      '$price Naira',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(2),
                width: 70,
                height: 70,
                child: Image.asset(image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
