import 'package:avenride/ui/addbank/add_bank_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddBankView extends StatelessWidget {
  const AddBankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddBankViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => AddBankViewModel(),
    );
  }
}
