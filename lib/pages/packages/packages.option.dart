import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/packages/packages.controller.dart';

import '../../utils/package_item.dart';
import 'payment_type.dart' as payment;
import 'store.pay/payment.service.dart';

class PackagesOption extends GetView<PackagesController> {
  PackagesOption(this.pageController);
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 540,
          child: PageView.builder(
            itemCount: controller.packages.length,
            controller: pageController,
            itemBuilder: (context, index) => packagesOption(
                isMan: controller.appController.isMan.value == 0,
                image: controller.packages[index].image.toString(),
                onPress: () async {
                  final appSettings = Get.find<AppController>().appSetting;

                  int id = controller.packages[index].id!;
                  PaymentService paymentService = PaymentService();

                  payment.BottomSheet bottomSheet = payment.BottomSheet();

                  controller.paymentValue.value =
                      controller.packages[index].usdValue.toString();
                  controller.paymentId.value =
                      controller.packages[index].id.toString();

                  bottomSheet.modalBottomSheetMenu(
                      context,
                      appSettings.value,
                      id,
                      paymentService,
                      controller.appController.userData.value,
                      controller.packages[index],
                      controller);
                },
                title: controller.packages[index].title ?? ''),
          ),
        ),
        const SizedBox(height: 60),
        SmoothPageIndicator(
          controller: pageController,
          count: controller.packages.length,
          effect: ExpandingDotsEffect(
            activeDotColor: controller.appController.isMan.value == 0
                ? Get.theme.primaryColor
                : Get.theme.colorScheme.secondary,
            expansionFactor: 2.5,
            strokeWidth: 6,
            dotWidth: 8,
            dotHeight: 8,
          ),
        )
      ],
    );
  }
}
