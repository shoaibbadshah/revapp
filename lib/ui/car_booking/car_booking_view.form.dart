// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String CurrentTextValueKey = 'currentText';
const String DestinationTextValueKey = 'destinationText';

mixin $CarBookingView on StatelessWidget {
  final TextEditingController currentTextController = TextEditingController();
  final TextEditingController destinationTextController =
      TextEditingController();
  final FocusNode currentTextFocusNode = FocusNode();
  final FocusNode destinationTextFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    currentTextController.addListener(() => _updateFormData(model));
    destinationTextController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            CurrentTextValueKey: currentTextController.text,
            DestinationTextValueKey: destinationTextController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    currentTextController.dispose();
    destinationTextController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get currentTextValue => this.formValueMap[CurrentTextValueKey];
  String? get destinationTextValue =>
      this.formValueMap[DestinationTextValueKey];

  bool get hasCurrentText => this.formValueMap.containsKey(CurrentTextValueKey);
  bool get hasDestinationText =>
      this.formValueMap.containsKey(DestinationTextValueKey);
}

extension Methods on FormViewModel {}
