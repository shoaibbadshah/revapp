import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/favouritedrivers/favouritedrivers_view.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class StartUpSideDraer extends StatefulWidget {
  StartUpSideDraer({
    Key? key,
    required this.model,
  }) : super(key: key);
  final StartUpViewModel model;

  @override
  State<StartUpSideDraer> createState() => _StartUpSideDraerState();
}

class _StartUpSideDraerState extends State<StartUpSideDraer> {
  Users userdetail = Users(
    id: 'id',
    email: 'email',
    defaultAddress: 'defaultAddress',
    name: 'name',
    photourl: 'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
    personaldocs: 'personaldocs',
    bankdocs: 'bankdocs',
    vehicle: 'vehicle',
    isBoat: false,
    isVehicle: false,
    vehicledocs: 'vehicledocs',
    notification: [],
    mobileNo: '',
    favourites: [],
  );
  bool bookingVisible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: screenWidth(context) / 1.8,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              widget.model.userService.hasLoggedInUser &&
                      widget.model.userId != null
                  ? StreamProvider<List<Users>>.value(
                      value: widget.model.firestoreApi
                          .streamuser(widget.model.userService.currentUser!.id),
                      initialData: [
                        Users(
                          id: 'id',
                          email: 'email',
                          defaultAddress: 'defaultAddress',
                          name: 'name',
                          photourl:
                              'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
                          personaldocs: 'personaldocs',
                          bankdocs: 'bankdocs',
                          vehicle: 'vehicle',
                          isBoat: false,
                          isVehicle: false,
                          vehicledocs: 'vehicledocs',
                          notification: [],
                          mobileNo: '',
                          favourites: [],
                        ),
                      ],
                      builder: (context, child) {
                        var users = Provider.of<List<Users>>(context);
                        if (users.length == 0) {
                          return NotAvailable();
                        }
                        Users user = users.first;
                        SchedulerBinding.instance
                            ?.addPostFrameCallback((timeStamp) async {
                          setState(() {
                            userdetail = user;
                          });
                        });
                        return users.length == 0
                            ? NotAvailable()
                            : Container(
                                color: appbg,
                                child: Column(
                                  children: [
                                    verticalSpaceLarge,
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.photourl),
                                      radius: 50,
                                    ),
                                    verticalSpaceMedium,
                                    Center(
                                      child: Text(
                                        'Welcome, ${user.name}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    verticalSpaceMedium,
                                  ],
                                ),
                              );
                      },
                    )
                  : SizedBox(),
              DrawerItem(
                title: 'Home',
                icon: Icons.home,
                onTapped: () => widget.model.navigateToHome(),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    bookingVisible = !bookingVisible;
                  });
                },
                leading: Icon(
                  Icons.list,
                  color: Colors.amber,
                ),
                title: Row(
                  children: [
                    Text(
                      'My Bookings',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Car Ride',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingCar(),
                  ),
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Ambulance',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingAmbulance(),
                  ),
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Send/Pickups',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingSendPickups(),
                  ),
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Bus/taxi',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingBusTaxi(),
                  ),
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Boat',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingBoat(),
                  ),
                ),
              ),
              Visibility(
                visible: bookingVisible,
                child: Container(
                  color: Colors.grey[200],
                  child: DrawerItem(
                    title: 'Water Cargo',
                    icon: Icons.list,
                    onTapped: () => widget.model.navigateToBookingCargo(),
                  ),
                ),
              ),
              DrawerItem(
                title: 'My Profile',
                icon: Icons.person,
                onTapped: () => widget.model.navigateToProfile(),
              ),
              DrawerItem(
                title: 'Logout',
                icon: Icons.login,
                onTapped: widget.model.logout,
              ),
              DrawerItem(
                title: 'Share',
                icon: Icons.share,
                onTapped: () {
                  Share.share(
                    'https://play.google.com/store/apps/details?id=com.bitcc.revapp',
                  );
                },
              ),
              DrawerItem(
                title: 'Help & Support',
                icon: Icons.help,
                onTapped: () {
                  final snackBar = SnackBar(
                    content: Text('Coming Soon....'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
              DrawerItem(
                title: 'Favourite Driver',
                icon: Icons.favorite,
                onTapped: () {
                  widget.model.navigationService
                      .navigateToView(FavouriteDriversView(
                    favourite: userdetail.favourites,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTapped;
  const DrawerItem(
      {required this.title, required this.icon, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapped,
      leading: Icon(
        icon,
        color: Colors.amber,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
