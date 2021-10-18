import 'package:avenride/models/application_models.dart';
import 'package:avenride/ui/notification/notification_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
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
        body: StreamProvider<List<Users>>.value(
          value:
              model.firestoreApi.streamuser(model.userService.currentUser!.id),
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
            )
          ],
          builder: (context, child) {
            var users = Provider.of<List<Users>>(context);
            if (users.length == 0) {
              return NotAvailable();
            }
            Users user = users.first;
            return user.notification.length == 0
                ? NotAvailable()
                : ListView.builder(
                    itemCount: user.notification.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 1),
                        child: Card(
                          child: ListTile(
                            title: Column(
                              children: [
                                Text(user.notification[index]['title']),
                                verticalSpaceTiny,
                                Text(user.notification[index]['body']),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      viewModelBuilder: () => NotificationViewModel(),
    );
  }
}
