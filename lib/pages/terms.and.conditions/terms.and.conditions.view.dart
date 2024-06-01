import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/terms.and.conditions/terms.and.conditions.controller.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';

class TermsAndConditions extends GetView<TermsAndConditionsController> {
  @override
  Widget build(context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<TermsAndConditionsController>(
        init: TermsAndConditionsController(),
        builder: (controller) => Scaffold(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              appBar: customAppBar("الشروط والأحكام",
                  onTap: () {},
                  color: darkMode ? Colors.grey[200] : Colors.grey[800]),
              body: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/onboarding/bg.png")),
                ),
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(50),
                      height: Get.mediaQuery.size.height * 0.3,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    Text(
                      "الشروط والأحكام",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleMedium!,
                    ),
                    const SizedBox(height: 20),
                    HtmlWidget(
                      controller.moreController.registerCondetions,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ));
  }
}
