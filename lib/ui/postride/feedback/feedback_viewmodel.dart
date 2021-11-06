import 'package:stacked/stacked.dart';

class FeedBackViewModel extends BaseViewModel {
  List title = [
    "1",
    "2",
    "3",
    "4",
    "5",
  ];
  List<bool> isSelected = List.generate(5, (_) => false);
  void setButton(int index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        isSelected[buttonIndex] = true;
      } else {
        isSelected[buttonIndex] = false;
      }
    }
    notifyListeners();
  }
}
