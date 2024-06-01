import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/body.requirements.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.statue.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.status.controller.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class SocialStatueForm extends GetView<SocialStatusController> {
  SocialStatueForm(
      {super.key,
      required this.onPress,
      required this.previousPress,
      required this.gender});
  Function() onPress;
  Function() previousPress;
  int gender;

  GlobalKey<FormState> socialStatueFormKey =
      Get.put(GlobalKey<FormState>(), tag: "socialStatueFormKey");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: socialStatueFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SocialStatue(gender: gender),
          BodyRequirements(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomRaisedButton(tittle: "التالي", onPress: onPress),
                ),
                const CustomSizedBox(
                  widthNum: 0.01,
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
