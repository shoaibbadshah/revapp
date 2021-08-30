import 'dart:ui';

import 'package:avenride/ui/avenfood/avenfood_viewmodel.dart';
import 'package:avenride/ui/avenfood/restaurant_menu.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AvenFoodView extends StatelessWidget {
  const AvenFoodView({Key? key}) : super(key: key);

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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Container(
                height: 105,
                width: screenWidth(context) / 1.2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FoodIcon(
                      image: Assets.hamburger,
                      onTap: () {},
                      iconText: 'Burger',
                    ),
                    horizontalSpaceSmall,
                    FoodIcon(
                      onTap: () {},
                      image: Assets.pizza,
                      iconText: 'Pizza',
                    ),
                    horizontalSpaceSmall,
                    FoodIcon(
                        onTap: () {}, image: Assets.cola, iconText: 'Drinks'),
                    horizontalSpaceSmall,
                    FoodIcon(
                      onTap: () {},
                      image: Assets.noodles,
                      iconText: "Noodles",
                    ),
                  ],
                ),
              ),
              CupertinoSearchTextField(),
              verticalSpaceSmall,
              RestaurantCard(
                onTap: () {
                  model.navigationService.navigateToView(
                    RestaurantMenu(
                      restaurantName: 'Pizza Hut',
                    ),
                  );
                },
                image: Assets.mac,
                restaurantTitle: 'MacDonalds',
                restaurantSubTitle: 'Fast Food and beverages',
                rating: '4.5',
              ),
              RestaurantCard(
                onTap: () {
                  model.navigationService.navigateToView(
                    RestaurantMenu(
                      restaurantName: 'Pizza Hut',
                    ),
                  );
                },
                image: Assets.kfc,
                restaurantTitle: 'KFC',
                restaurantSubTitle: 'Fast Food and beverages',
                rating: '4.2',
              ),
              RestaurantCard(
                onTap: () {
                  model.navigationService.navigateToView(
                    RestaurantMenu(
                      restaurantName: 'Pizza Hut',
                    ),
                  );
                },
                image: Assets.burgerking,
                restaurantTitle: 'Burger King',
                restaurantSubTitle: 'Fast Food and beverages',
                rating: '4.2',
              ),
              RestaurantCard(
                onTap: () {
                  model.navigationService.navigateToView(
                    RestaurantMenu(
                      restaurantName: 'Pizza Hut',
                    ),
                  );
                },
                image: Assets.coldstone,
                restaurantTitle: 'Cold Stone',
                restaurantSubTitle: 'Ice Cream',
                rating: '4.2',
              ),
              RestaurantCard(
                onTap: () {
                  model.navigationService.navigateToView(
                    RestaurantMenu(
                      restaurantName: 'Pizza Hut',
                    ),
                  );
                },
                image: Assets.pizzahut,
                restaurantTitle: 'Pizza Hut',
                restaurantSubTitle: 'Fast Food and beverages',
                rating: '4.2',
              ),
              verticalSpaceSmall,
            ],
          ),
        ),
      ),
      viewModelBuilder: () => AvenFoodViewModel(),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String image;
  final String restaurantTitle;
  final String restaurantSubTitle;
  final String rating;
  final Function() onTap;
  RestaurantCard({
    Key? key,
    required this.image,
    required this.restaurantTitle,
    required this.restaurantSubTitle,
    required this.onTap,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image.asset(
              image,
              fit: BoxFit.fill,
            ),
            verticalSpaceTiny,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        restaurantSubTitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color.fromARGB(255, 14, 172, 0),
                      ),
                      width: 50,
                      height: 40,
                      child: Center(
                          child: Text(
                        rating,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )),
                    ),
                    horizontalSpaceSmall,
                  ],
                ),
              ],
            ),
            verticalSpaceSmall,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
