import 'package:flutter/material.dart';
import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/app/router_names.dart';
import 'package:avenride/main.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/profile/profile_viewmodel.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class VehicleDocument extends StatefulWidget {
  @override
  _VehicleDocumentState createState() => _VehicleDocumentState();
}

class _VehicleDocumentState extends State<VehicleDocument> {
  bool uploaded1 = false,
      uploaded2 = false,
      uploaded3 = false,
      uploaded4 = false,
      loading = false;
  final _userService = locator<UserService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();
  MyStore store = VxState.store as MyStore;
  @override
  void initState() {
    super.initState();
    store.carride = {};
  }

  List files = [];
  List links = [];

  Future<void> uploadallfiles() async {
    files.forEach((item) async {
      final s = await uploadPic(file: item, folderName: 'vehicledocuments');
      links.add({
        'fileurl': s,
        'filename': item['name'],
      });
      Increment({
        'vehicledocuments': links,
        'vehicledocs': Confirmed,
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (links.length == 4) {
      _firestoreApi
          .updateRider(data: store.carride, user: _userService.currentUser!.id)
          .then((value) {
        setState(() {
          loading = false;
          links = [];
        });
        _navigationService.back();
      });
    }
    return Scaffold(
      appBar: logoAppBar(),
      body: ListView(
        children: [
          verticalSpaceSmall,
          Center(
            child: Text(
              'Vehicle Document',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          verticalSpaceSmall,
          ListFormTile(
            isBusy: uploaded1,
            text: 'RC Book',
            onTapped: () async {
              final s = await uploadImage(fileName: 'RC Book');
              setState(() {
                uploaded1 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'RC Book'});
            },
            btnText: 'Select',
          ),
          ListFormTile(
            isBusy: uploaded2,
            text: 'Insurance Policy',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Insurance Policy');
              setState(() {
                uploaded2 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Insurance Policy'});
            },
            btnText: 'Select',
          ),
          ListFormTile(
            isBusy: uploaded3,
            text: 'Owner Certificate',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Owner Certificate');
              setState(() {
                uploaded3 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Owner Certificate'});
            },
            btnText: 'Select',
          ),
          ListFormTile(
            isBusy: uploaded4,
            text: 'PUC',
            onTapped: () async {
              final s = await uploadImage(fileName: 'PUC');
              setState(() {
                uploaded4 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'PUC'});
            },
            btnText: 'Select',
          ),
          verticalSpaceMedium,
          termsCondition(context),
          verticalSpaceMedium,
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await uploadallfiles();
              },
              child: loading ? loadingButton() : Text('Submit'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 3,
                    10,
                    MediaQuery.of(context).size.width / 3,
                    10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
