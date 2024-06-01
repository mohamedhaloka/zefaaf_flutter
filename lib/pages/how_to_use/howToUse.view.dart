import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/how_to_use/howToUse.controller.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';

class HowToUse extends GetView<HowToUseController> {
  @override
  Widget build(context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<HowToUseController>(
        init: HowToUseController(),
        builder: (controller) => Scaffold(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              appBar: customAppBar("howToUse".tr,
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
                      "howToUse".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleMedium!,
                    ),
                    const SizedBox(height: 20),
                    HtmlWidget(
                      '"<iframe width="560" height="315" src="${controller.appController.appSetting.value.websiteLink}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>,"',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ));
  }
}
