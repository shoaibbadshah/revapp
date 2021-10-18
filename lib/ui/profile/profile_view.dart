import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/profile/add_vehicle.dart';
import 'package:avenride/ui/profile/bank_details.dart';
import 'package:avenride/ui/profile/personal_document.dart';
import 'package:avenride/ui/profile/personal_info.dart';
import 'package:avenride/ui/profile/vehicle_document.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/profile/profile_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: logoAppBar(),
        body: ProfileSub(),
      ),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final Function() onTapped;
  final bool isPending;
  ProfileButton({
    Key? key,
    required this.text,
    required this.onTapped,
    required this.isPending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)))),
      ),
      onPressed: onTapped,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Column(
          children: [
            Text(text),
            isPending ? verticalSpaceTiny : SizedBox(),
            isPending
                ? Text(
                    Pending,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SuccessProfileButton extends StatelessWidget {
  final String text;
  SuccessProfileButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.amber,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.doneimg,
            fit: BoxFit.scaleDown,
            height: 20,
            width: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ProfileSub extends StatefulWidget {
  const ProfileSub({Key? key}) : super(key: key);

  @override
  _ProfileSubState createState() => _ProfileSubState();
}

class _ProfileSubState extends State<ProfileSub> {
  final userService = locator<UserService>();
  final firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: firestoreApi.streamuser(userService.currentUser!.id),
      initialData: [
        Users(
          id: 'id',
          email: 'email',
          defaultAddress: 'defaultAddress',
          name: 'name',
          notification: [],
          photourl:
              'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
          personaldocs: 'personaldocs',
          bankdocs: 'bankdocs',
          vehicle: 'vehicle',
          isBoat: false,
          isVehicle: false,
          vehicledocs: 'vehicledocs',
          mobileNo: '',
        )
      ],
      builder: (context, child) {
        var users = Provider.of<List<Users>>(context);
        if (users.length == 0) {
          return NotAvailable();
        }
        Users user = users.first;
        return users.length == 0
            ? NotAvailable()
            : ListView(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                children: [
                  verticalSpaceMedium,
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                    radius: 50,
                  ),
                  verticalSpaceSmall,
                  Center(
                    child: Text(
                      user.name.isEmpty ? user.email : user.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  verticalSpaceMedium,
                  ProfileButton(
                    isPending: false,
                    text: 'Add Personal Info',
                    onTapped: () {
                      return _navigationService.navigateWithTransition(
                        ProfileInfo(isMainScreen: false),
                        transition: 'rightToLeft',
                      );
                    },
                  ),
                  verticalSpaceSmall,
                  user.personaldocs != Confirmed
                      ? ProfileButton(
                          isPending: true,
                          text: 'Add Personal Documents',
                          onTapped: () {
                            return _navigationService.navigateWithTransition(
                              PersonalDocument(),
                              transition: 'rightToLeft',
                            );
                          },
                        )
                      : SuccessProfileButton(text: 'Personal Documents'),
                  verticalSpaceSmall,
                  user.bankdocs != Confirmed
                      ? ProfileButton(
                          isPending: true,
                          text: 'Add Bank Details',
                          onTapped: () {
                            return _navigationService.navigateWithTransition(
                              BankDetails(),
                              transition: 'rightToLeft',
                            );
                          },
                        )
                      : SuccessProfileButton(text: 'Bank Details'),
                  verticalSpaceSmall,
                  user.vehicle != Confirmed
                      ? ProfileButton(
                          isPending: true,
                          text: 'Add Vehicle',
                          onTapped: () {
                            return _navigationService.navigateWithTransition(
                              AddVehicle(),
                              transition: 'rightToLeft',
                            );
                          },
                        )
                      : SuccessProfileButton(text: 'Vehicle'),
                  verticalSpaceSmall,
                  user.vehicledocs != Confirmed
                      ? ProfileButton(
                          isPending: true,
                          text: 'Vehicle Documents',
                          onTapped: () {
                            return _navigationService.navigateWithTransition(
                              VehicleDocument(),
                              transition: 'rightToLeft',
                            );
                          },
                        )
                      : SuccessProfileButton(text: 'Vehicle Documents'),
                  verticalSpaceMedium,
                  if (user.personaldocs == Confirmed &&
                      user.vehicledocs == Confirmed &&
                      user.vehicle == Confirmed &&
                      user.bankdocs == Confirmed)
                    Center(
                        child: Text(
                      'Verification is Done',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                  if (user.personaldocs == Confirmed &&
                      user.vehicledocs == Confirmed &&
                      user.vehicle == Confirmed &&
                      user.bankdocs == Confirmed)
                    Center(
                        child: Text(
                      'Go back and start taking rides!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                ],
              );
      },
    );
  }
}
