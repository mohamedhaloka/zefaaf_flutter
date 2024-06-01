import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/myAccount/myAccount.controller.dart';

class TempPhoto extends GetView<AppController> {
  const TempPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => (controller.userData.value.tempProfileImage ?? ''.obs).value == ''
            ? const SizedBox()
            : Center(
                child: Padding(
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
                          Text(
                            "صورتك بإنتظار الموافقة",
                            style: Get.textTheme.subtitle1!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              final myAccountController =
                                  Get.find<MyAccountController>();
                              myAccountController.deleteProfilePhotoDialog();
                            },
                            child: Text(
                              "حذف الصورة",
                              style: Get.textTheme.subtitle1!.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
