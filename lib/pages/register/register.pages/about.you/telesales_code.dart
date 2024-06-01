import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class TelesalesCode extends GetView<AboutYouController> {
  const TelesalesCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "كود المندوب",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          CustomTextFormField(
            controller: controller.telesalesCode,
            onSaved: (val) {
              controller.telesalesCode.text = val;
            },
            tittle: "أدخل الكود الترويجي (ان وجد)",
            maxLength: 12,
          ),
        ],
      ),
    );
  }
}
