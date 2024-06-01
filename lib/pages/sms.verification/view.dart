import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/sms.verification/header.dart';
import 'package:zeffaf/pages/sms.verification/pin.code.dart';
import 'package:zeffaf/pages/sms.verification/resend.code.dart';
import 'package:zeffaf/pages/sms.verification/sms.verification.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class SMSVerification extends GetView<SMSVerificationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: AppTheme().boxDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: ResendCode(
                seconds: controller.num.value,
                onTap: () {
                  if (controller.num.value == 0) {
                    controller.num.value = 60;
                  }
                  controller.resendCode();
                  controller.sendOTPAgain();
                },
                visible: controller.num.value == 0 ? true : false),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: Get.height * 0.2),
                child: Column(
                  children: [
                    SMSValidationHeader(mobileNumber: controller.mobile),
                    PinCode(
                      onChange: (value) {
                        controller.currentText = value;
                      },
                      onCompleted: (v) async {
                        controller.enabled.value = true;
                        controller.inputCode.value = v.toString();
                        await controller.verifyOtp(controller.inputCode.value);
                      },
                    ),
                    const CustomSizedBox(heightNum: 0.04, widthNum: 0.0),
                    Obx(() => CustomRaisedButton(
                        color: Get.theme.primaryColor,
                        loading: controller.loading.value,
                        tittle: "تم",
                        onPress: controller.enabled.value
                            ? () async {
                                await controller
                                    .verifyOtp(controller.inputCode.value);
                              }
                            : null))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
