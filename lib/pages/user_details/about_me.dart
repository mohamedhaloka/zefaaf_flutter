import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/user_details/user_details.controller.dart';
import 'package:zeffaf/utils/theme.dart';

class AboutMe extends GetView<UserDetailsController> {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "aboutMe".tr,
              style: Get.textTheme.caption!.copyWith(
                color: controller.appController.isMan.value == 0
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
          Obx(() => InkWell(
                onTap: () {
                  Get.dialog(showMoreWord(
                      "aboutMe".tr,
                      controller.user.value.aboutMe == ""
                          ? ""
                          : "${controller.user.value.aboutMe}"));
                },
                child: Text(
                  controller.loading.value
                      ? ""
                      : controller.user.value.aboutMe == ""
                          ? ""
                          : "${controller.user.value.aboutMe}",
                  style: Get.textTheme.caption!.copyWith(
                      color: controller.appController.isMan.value == 0
                          ? AppTheme.WHITE
                          : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }

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
}
