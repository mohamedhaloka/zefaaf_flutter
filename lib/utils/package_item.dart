import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/packages/store.pay/payment.service.dart';

import '../widgets/custom_image.dart';

Widget packagesOption({price, bgColor, tittle, image, onPress, title}) {
  PaymentService paymentService = PaymentService();
  // paymentService
  return Column(
    children: [
      Text('اشترك في باقتك $title واستفد بمميزاتها',
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
