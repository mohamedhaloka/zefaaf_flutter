import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/theme.dart';

import '../../widgets/home_header/actions.dart';
import '../../widgets/home_header/image_action.dart';
import '../../widgets/home_header/user_status.dart';

class HomeHeader extends GetView<AppController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserStatus(),
            ImageAction(
                controller.userData.value.profileImage ?? ''.obs,
                Container(),
                Get.find<AppController>().statueVal.value,
                controller.userData.value.packageLevel ?? 0,
                controller,
                true,
                false),
            const SizedBox(
              height: 4,
            ),
            Text(
              controller.userData.value.userName.toString(),
              style: Get.textTheme.titleMedium!.copyWith(
                color:
                    controller.isMan.value == 0 ? AppTheme.WHITE : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            controller.userData.value.premium == 0
                ? const SizedBox(height: 10)
                : Text(
                    " صلاحية الباقة حتى ${DateFormat.yMMMd().format(controller.userData.value.packageRenewDate!)} ",
                    style: Get.textTheme.caption!.copyWith(
                        color: Get.find<AppController>().isMan.value == 0
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 10),
                  ),
            controller.userData.value.premium == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "أنت حالياً على الباقة المجانية ",
                        style: Get.textTheme.caption!.copyWith(
                          color: AppTheme.WHITE,
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed("/packages");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: controller.isMan.value == 0
                                ? Get.theme.colorScheme.secondary
                                : Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "upgrade".tr,
                            style: Get.textTheme.caption!.copyWith(
                              color: AppTheme.WHITE,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  )
                : const SizedBox(height: 22),
            const AccountActions(),
          ],
        ),
      ),
    );
  }
}
