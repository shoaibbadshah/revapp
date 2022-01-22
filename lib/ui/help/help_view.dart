import 'package:avenride/ui/help/help_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Help & Support'),
        ),
        body: Center(
          child: Text('coming soon...'),
        ),
      ),
      viewModelBuilder: () => HelpViewModel(),
    );
  }
}
