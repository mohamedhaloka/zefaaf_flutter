import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register_landing/register.landing.controller.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class RegistrationTips extends StatelessWidget {
  RegistrationTips(this.controller);
  RegisterLandingController controller;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 280,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: HtmlWidget(
          controller.registerLicense.value,
          textStyle: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }

  drawShimmer(width) {
    return Container(
      width: width,
      height: 10,
      color: Colors.red,
    );
  }
}
