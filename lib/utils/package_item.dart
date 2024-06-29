import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_image.dart';

Widget packagesOption(
    {required bool isMan, price, bgColor, tittle, image, onPress, title}) {
  // paymentService
  return Column(
    children: [
      Text(
          '${isMan ? 'اشترك' : 'اشتركي'} في باقتك $title ${isMan ? 'واستفد' : 'واستفيدي'} بمميزاتها',
          style:
              Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
      // Text(
      //   // paymentService.packagesController.getPackages().toString()
      // ),
      const SizedBox(height: 20),
      InkWell(
        onTap: onPress,
        child: cachedNetworkImage(image,
            boxFit: BoxFit.fitHeight,
            height: 450.0,
            width: Get.mediaQuery.size.width),
      ),
    ],
  );
}
