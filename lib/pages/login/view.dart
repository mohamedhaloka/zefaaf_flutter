import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/forget.password/view.dart';
import 'package:zeffaf/pages/login/log.in.form.dart';
import 'package:zeffaf/pages/login/login.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: Get.height * 0.07, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/log_in/logo.png",
                  width: 140,
                ),
                const CustomSizedBox(heightNum: 0.07, widthNum: 0.0),
                const LogInForm(),
                const CustomSizedBox(heightNum: 0.035, widthNum: 0.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'ليس لديك حساب؟  ',
                    style:
                        TextStyle(color: Colors.grey[600], fontFamily: "Cairo"),
                    children: [
                      TextSpan(
                          text: 'سجل الآن مجاناً',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => ForgetPasswordView());
                            },
                          style: TextStyle(
                              color: Colors.pinkAccent[100],
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo")),
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
