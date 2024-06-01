import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/confirm.new.password/cnp.form.dart';
import 'package:zeffaf/pages/confirm.new.password/header.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class ConfirmNewPasswordView extends StatelessWidget {
  ConfirmNewPasswordView({super.key, this.changePassword, this.phone});
  int? changePassword;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: AppTheme().boxDecoration,
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 20, right: 20, top: Get.height * 0.06, bottom: 12),
          child: Column(
            children: [
              ConfirmNewPasswordHeader(),
              const CustomSizedBox(heightNum: 0.1, widthNum: 0.0),
              ConfirmNewPasswordForm(
                changePassword: changePassword,
                phone: phone,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
