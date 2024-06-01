import 'package:zeffaf/appController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static final appController = Get.find<AppController>();

  static convertTime(dateTime) {
    var date = DateTime.parse(dateTime)
        .add(Duration(hours: appController.timeZoneOffset.value));
    String hourType = DateFormat('a').format(date);
    String time = hourType == "AM" ? 'ص' : 'م';

    return "${DateFormat('h:mm').format(date)} $time";
  }

  static convertTimeWithDate(dateTime) {
    var date = DateTime.parse(dateTime)
        .add(Duration(hours: appController.timeZoneOffset.value));
    String hourType = DateFormat('a').format(date);
    String time = hourType == "AM" ? 'ص' : 'م';
    return "${DateFormat('h:mm').format(date)}$time  ${DateFormat('dd/MM/yyyy').format(date)}";
  }

  static convertDate(dateTime) {
    var date = DateTime.parse(dateTime)
        .add(Duration(hours: appController.timeZoneOffset.value));
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static convertToNameOfDay(dateTime) {
    var date = DateTime.parse(dateTime)
        .add(Duration(hours: appController.timeZoneOffset.value));

    return convertDayNameEnToAr(DateFormat('EEEE').format(date));
  }

  static lastAccess(dateTime) {
    var date = DateTime.parse(dateTime)
        .add(Duration(hours: appController.timeZoneOffset.value));
    String hourType = DateFormat('a').format(date);
    String time = hourType == "AM" ? 'ص' : 'م';
    return convertDayNameEnToAr(DateFormat('EEEE').format(date)) +
        "  " +
        DateFormat('h:mm').format(date) +
        " " +
        time;
  }

  static convertDayNameEnToAr(dayName) {
    switch (dayName) {
      case "Saturday":
        return "السبت";
      case "Sunday":
        return "الأحد";
      case "Monday":
        return "الإثنين";
      case "Tuesday":
        return "الثلاثاء";
      case "Wednesday":
        return "الأربعاء";
      case "Thursday":
        return "الخميس";
      case "Friday":
        return "الجمعة";
    }
  }
}
