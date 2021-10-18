import 'package:avenride/app/router_names.dart';
import 'package:avenride/ui/car/car_ride/car_ride_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';

class FlightRideCard extends StatelessWidget {
  FlightRideCard({
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
                      'Your Averide Airport Request is Just One Click Away',
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
                      'Request your onestop airport ride select airport below.',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      model.navigationService.navigateToView(
                        CarRideView(
                          formType: Cartype,
                          dropLat: MMIA.latitude,
                          dropLng: MMIA.longitude,
                          isDropLatLng: true,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'MMIA Lag Int Airpt',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  InkWell(
                    onTap: () {
                      model.navigationService.navigateToView(CarRideView(
                        formType: Cartype,
                        dropLat: Abj.latitude,
                        dropLng: Abj.longitude,
                        isDropLatLng: true,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Abj Int Airpt',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      model.navigationService.navigateToView(CarRideView(
                        formType: Cartype,
                        dropLat: PH.latitude,
                        dropLng: PH.longitude,
                        isDropLatLng: true,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'PH Int Airpt',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
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
