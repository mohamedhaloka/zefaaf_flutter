import 'package:flutter/material.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/registration_app_bar.dart';
import 'r.c.p.form.dart';
import 'request.change.password.controller.dart';

class RequestChangePasswordView
    extends GetView<RequestChangePasswordController> {
  const RequestChangePasswordView();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: AppTheme().boxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: registrationAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: Get.height * 0.1, bottom: 20),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/log_in/logo.png",
                    width: 140,
                  ),
                  const CustomSizedBox(heightNum: 0.12, widthNum: 0.0),
                  RequestChangePasswordForm()
                ],
              ),
            ),
          ),
        ));
  }
}
