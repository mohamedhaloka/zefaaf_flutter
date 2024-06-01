import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/privacy/privacy.controller.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';

class Privacy extends GetView<PrivacyController> {
  @override
  Widget build(context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<PrivacyController>(
        init: PrivacyController(),
        builder: (controller) => Scaffold(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              appBar: customAppBar("سياسة الخصوصية",
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
                      "privacy".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleMedium!,
                    ),
                    const SizedBox(height: 20),
                    HtmlWidget(
                      controller.moreController.privacy,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ));
  }
}
