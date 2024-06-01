import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class ResendCode extends StatelessWidget {
  ResendCode(
      {required this.onTap, required this.visible, required this.seconds});

  Function() onTap;
  bool visible;
  int seconds;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          visible
              ? InkWell(
                  onTap: onTap,
                  child: Text(
                    "إعادة إرسال كود التفعيل لنفس الرقم",
                    style: Get.textTheme.bodyText2!.copyWith(
                        color: Get.theme.primaryColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  ),
                )
              : Text(
                  "يمكنك إعادة إرسال الكود خلال",
                  style: Get.textTheme.bodyText2!
                      .copyWith(color: Colors.black87, fontSize: 14),
                ),
          const CustomSizedBox(heightNum: 0.0, widthNum: 0.01),
          visible
              ? const SizedBox()
              : Text(
                  "$seconds ثانية",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
        ],
      ),
    );
  }
}
