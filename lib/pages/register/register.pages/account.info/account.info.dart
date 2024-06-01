import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.information.controller.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class AccountInformation extends GetView<AccountInformationController> {
  const AccountInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "بيانات الحساب",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "إسمك الذي سيظهر على التطبيق ولا يمكن تغييره",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              CustomTextFormField(
                  controller: controller.username.value,
                  suffixWidget: Visibility(
                    visible:
                        controller.username.value.text == "" ? false : true,
                    child: controller.visible.value
                        ? Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.all(10),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[400]!,
                              child: const Icon(Icons.more_horiz_sharp),
                            ),
                          )
                        : Icon(
                            controller.checkUserName.value,
                            color: controller.userNameLoading.value == 2
                                ? Colors.red
                                : Colors.green,
                          ),
                  ),
                  usernameInputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onSaved: (val) {
                    controller.username.value.text = val;
                  },
                  focusNode: controller.userNameFocusNode,
                  onFocusChange: (val) {
                    //Focus code comes from here
                  },
                  onChange: (val) {},
                  maxLength: 12,
                  errorText: "من 8 إلى 12 حرف",
                  tittle: "إسم المستخدم"),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              CustomTextFormField(
                  controller: controller.password.value,
                  onSaved: (val) {
                    controller.password.value.text = val;
                  },
                  maxLength: 12,
                  errorText: "من 8 إلى 12 حرف",
                  tittle: "كلمة المرور"),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              CustomTextFormField(
                  controller: controller.rePassword.value,
                  suffixWidget: Visibility(
                    visible:
                        controller.password.value.text == "" ? false : true,
                    child: Icon(
                      controller.checkSamePass.value,
                      color: controller
                              .checkPassInputEqualRePassInput(
                                  controller.password.value.text,
                                  controller.rePassword.value.text)
                              .value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  onSaved: (val) {
                    controller.rePassword.value.text = val;
                  },
                  onFocusChange: (val) {
                    ensurePasswordAndRePasswordAreEqual();
                  },
                  onChange: (val) {
                    ensurePasswordAndRePasswordAreEqual();
                  },
                  maxLength: 12,
                  errorText: "من 8 إلى 12 حرف",
                  tittle: "إعادة كلمة المرور"),
            ],
          ),
        ));
  }

  ensurePasswordAndRePasswordAreEqual() {
    controller
            .checkPassInputEqualRePassInput(controller.password.value.text,
                controller.rePassword.value.text)
            .value
        ? controller.checkSamePass.value = Icons.check
        : controller.checkSamePass.value = Icons.close;
  }
}
