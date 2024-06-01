import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/partner_specifications.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/talk_about_you.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/telesales_code.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class AboutYouForm extends GetView<AboutYouController> {
  AboutYouForm(
      {super.key,
      required this.gender,
      required this.onPress,
      required this.previousPress,
      required this.loader});
  Function() onPress;
  Function() previousPress;
  bool loader;
  int gender;

  GlobalKey<FormState> aboutYouFormKey =
      Get.put(GlobalKey<FormState>(), tag: "aboutYouFormKey");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: aboutYouFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PartnerSpecifications(gender),
          TalkAboutYou(gender),
          // const TelesalesCode(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomRaisedButton(
                      loading: loader, tittle: "تسجيل", onPress: onPress),
                ),
                const CustomSizedBox(
                  widthNum: 0.014,
                  heightNum: 0.0,
                ),
                Expanded(
                  flex: 1,
                  child: CustomRaisedButton(
                    tittle: "السابق",
                    fontSize: 15,
                    onPress: previousPress,
                    color: Colors.pink[300],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
