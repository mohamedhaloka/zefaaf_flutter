import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/notifications/notifications.view.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/utils/toast.dart';
import 'package:zeffaf/utils/upgrade_package_dialog.dart';

class AccountActions extends GetView<AppController> {
  const AccountActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        width: Get.mediaQuery.size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            action("طلبات الزواج", null, controller.newMessages.value,
                () => Get.toNamed('/AppMessageView'),
                imagePath: 'assets/images/more-menu/contact-us.png'),
            buildDrawer,
            action(
              "طلبات الهواتف".tr,
              null,
              controller.userData.value.packageMobileRequestLimit,
              () {
                final packageLevel =
                    controller.userData.value.packageLevel ?? 0;
                final isMan = controller.isMan.value == 0;
                final mobileRequest =
                    controller.userData.value.packageMobileRequestLimit ?? 9;
                if (packageLevel == 0 && isMan) {
                  showUpgradePackageDialog(
                    isMan,
                    shouldUpgradeToGetPhoneNumberFeatured,
                  );
                  return;
                }
                if (packageLevel == 6 && !isMan) {
                  showUpgradePackageDialog(
                    isMan,
                    shouldUpgradeToFlowerToGet60NumberPackage,
                  );
                  return;
                }

                if (mobileRequest == 0) {
                  showUpgradePackageDialog(
                    isMan,
                    isMan
                        ? 'بلغت الحد المسموح به من الأرقام'
                        : 'بلغتي الحد المسموح به من الأرقام',
                  );
                  return;
                }

                final packageMaxPhoneRequestsOrders =
                    packageMaxPhoneRequests == 1
                        ? 'طلب'
                        : packageMaxPhoneRequests == 2
                            ? 'طلبان'
                            : packageMaxPhoneRequests <= 10
                                ? 'طلبات'
                                : 'طلب';

                showToast(
                  'متبقي لك $mobileRequest $packageMaxPhoneRequestsOrders لرقم الهاتف من $packageMaxPhoneRequests خلال هذا الشهر',
                );
              },
              imagePath: controller.isMan.value == 0
                  ? 'assets/images/man_requested_phone.jpeg'
                  : 'assets/images/woman_requested_phone.jpeg',
              withCircleBox: false,
              showNumberDirect: true,
            ),
            buildDrawer,
            action("شاهدوا حسابي".tr, Icons.visibility_rounded,
                int.parse(controller.newViews.value), () async {
              Get.to(() => const Notifications(
                    activeIndex: 3,
                    notification: "1",
                    notInTab: true,
                  ));
            }),
            buildDrawer,
            action("admiredMe".tr, Icons.favorite,
                int.parse(controller.newInterest.value), () {
              Get.to(() => const Notifications(
                    activeIndex: 4,
                    notInTab: true,
                    notification: "2",
                  ));
            }),
            // buildDrawer,
            // action("topicsForRead".tr, Icons.person, controller.newPosts.value,
            //     () {
            //   Get.toNamed('/Posts');
            // }),
          ],
        ),
      ),
    );
  }

  int get packageMaxPhoneRequests {
    switch (controller.userData.value.packageLevel) {
      case 5:
      case 7:
        return 60;
      case 4:
      case 3:
      case 2:
        return 30;
      case 1:
        return 7;
      default:
        return 0;
    }
  }

  Widget get buildDrawer => const RotatedBox(
        quarterTurns: 3,
        child: Divider(
          color: Colors.white,
          height: 0,
          thickness: 1,
        ),
      );

  Widget action(
    String title,
    IconData? icon,
    number,
    Function onTap, {
    String? imagePath,
    bool withCircleBox = true,
    bool showNumberDirect = false,
  }) {
    return SizedBox(
      width: Get.width * 0.23,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon == null && !withCircleBox) ...[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Image.asset(
                  imagePath ?? '',
                  height: 29,
                  width: 29,
                ),
              )
            ] else ...[
              Container(
                height: 29,
                width: 29,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isMan.value == 1
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.secondary,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: icon == null
                      ? Image.asset(
                          imagePath ?? '',
                        )
                      : Icon(
                          icon,
                          size: 20,
                          color: AppTheme.WHITE,
                        ),
                ),
              ),
            ],
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showNumberDirect
                      ? number.toString()
                      : number == 0
                          ? number.toString()
                          : number >= 10
                              ? number.toString()
                              : "0${number.toString()}",
                  maxLines: 1,
                  style: Get.textTheme.bodyText2!.copyWith(
                      height: 0.8,
                      color: controller.isMan.value == 0
                          ? AppTheme.WHITE
                          : Colors.black,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  style: Get.textTheme.caption!.copyWith(
                    height: 0.8,
                    color: controller.isMan.value == 0
                        ? AppTheme.WHITE
                        : Colors.black,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
