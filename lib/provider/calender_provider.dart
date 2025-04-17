import 'package:flutter/material.dart';

class CalenderProvider with ChangeNotifier {
  DateTime _selectDate = DateTime.now();
  DateTime get getSelectDate => _selectDate;

  DateTime _today = DateTime.now();
  DateTime get getToday => _today;

  void setSelectDate(DateTime date) {
    _selectDate = date;
  }

  Future<void> setToday(DateTime date) async {
    // _today = getFirstDayOfWeekSunday(date);
    _today = date;
    notifyListeners();
  }

  // DateTime getFirstDayOfWeekSunday(DateTime date) {
  //   int weekday = date.weekday;
  //   return date
  //       .subtract(Duration(days: weekday % 7)); // Adjust for Sunday start
  // }
}
