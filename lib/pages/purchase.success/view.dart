import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/theme.dart';

class PurchaseSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseSuccessController>(() => PurchaseSuccessController());
  }
}

class PurchaseSuccessController extends GetxController {
  final appController = Get.find<AppController>();

  String packageName = Get.arguments;
  @override
  void onInit() {
    Timer(
      const Duration(seconds: 3),
      () => Get.offAllNamed('/BottomTabsHome'),
    );
    super.onInit();
  }

  // void timerForShowToast(BuildContext context) {
  //   Timer(
  //     const Duration(seconds: 2),
  //     () => showToast(
  //       'في حالة عدم ظهور الباقة يرجى الإنتظار بضع ثواني و إعادة الدخول للتطبيق مرة أخرى',
  //     ),
  //   );
  // }
}

class PurchaseSuccess extends GetView<PurchaseSuccessController> {
  const PurchaseSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: AppTheme().blueBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Image.asset(
                'assets/images/payment_success.png',
                height: Get.height,
                width: Get.width,
                fit: BoxFit.fill,
              ),
              Positioned(
                  top: Get.height / 1.5,
                  left: 20,
                  right: 20,
                  child: Text(
                    'مُبارك عليك العضوية ${controller.packageName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xffc99a0a)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

//Align(
//             alignment: Alignment.center,
//             child: InkWell(
//               onTap: controller.showToast(context),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     "assets/images/purchase_success/new-product.png",
//                     width: 200,
//                     color: controller.appController.isMan.value == 0
//                         ? Get.theme.colorScheme.secondary
//                         : Get.theme.primaryColor,
//                   ),
//                   Text(
//                     "أنت الآن مشترك في الباقة المميزة",
//                     style: TextStyle(
//                         color: controller.appController.isMan.value == 0
//                             ? Colors.white
//                             : Colors.black,
//                         fontSize: 20),
//                   ),
//                   const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
//                   const Text(
//                     "شكراً لك",
//                     style: TextStyle(color: Colors.white, fontSize: 24),
//                   ),
//                   const CustomSizedBox(heightNum: 0.02, widthNum: 0.0),
//                   const CircularProgressIndicator(),
//                 ],
//               ),
//             ),
//           )
