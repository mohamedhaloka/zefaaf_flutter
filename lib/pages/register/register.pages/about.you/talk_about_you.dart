import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class TalkAboutYou extends GetView<AboutYouController> {
  const TalkAboutYou(this.gender, {super.key});
  final int gender;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "تحدث عن نفسك",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          CustomTextFormField(
            controller: controller.talkAboutYou,
            onSaved: (val) {
              controller.talkAboutYou.text = val;
            },
            tittle:
                "يرجى اختيار كلمات تليق بأخلاقك ${gender == 0 ? 'كمسلم' : 'كمسلمة'}",
            maxLines: 9,
            maxLength: 200,
          ),
        ],
      ),
    );
  }
}
