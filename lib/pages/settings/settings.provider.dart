import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class ChangeFontSize extends ChangeNotifier {
  final storage = GetStorage();
  double fontSize = 0.0;

  changeSize(val) {
    fontSize = val;
    notifyListeners();
  }

  saveFontSize(fontSize) {
    storage.write('fontSizeAllApp', fontSize);
  }
}
