import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageHelper {
  static String decodeLanguage() {
    return Get.locale == const Locale('ar', 'EG') ? 'ar' : 'en';
  }

  static updateLanguage(String lang) async {
    Locale locale = encodeLanguage(lang);
    Get.updateLocale(locale);
  }

  static Locale encodeLanguage(String lang) {
    return lang == 'ar'
        ? const Locale('ar', 'EG')
        : Get.locale = const Locale('en', 'US');
  }
}
