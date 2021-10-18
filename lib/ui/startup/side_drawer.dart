import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartUpSideDraer extends StatelessWidget {
  StartUpSideDraer({
    Key? key,
    required this.model,
  }) : super(key: key);
  final StartUpViewModel model;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: screenWidth(context) / 1.8,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              model.userService.hasLoggedInUser && model.userId != null
                  ? StreamProvider<List<Users>>.value(
                      value: model.firestoreApi
                          .streamuser(model.userService.currentUser!.id),
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
                        ),
                      ],
                      builder: (context, child) {
                        var users = Provider.of<List<Users>>(context);
                        if (users.length == 0) {
                          return NotAvailable();
                        }
                        Users user = users.first;
                        return users.length == 0
                            ? NotAvailable()
                            : Container(
                                color: appbg,
                                child: Column(
                                  children: [
                                    verticalSpaceLarge,
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                      radius: 50,
                                    ),
                                    verticalSpaceMedium,
                                    Center(
                                      child: Text(
                                        user.name,
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
                onTapped: () => model.navigateToHome(),
              ),
              DrawerItem(
                title: 'My Bookings',
                icon: Icons.list,
                onTapped: () => model.navigateToBooking(),
              ),
              DrawerItem(
                title: 'My Profile',
                icon: Icons.person,
                onTapped: () => model.navigateToProfile(),
              ),
              DrawerItem(
                title: 'Logout',
                icon: Icons.login,
                onTapped: model.logout,
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
