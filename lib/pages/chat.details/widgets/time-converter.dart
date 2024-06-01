import 'package:flutter/material.dart';
import 'package:zeffaf/utils/time.dart';

class TimeConverter extends StatelessWidget {
  TimeConverter(
      {this.dateTime, required this.dateTimeStyle, required this.dateTime2});
  String? dateTime;
  String dateTime2;
  TextStyle dateTimeStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      dateTime == null
          ? ""
          : DateTime.now().difference(DateTime.parse(dateTime!)).inDays == 0
              ? "اليوم"
              : DateTime.now().difference(DateTime.parse(dateTime!)).inDays == 1
                  ? "الأمس"
                  : DateTime.now()
                              .difference(DateTime.parse(dateTime!))
                              .inDays >
                          7
                      ? dateTime2
                      : "${DateTimeUtil.convertToNameOfDay(dateTime)}",
      style: dateTimeStyle,
    );
  }
}
