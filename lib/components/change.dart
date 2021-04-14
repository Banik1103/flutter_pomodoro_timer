import 'package:flutter/foundation.dart';

class Change with ChangeNotifier {
  String value = "How long do you want to study for?";

  void changeText() {
    value = "How long do you want your break to be?";
    notifyListeners();
  }
}
