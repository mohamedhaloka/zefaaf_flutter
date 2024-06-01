import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/more/more.controller.dart';
import 'package:zeffaf/pages/myAccount/myAccount.view.dart';
import 'package:zeffaf/utils/theme.dart';

import '../../utils/upgrade_package_dialog.dart';

class ImageAction extends StatelessWidget {
  final RxString image;
  final int isLive;
  final int isPremium;
  final Widget center;
  final AppController controller;
  final bool visible;
  final bool isClickable;
  final RxBool? uploadImageLoading;
  final RxString? fileName;
  final void Function()? onChooseImage, deleteImage;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: visible,
              child: SizedBox(
                height: 35,
                width: 35,
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180),
                  ),
                  fillColor: controller.isMan.value == 0
                      ? Get.theme.colorScheme.secondary
                      : Get.theme.primaryColor,
                  child: SvgPicture.asset(
                    "assets/images/pen.svg",
                    color: AppTheme.WHITE,
                  ),
                  onPressed: () {
                    Get.to(() => const MyAccount(true));
                  },
                ),
              ),
            ),
            InkWell(
              onTap: isClickable
                  ? null
                  : () => Get.to(() => const MyAccount(true)),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  //Loa
                  (uploadImageLoading ?? false.obs).value
                      ? Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Get.theme.colorScheme.secondary),
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator())
                      : Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Get.theme.colorScheme.secondary),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: image.value == "" &&
                                        (fileName ?? ''.obs).value == ""
                                    ? ExactAssetImage(controller.isMan.value ==
                                            0
                                        ? "assets/images/register_landing/male.png"
                                        : "assets/images/register_landing/female.png")
                                    : NetworkImage(
                                            "https://zefaafapi.com/uploadFolder/small/${image.value}")
                                        as ImageProvider,
                                fit: BoxFit.cover),
                          ),
                          child: center),
                  if (isClickable)
                    Positioned(
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            if (isPremium <= 1) {
                              showUpgradePackageDialog(
                                  shouldUpgradeToSilverPackage);
                              return;
                            }
                            // if (isPremium == 0) return;
                            onChooseImage!();
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                              color: controller.isMan.value == 0
                                  ? Get.theme.primaryColor
                                  : Get.theme.colorScheme.secondary,
                            ),
                          ),
                        )),
                  if (isLive == 0 || isLive == 1 || isLive == 2)
                    Positioned(
                      top: isPremium == 0 ? 6 : 3,
                      right: isPremium == 0 ? 10 : 3,
                      child: Container(
                        width: isPremium == 0 ? 15 : 22,
                        height: isPremium == 0 ? 15 : 22,
                        decoration: BoxDecoration(
                          color: isLive == 2 ? Colors.red : AppTheme.GREEN,
                          shape: BoxShape.circle,
                        ),
                        child: controller.isMan.value == 1 && isPremium != 0
                            ? Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.asset(
                                  "assets/images/home/crown.png",
                                  height: 13,
                                  width: 13,
                                ),
                              )
                            : controller.isMan.value == 0 &&
                                    (isPremium == 1 ||
                                        isPremium == 2 ||
                                        isPremium == 3)
                                ? const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  )
                                : controller.isMan.value == 0 && isPremium == 4
                                    ? Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                          "assets/images/platinum.png",
                                          height: 13,
                                          width: 13,
                                        ),
                                      )
                                    : controller.isMan.value == 0 &&
                                            isPremium == 5
                                        ? Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Image.asset(
                                              "assets/images/diamond.png",
                                              height: 13,
                                              width: 13,
                                            ),
                                          )
                                        : const SizedBox(),
                      ),
                    ),
                  if (isClickable)
                    Positioned(
                      left: 4,
                      top: 4,
                      child: Tooltip(
                        message: 'حذف الصورة',
                        child: image.value == ''
                            ? const SizedBox()
                            : InkWell(
                                onTap: deleteImage,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red[700],
                                  radius: 10.5,
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                )),
                      ),
                    )
                ],
              ),
            ),
            Visibility(
              visible: visible,
              child: SizedBox(
                height: 35,
                width: 35,
                child: RawMaterialButton(
                  fillColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180),
                  ),
                  child: Image.asset(
                    "assets/images/more-menu/power.png",
                    width: 20,
                    color: Colors.white,
                  ),
                  onPressed: () async =>
                      Get.put(MoreController()).logOut(context),
                ),
              ),
            ),
          ],
        ));
  }

  const ImageAction(this.image, this.center, this.isLive, this.isPremium,
      this.controller, this.visible, this.isClickable,
      {super.key,
      this.fileName,
      this.onChooseImage,
      this.deleteImage,
      this.uploadImageLoading});
}
