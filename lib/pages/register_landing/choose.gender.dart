import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class ChooseGender extends StatelessWidget {
  ChooseGender(
      {super.key, required this.femaleFunction, required this.maleFunction});
  Function? maleFunction, femaleFunction;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "برجاء اختيار نوع التسجيل",
          style: Get.theme.textTheme.bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  "أبحث عن زوج - أنا أنثى",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
                gender(
                    "female", femaleFunction, Get.theme.colorScheme.secondary),
              ],
            ),
            const CustomSizedBox(heightNum: 0.0, widthNum: 0.014),
            Column(
              children: [
                const Text(
                  "أبحث عن زوجة - أنا ذكر",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
                gender("male", maleFunction, Get.theme.primaryColor)
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget gender(imgName, onTap, buttonColor) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: buttonColor,
          padding: const EdgeInsets.all(0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Image.asset(
          "assets/images/register_landing/$imgName.png",
          width: 130,
        ));
  }
}
