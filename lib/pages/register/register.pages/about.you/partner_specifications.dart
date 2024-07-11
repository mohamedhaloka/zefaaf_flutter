import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class PartnerSpecifications extends GetView<AboutYouController> {
  const PartnerSpecifications(this.gender, {super.key});
  final int gender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "مواصفات شريك حياتك",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          CustomTextFormField(
            controller: controller.partnerSpecifications,
            onSaved: (val) {
              controller.partnerSpecifications.text = val;
            },
            tittle:
                "يرجى اختيار كلمات تليق ${gender == 0 ? 'بزوجتك المستقبلية' : 'بزوجك المستقبلي'}",
            maxLines: 9,
            maxLength: 200,
          ),
        ],
      ),
    );
  }
}
