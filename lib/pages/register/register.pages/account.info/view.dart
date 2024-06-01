import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.info.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.information.controller.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/personal.information.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';

class AccountInformationForm extends GetView<AccountInformationController> {
  AccountInformationForm({required this.onPress});
  Function() onPress;

  GlobalKey<FormState> accountInformationFormKey =
      Get.put(GlobalKey<FormState>(), tag: "accountInformationFormKey");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountInformationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountInformation(),
          PersonalInformation(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomRaisedButton(tittle: "التالي", onPress: onPress),
          ),
        ],
      ),
    );
  }
}
