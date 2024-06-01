import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/confirm.new.password/cnp.controller.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

import '../../utils/toast.dart';

class ConfirmNewPasswordForm extends GetView<ConfirmNewPasswordController> {
  ConfirmNewPasswordForm({super.key, required this.changePassword, this.phone});
  int? changePassword;
  String? phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MixinBuilder<ConfirmNewPasswordController>(
      init: ConfirmNewPasswordController(),
      builder: (controller) => Form(
          key: _formKey,
          child: Column(
            children: [
              // Visibility(
              //   visible: changePassword == 2 ? true : false,
              //   child: Column(
              //     children: [
              //       CustomTextFormField(
              //         tittle: "أدخل الكود",
              //         prefixWidget: const Icon(Icons.paste_sharp),
              //         controller: controller.tempPassword.value,
              //         maxLength: 6,
              //         onSaved: (val) {
              //           controller.tempPassword.value.text = val;
              //         },
              //       ),
              //       const Divider()
              //     ],
              //   ),
              // ),
              Text(
                "إعادة إدخال كلمة مرور جديدة",
                style: Get.textTheme.bodyText2!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const CustomSizedBox(heightNum: 0.02, widthNum: 0.0),
              CustomTextFormField(
                  controller: controller.password.value,
                  onSaved: (val) {
                    controller.password.value.text = val;
                  },
                  maxLength: 12,
                  errorText: "من 8 إلى 12 حرف",
                  tittle: "كلمة المرور الجديدة"),
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
                  tittle: "إعادة كلمة المرور الجديدة"),
              const CustomSizedBox(heightNum: 0.05, widthNum: 0.0),
              CustomRaisedButton(
                  tittle: "تأكيد",
                  loading: controller.loading.value,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (controller.password.value.text ==
                          controller.rePassword.value.text) {
                        if (changePassword == 1) {
                          controller
                              .confirmNewPass(controller.password.value.text);
                        } else if (changePassword == 2) {
                          controller.createNewPassword(
                              newPass: controller.password.value.text,
                              phone: phone,
                              context: context);
                        }
                      } else {
                        showToast("كلِمتا السر غير متطابقتان");
                      }
                    } else {}
                  })
            ],
          )),
    );
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
