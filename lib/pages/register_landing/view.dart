import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register_landing/agree.with.terms.dart';
import 'package:zeffaf/pages/register_landing/choose.gender.dart';
import 'package:zeffaf/pages/register_landing/register.landing.controller.dart';
import 'package:zeffaf/pages/register_landing/registration.tips.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class RegisterLandingView extends GetView<RegisterLandingController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/log_in/logo.png",
                  width: 140,
                ),
                const CustomSizedBox(heightNum: 0.03, widthNum: 0.0),
                const Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  "شروط التطبيق",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MixinBuilder<RegisterLandingController>(
                  init: RegisterLandingController(),
                  builder: (controller) => Column(
                    children: [
                      RegistrationTips(controller),
                      const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
                      AgreeWithTerms(
                        val: controller.value,
                        onChanged: (val) {
                          controller.value.value = val!;
                        },
                      ),
                      const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
                      ChooseGender(
                        maleFunction: controller.value.value
                            ? () {
                                controller.gender.value = 0;
                                Get.toNamed('/register',
                                    arguments: [controller.gender.value]);
                              }
                            : null,
                        femaleFunction: controller.value.value
                            ? () {
                                controller.gender.value = 1;
                                Get.toNamed('/register',
                                    arguments: [controller.gender.value]);
                              }
                            : null,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
