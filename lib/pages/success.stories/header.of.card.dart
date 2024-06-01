import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class HeaderOfCard extends StatelessWidget {
  HeaderOfCard({required this.wife, required this.hus});

  String wife, hus;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 85,
      padding: const EdgeInsets.only(top: 22, left: 15, bottom: 8, right: 15),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor.withOpacity(0.4),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Row(
        children: [
          personDetails(
              Get.theme.colorScheme.secondary, "اسم الزوجة", wife, "female"),
          const CustomSizedBox(
            widthNum: 0.06,
            heightNum: 0.0,
          ),
          personDetails(Get.theme.primaryColor, "اسم الزوج", hus, "male"),
        ],
      ),
    );
  }

  personDetails(color, tittle, subtitle, imgName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              image: DecorationImage(
                  image: ExactAssetImage(
                      'assets/images/register_landing/$imgName.png'))),
        ),
        const CustomSizedBox(
          widthNum: 0.02,
          heightNum: 0.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$tittle",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "$subtitle",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
