// import 'package:avenride/models/application_models.dart';
// import 'package:avenride/ui/shared/ui_helpers.dart';
// import 'package:avenride/ui/startup/startup_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stacked/stacked.dart';

// class CurrentRides extends StatelessWidget {
//   const CurrentRides({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<StartUpViewModel>.reactive(
//       builder: (context, model, child) => StreamProvider<List<Users>>.value(
//         value: model.firestoreApi.streamuser(model.userService.currentUser.id),
//         initialData: [
//           Users(
//             id: 'id',
//             email: 'email',
//             defaultAddress: 'defaultAddress',
//             name: 'name',
//             photourl:
//                 'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
//             personaldocs: 'personaldocs',
//             bankdocs: 'bankdocs',
//             vehicle: 'vehicle',
//             isBoat: false,
//             isVehicle: false,
//             vehicledocs: 'vehicledocs',
//             notification: [],
//             mobileNo: '',
//           ),
//         ],
//         builder: (context, child) {
//           var users = Provider.of<List<Users>>(context);
//           if (users.length == 0) {
//             return NotAvailable();
//           }
//           Users user = users.first;
//           return Container(
//             child: Text('s'),
//           );
//         },
//       ),
//       initialiseSpecialViewModelsOnce: true,
//       viewModelBuilder: () => StartUpViewModel(),
//     );
//   }
// }
