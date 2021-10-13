import 'package:avenride/ui/addbank/add_bank_viewmodel.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/styles.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/transfertodriver/transferto_driver_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TransferToDriverView extends StatelessWidget {
  const TransferToDriverView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransferToDriverViewModel>.reactive(
      onModelReady: (model) {
        model.listAllBanks();
        model.accountNoController.addListener(() {});
        model.nameController.addListener(() {});
        model.confirmNameController.addListener(() {});
      },
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
        body: model.loading
            ? LoadingScrren()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  Center(
                    child: Text(
                      'Tranfer to Driver Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Text(
                          'Select Bank:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: DropdownButton<String>(
                          value: model.choosenBank,
                          elevation: 5,
                          style: TextStyle(color: Colors.black),
                          items: model.banks.map((
                            var value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value['name'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                          hint: Text(
                            "Please choose",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onChanged: (String? value) {
                            model.setValue(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 40,
                    child: ListTile(
                      title: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'Enter Account number',
                          labelText: 'Account Number',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Account number' : null,
                        // onChanged: (val) {
                        //   model.setAccountNo(val);
                        // },
                        controller: model.accountNoController,
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 40,
                    child: ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'enter account number',
                          labelText: 'Confirm Account Number',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: model.confirmAccount,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: model.confirmAccount,
                              width: 2.0,
                            ),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Account number' : null,
                        onChanged: (val) {
                          if (val == model.accountNoController.text) {
                            model.setConfirmState(true);
                          } else {
                            model.setConfirmState(false);
                          }
                        },
                        controller: model.confirmNameController,
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Visibility(
                    visible: model.isNameVisible,
                    child: Container(
                      height: 40,
                      child: ListTile(
                        title: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: 'your name',
                            labelText: 'verify your name',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'your name' : null,
                          controller: model.nameController,
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton(
                      onPressed: () async {
                        model.handleSubmit(context);
                      },
                      child: model.loading
                          ? CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(model.isNameVisible ? 'Transfer' : 'Verify'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      viewModelBuilder: () => TransferToDriverViewModel(),
    );
  }
}
