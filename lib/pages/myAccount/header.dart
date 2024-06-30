import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/confirm.new.password/view.dart';
import 'package:zeffaf/pages/myAccount/temp_photo.dart';
import 'package:zeffaf/pages/packages/view.dart';
import 'package:zeffaf/pages/settings/settings.provider.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';

import '../../utils/upgrade_package_dialog.dart';
import '../../widgets/home_header/image_action.dart';
import '../../widgets/home_header/user_status.dart';
import 'myAccount.controller.dart';

class AccountHeader extends GetView<AppController> {
  const AccountHeader(this.myAccountController, {super.key});
  final MyAccountController myAccountController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          UserStatus(),
          const TempPhoto(),
          ImageAction(
            controller.userData.value.profileImage ?? ''.obs,
            controller.userData.value.packageLevel! <= 1
                ? InkWell(
                    onTap: () => Get.to(() => Packages()),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black26, shape: BoxShape.circle),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/home/tabs/more.svg",
                              color: Get.theme.primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "upgradeToUpload".tr,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyText2!.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            controller.statueVal.value,
            controller.userData.value.packageLevel!,
            controller,
            false,
            true,
            uploadImageLoading: myAccountController.uploadImgLoading,
            onChooseImage: () {
              if (controller.userData.value.packageLevel! <= 1) {
                showUpgradePackageDialog(controller.isMan.value == 0);
                return;
              }
              myAccountController.getImage().then((image) async {
                if (image != null) {
                  myAccountController.uploadMyPhoto(image, context);
                }
              });
            },
            deleteImage: myAccountController.deleteProfilePhotoDialog,
            fileName: myAccountController.fileName,
          ),
          const SizedBox(height: 6),
          Text(
            controller.userData.value.userName ?? '',
            style: Get.textTheme.subtitle1!.copyWith(
              color:
                  controller.isMan.value == 0 ? AppTheme.WHITE : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          controller.userData.value.isFreePlan
              ? const SizedBox(height: 5)
              : Text(
                  " صلاحية الباقة حتى ${DateFormat.yMMMd().format(controller.userData.value.packageRenewDate!)}",
                  style: Get.textTheme.caption!.copyWith(
                    color: Get.find<AppController>().isMan.value == 0
                        ? Get.theme.colorScheme.secondary
                        : Get.theme.primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
          controller.userData.value.isFreePlan
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "أنت الان على الباقة المجانية",
                      style: Get.textTheme.caption!.copyWith(
                        color: AppTheme.WHITE,
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 2),
                    InkWell(
                      onTap: () => Get.toNamed("/packages"),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Get.find<AppController>().isMan.value == 0
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
                  ],
                )
              : const SizedBox(height: 8),
          buttons(context),
          aboutMe(controller),
        ],
      ),
    );
  }

  Widget buttons(context) => SizedBox(
        height: 45,
        width: Get.mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: CustomRaisedButton(
                height: 35,
                tittle: "changePassword".tr,
                onPress: () {
                  Get.to(() => ConfirmNewPasswordView(changePassword: 1));
                },
                color: controller.isMan.value == 0
                    ? Get.theme.colorScheme.secondary
                    : Get.theme.primaryColor,
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomRaisedButton(
                          height: 35,
                          tittle: "تعديل الحساب",
                          onPress: () {
                            final bool isMan = controller.isMan.value == 0;
                            final int premium =
                                controller.userData.value.packageLevel ?? 0;

                            if (isMan && premium == 0) {
                              showUpgradePackageDialog(
                                  isMan, shouldUpgradeToDiamondPackage);
                              return;
                            }

                            if (!isMan && premium == 6) {
                              showUpgradePackageDialog(
                                  isMan, shouldUpgradeToFlowerPackage);
                              return;
                            }

                            Get.toNamed('/EditAccount');
                          },
                          color: Colors.green,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SvgPicture.asset(
                            'assets/images/new.svg',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomRaisedButton(
                    height: 35,
                    tittle: "حذف حسابي",
                    onPress: () {
                      Get.dialog(dialogTerminateMyAccount(context));
                    },
                    color: Colors.red),
              ),
            ],
          ),
        ),
      );

  aboutMe(AppController controller) => Padding(
        padding: const EdgeInsets.fromLTRB(23, 14, 23, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "aboutMe".tr,
                style: Get.textTheme.caption!.copyWith(
                  color: controller.isMan.value == 0
                      ? AppTheme.WHITE
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            InkWell(
              onTap: () {
                Get.dialog(
                    showMoreWord('عن نفسي', controller.userData.value.aboutMe));
              },
              child: Text(
                controller.userData.value.aboutMe ?? '',
                style: Get.textTheme.caption!.copyWith(
                    color: controller.isMan.value == 0
                        ? AppTheme.WHITE
                        : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget showMoreWord(tittle, subTittle) {
    return AlertDialog(
      backgroundColor: Colors.black54,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$tittle",
            style: Get.textTheme.bodyText2!.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.red,
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      scrollable: true,
      content: Text(
        "$subTittle",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget dialogTerminateMyAccount(context) {
    return AlertDialog(
      backgroundColor: Colors.black54,
      title: Text(
        "هل تود حقاً حذف الحساب؟",
        style: Get.textTheme.bodyText2!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.find<MyAccountController>().terminateMyAccount().then((value) {
              if (value) {
                FirebaseAuth auth = FirebaseAuth.instance;
                var fontSize =
                    Provider.of<ChangeFontSize>(context, listen: false);
                controller.logOut();
                auth.signOut();
                controller.changeThemeMode(false);
                controller.updateGender(null);
                controller.changeNotificationOpenDate("");
                controller.notificationOpenDate.value = "";
                fontSize.changeSize(0.0);
                controller.changeFontSize(fontSize.fontSize);
                DynamicTheme.of(context)!.setTheme(0);
              } else {}
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
          child: const Text(
            "نعم",
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            Get.back();
          },
          child: const Text("لا", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
