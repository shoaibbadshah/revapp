import 'package:avenride/ui/permissionpage/permissionpageviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class PermissionPageView extends StatelessWidget {
  const PermissionPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PermissionPageViewModel>.reactive(
      onModelReady: (model) async {
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          model.runStartupLogic(context);
        });
      },
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    model.runStartupLogic(context);
                  },
                  child: Text('Allow Permissions')),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => PermissionPageViewModel(),
    );
  }
}
