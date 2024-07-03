import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/theme.dart';

class UserImage extends StatelessWidget {
  final String? image;
  final int isLive;
  final int isPremium;
  final int? notifyType;

  bool get isAdmin => notifyType == 0 || notifyType == 12;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Get.find<AppController>().isMan.value == 0
                    ? Get.theme.colorScheme.secondary
                    : Get.theme.primaryColor,
                image: DecorationImage(
                    image: isAdmin
                        ? const AssetImage("assets/images/admin_icon.png")
                        : image == null || image == ""
                            ? AssetImage(Get.find<AppController>()
                                        .isMan
                                        .value ==
                                    0
                                ? "assets/images/register_landing/female.png"
                                : "assets/images/register_landing/male.png")
                            : NetworkImage(
                                    "https://zefaafapi.com/uploadFolder/small/$image")
                                as ImageProvider,
                    fit: BoxFit.cover)),
          ),
          if (isLive == 0 || isLive == 1 || isLive == 2)
            Container(
              width: isPremium == 0 || isPremium == 6 ? 15 : 22,
              height: isPremium == 0 || isPremium == 6 ? 15 : 22,
              decoration: BoxDecoration(
                  color: isAdmin
                      ? AppTheme.GREEN
                      : isLive == 2
                          ? Colors.red
                          : isLive == 1
                              ? AppTheme.GREEN
                              : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1)),
              child: Get.find<AppController>().isMan.value == 0 &&
                      (isPremium == 7)
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(
                        "assets/images/home/crown.png",
                        height: 13,
                        width: 13,
                      ),
                    )
                  : Get.find<AppController>().isMan.value == 1 &&
                          (isPremium == 1 || isPremium == 2 || isPremium == 3)
                      ? const Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.amber,
                        )
                      : Get.find<AppController>().isMan.value == 1 &&
                              isPremium == 4
                          ? Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset(
                                "assets/images/platinum.png",
                                height: 13,
                                width: 13,
                              ),
                            )
                          : Get.find<AppController>().isMan.value == 1 &&
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
        ],
      ),
    );
  }

  const UserImage(this.image,
      {required this.isLive, required this.isPremium, this.notifyType});
}
