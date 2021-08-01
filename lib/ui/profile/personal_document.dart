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

class PersonalDocument extends StatefulWidget {
  @override
  _PersonalDocumentState createState() => _PersonalDocumentState();
}

class _PersonalDocumentState extends State<PersonalDocument> {
  final _userService = locator<UserService>();
  final _firestoreApi = locator<FirestoreApi>();
  final _navigationService = locator<NavigationService>();
  bool uploaded1 = false,
      uploaded2 = false,
      uploaded3 = false,
      uploaded4 = false,
      loading = false;
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
      final s = await uploadPic(file: item, folderName: 'personaldocuments');
      links.add({
        'fileurl': s,
        'filename': item['name'],
      });
      Increment({
        'personaldocuments': links,
        'personaldocs': Confirmed,
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (links.length == 4) {
      _firestoreApi
          .updateRider(data: store.carride, user: _userService.currentUser.id)
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
              'Personal Document',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ListFormTile(
            isBusy: uploaded1,
            text: 'Birth Certificate',
            btnText: 'Select',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Birth Certificate');
              setState(() {
                uploaded1 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Birth Certificate'});
            },
          ),
          ListFormTile(
            isBusy: uploaded2,
            text: 'Driving Licence',
            btnText: 'Select',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Driving Licence');
              setState(() {
                uploaded2 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Driving Licence'});
            },
          ),
          ListFormTile(
            isBusy: uploaded3,
            text: 'Passport',
            btnText: 'Select',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Passport');
              setState(() {
                uploaded3 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Passport'});
            },
          ),
          ListFormTile(
            isBusy: uploaded4,
            text: 'Election Card',
            btnText: 'Select',
            onTapped: () async {
              final s = await uploadImage(fileName: 'Election Card');
              setState(() {
                uploaded4 = s == null ? false : true;
              });
              files.add({'file': s, 'name': 'Election Card'});
            },
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
