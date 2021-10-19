import 'package:avenride/ui/mainScreen/mainScreenViewModel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainScreenViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appbg,
          leading: IconButton(
            icon: Icon(Icons.format_align_left_rounded),
            onPressed: () {},
          ),
          title: Container(
            height: 50,
            child: Image.asset(
              Assets.firebase,
              fit: BoxFit.scaleDown,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                verticalSpaceMedium,
                Row(children: [
                  horizontalSpaceSmall,
                  Text(
                    'Hi, ${model.userService.currentUser!.name}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
                verticalSpaceMedium,
                Card(
                  elevation: 10,
                  child: ListTile(
                    title: Column(
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Text(
                              'Ride with Avenride with Car',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 22),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Text(
                              'Book a car, taxi, delivery',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'and ambulance service now!',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: model.navigateToCardRide,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(2),
                                    width: 70,
                                    height: 70,
                                    child: Image.asset(Assets.carlogo),
                                  ),
                                ),
                                Text(
                                  'data',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22),
                                ),
                              ],
                            ),
                            horizontalSpaceSmall,
                            InkWell(
                              onTap: model.navigateToTaxiRide,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                width: 70,
                                height: 70,
                                child: Image.asset(Assets.taxilogo),
                              ),
                            ),
                            horizontalSpaceSmall,
                            InkWell(
                              onTap: model.navigateToDeliveryServices,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                width: 70,
                                height: 70,
                                child: Image.asset(Assets.deliverylogo),
                              ),
                            ),
                            horizontalSpaceSmall,
                            InkWell(
                              onTap: model.navigateToAmbulanceRide,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                width: 70,
                                height: 70,
                                child: Image.asset(Assets.ambulance),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                      ],
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Card(
                  elevation: 10,
                  child: ListTile(
                    title: Column(
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Text(
                              'Ride with Avenride with Boat',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 22),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Text(
                              'Book a boat, cargo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'service now!',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          children: [
                            InkWell(
                              onTap: model.navigateToBoatRide,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                width: 70,
                                height: 70,
                                child: Image.asset(Assets.bananaBoat),
                              ),
                            ),
                            horizontalSpaceSmall,
                            InkWell(
                              onTap: model.navigateToDelivery,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                width: 70,
                                height: 70,
                                child: Image.asset(Assets.cargo5),
                              ),
                            ),
                            horizontalSpaceSmall,
                          ],
                        ),
                        verticalSpaceSmall,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => MainScreenViewModel(),
    );
  }
}

class BoatRideCard extends StatelessWidget {
  BoatRideCard({
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
                  Text(
                    'Ride with Avenride with Boat',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text(
                    'Book a boat, cargo',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'service now!',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: model.navigateToBoatRide,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Row(
                        children: [
                          Text(
                            'Boat Ride',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.boat1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  InkWell(
                    onTap: model.navigateToDelivery,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(2),
                      child: Row(
                        children: [
                          Text(
                            'Cargo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.cargo5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
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

class CarRideCard extends StatelessWidget {
  CarRideCard({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text(
                'Experience your first ride with Avenride',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              verticalSpaceTiny,
              Text(
                'Request a car, bus, taxi, ambulance, boat, pick-ups and delivery 24hrs errands services.',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ride',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToCardRide,
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.carlogo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Text(
                          'Bus/Taxi Hire',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToCardRide,
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.taxilogo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Send/Pickups',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToCardRide,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Image.asset(Assets.deliverylogo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Boat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToBoatRide,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Image.asset(Assets.boat1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ambulance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToCardRide,
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.ambulance),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Food',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        InkWell(
                          onTap: model.navigateToAvenFood,
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Image.asset(Assets.hamburger),
                          ),
                        ),
                      ],
                    ),
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
