import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class AppTheme {
  // ignore: non_constant_identifier_names
  static final MaterialColor Scaffold_COLOR = _factoryColor(0xffFAFAFA);

  // ignore: non_constant_identifier_names
  static final MaterialColor PRIMARY_COLOR = _factoryColor(0xff3F6DC9);
  static final MaterialColor PRIMARY_LIGHT_COLOR = _factoryColor(0xff3F6DC9);

  // ignore: non_constant_identifier_names
  static final MaterialColor ACCENT_COLOR = _factoryColor(0xffFC9090);

  // ignore: non_constant_identifier_names
  static final MaterialColor LIGHT = _factoryColor(0xfff4f4f8);

  // ignore: non_constant_identifier_names
  static final MaterialColor LIGHT_GREY = _factoryColor(0xffd8d8d8);

  // ignore: non_constant_identifier_names
  static final MaterialColor DARK = _factoryColor(0xff3a3a3a);

  static final MaterialColor GOLD = _factoryColor(0xffFFD700);
  static final MaterialColor GOLD2 = _factoryColor(0xfff5d418);
  static final MaterialColor GOLD3 = _factoryColor(0xffd4b508);

  // ignore: non_constant_identifier_names
  static final MaterialColor WHITE = _factoryColor(0xffffffff);

  // ignore: non_constant_identifier_names
  static final MaterialColor NoActiveData = _factoryColor(0xff585858);

  // ignore: non_constant_identifier_names
  static final MaterialColor GREEN = _factoryColor(0xff349e40);

  // ignore: non_constant_identifier_names
  static final MaterialColor LIGHT_GREEN = _factoryColor(0xff3AB54A);

  // ignore: non_constant_identifier_names
  static final MaterialColor SHADOW = _factoryColor(0xffE7EAF0);

  static final MaterialColor facebookIconColor = _factoryColor(0xff0900b0);
  static final MaterialColor instagramIconColor = _factoryColor(0xff9e26ab);
  static final MaterialColor twitterIconColor = _factoryColor(0xff20c7f5);
  static final MaterialColor whatsappIconColor = _factoryColor(0xff00de1e);
  static final MaterialColor telegramIconColor = _factoryColor(0xff1cb0e6);

  static MaterialColor hex(String hex) =>
      AppTheme._factoryColor(AppTheme._getColorHexFromStr(hex));

  static MaterialColor _factoryColor(int color) {
    return MaterialColor(color, <int, Color>{
      50: Color(color),
      100: Color(color),
      200: Color(color),
      300: Color(color),
      400: Color(color),
      500: Color(color),
      600: Color(color),
      700: Color(color),
      800: Color(color),
      900: Color(color),
    });
  }

  static int _getColorHexFromStr(String colorStr) {
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        val = 0xFFFFFFFF;
      }
    }
    return val;
  }

  static appTheme(Brightness brightness) => ThemeData(
      primaryColor: AppTheme.PRIMARY_COLOR,
      fontFamily: "Cairo",
      platform: TargetPlatform.iOS,
      brightness: brightness,
      iconTheme: const IconThemeData(color: Colors.white),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        headline5: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ), //app bar title
        headline4: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headline3: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headline2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        headline1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w300,
          height: 1.2,
        ),
        subtitle1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        headline6: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          height: 1.2,
        ),
        bodyText1: TextStyle(
          fontSize: 14.0,
          height: 1.2,
        ), //price
        caption: TextStyle(
          fontSize: 9.0,
          height: 1.2,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: AppTheme.WHITE, brightness: brightness)
          .copyWith(secondary: AppTheme.ACCENT_COLOR));

  BoxDecoration boxDecoration = const BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
          image: ExactAssetImage("assets/images/onboarding/bg.png"),
          fit: BoxFit.fill));

  BoxDecoration blueBackground = BoxDecoration(
      color: Get.find<AppController>().isMan.value == 0
          ? Get.theme.primaryColor
          : Get.theme.colorScheme.secondary,
      image: DecorationImage(
          image: Get.find<AppController>().isMan.value == 0
              ? const ExactAssetImage("assets/images/background.png")
              : const ExactAssetImage("assets/images/home/female.png"),
          fit: Get.find<AppController>().isMan.value == 0
              ? BoxFit.fill
              : BoxFit.fill));
}
