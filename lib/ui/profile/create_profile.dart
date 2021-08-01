import 'package:flutter/material.dart';
import 'package:avenride/ui/profile/personal_document.dart';
import 'package:avenride/ui/shared/constants.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Create Profile',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'First Name',
                labelText: 'First Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your first name' : null,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Last Name',
                labelText: 'Last Name',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter your Last Name' : null,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'NIN Number',
                labelText: 'NIN Number',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Enter NIN Number' : null,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Mobile Number',
                labelText: 'Mobile Number',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter Mobile Number' : null,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Home Address',
                labelText: 'Home Address',
                labelStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Enter Home Address' : null,
              onChanged: (value) {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text(
                'By continuing, I confirm that i have read & agree to the Terms & conditions and Privacy policy'),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PersonalDocument(),
                  ),
                );
              },
              child: Text('Register'),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 3,
                    10,
                    MediaQuery.of(context).size.width / 3,
                    10)),
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 132, 27, 107)),
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
