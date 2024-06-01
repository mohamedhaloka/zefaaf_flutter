import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/utils/theme.dart';

import '../../utils/toast.dart';

class UserStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 23,
            width: 210,
            decoration: BoxDecoration(
              color: Get.find<AppController>().isMan.value == 0
                  ? Get.theme.primaryColor
                  : Get.theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: Get.find<AppController>().statueVal.value == 2
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Get.find<AppController>().statueVal.value == 2
                            ? "حالتك مشغول الآن"
                            : "حالتك متصل الآن",
                        style: Get.textTheme.subtitle1!.copyWith(
                            color: AppTheme.WHITE,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      changeStatue(context);
                    },
                    child: Text(
                      "changeStatus".tr,
                      style: Get.textTheme.subtitle1!.copyWith(
                          color: Get.find<AppController>().isMan.value == 0
                              ? Get.theme.colorScheme.secondary
                              : Get.theme.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void changeStatue(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var statue = Get.find<AppController>().statueVal.value;
      if (statue == 1) {
        changeColorOfStatue(context, 2);
      } else {
        changeColorOfStatue(context, 1);
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }
  }

  changeColorOfStatue(context, colorId) {
    Get.find<AppController>().statueVal(colorId).obs;
    Get.find<HomeController>().changeStatue(colorId, context);
    Get.find<AppController>().saveStatue(colorId);
  }
}
