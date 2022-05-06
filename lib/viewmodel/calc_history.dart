import 'package:flutter/cupertino.dart';

class calc_historyViewmodel extends ChangeNotifier {
  List _list = [];
  late String s = "未登入";
  late int len = 0;
  List get getList {
    return _list;
  }

  void setList(List list) {
    _list = list;
    notifyListeners();
  }

  String get gets {
    return s;
  }

  void sets(String val) {
    s = val;
    notifyListeners();
  }

  int get getlen {
    return len;
  }

  void setlen(int val) {
    len = val;
    notifyListeners();
  }
}
