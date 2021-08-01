import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class PermissionChecker extends StatefulWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  PermissionChecker({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _PermissionCheckerState createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends State<PermissionChecker> {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return Future.delayed(Duration(milliseconds: 200), () {
        return false;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            verticalSpaceSmall,
            Text(
              'This feature requires your foreground location data',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Please allow share your location with us.     ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '(we do not share or use your data for advertising or other purposes)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: false));
                  },
                  child: Text(
                    'Deny',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    widget.completer!(SheetResponse(confirmed: true));
                  },
                  child: Text(
                    'Allow',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
