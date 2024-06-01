import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/login/fingerprint.dart';
import 'package:zeffaf/pages/login/login.controller.dart';
import 'package:zeffaf/pages/request.change.password/view.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class LogInForm extends GetView<LoginController> {
  const LogInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomTextFormField(
                tittle: "إسم المستخدم",
                prefixWidget: const Icon(Icons.person),
                onSaved: (v) {
                  controller.username = v;
                },
              ),
              const CustomSizedBox(heightNum: 0.02, widthNum: 0.0),
              CustomTextFormField(
                tittle: "كلمة المرور",
                prefixWidget: const Icon(Icons.lock),
                onSaved: (val) {
                  controller.password = val;
                },
              ),
              const CustomSizedBox(heightNum: 0.008, widthNum: 0.0),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const RequestChangePasswordView());
                  },
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(
                        color: Colors.pinkAccent[200],
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const CustomSizedBox(heightNum: 0.03, widthNum: 0.0),
              Fingerprint(),
              const CustomSizedBox(heightNum: 0.04, widthNum: 0.0),
              CustomRaisedButton(
                tittle: "دخول",
                loading: controller.loading.value,
                onPress: () async {
                  await controller.validateLogin(context);
                },
              )
            ],
          ),
        ));
  }
}
