import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/chat.details/view.dart';
import 'package:zeffaf/pages/packages/view.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_icon_button.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';

import '../../utils/toast.dart';
import '../../utils/upgrade_package_dialog.dart';
import 'about_me.dart';
import 'image.dart';
import 'user_details.controller.dart';

class AccountHeader extends GetView<UserDetailsController> {
  AccountHeader(
      {required this.userId,
      required this.userDetails,
      required this.inChatRoom});
  int userId;
  bool inChatRoom;
  User userDetails;
  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 23,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: controller.loading.value
                        ? Text(
                            "آخر ظهور منذ ",
                            style: Get.textTheme.caption!
                                .copyWith(color: Colors.white, fontSize: 12),
                          )
                        : controller.user.value.available == 0
                            ? Text(
                                "آخر ظهور ${DateTimeUtil.convertTimeWithDate(controller.user.value.lastAccess.toString())}",
                                style: Get.textTheme.caption!.copyWith(
                                    color: Colors.white, fontSize: 12),
                              )
                            : Text(
                                "متصل الآن",
                                style: Get.textTheme.caption!.copyWith(
                                    color: Colors.white, fontSize: 12),
                              )),
              ),
              const SizedBox(width: 30),
              ImageAction(
                  controller.user.value,
                  controller.user.value.userImage ?? '',
                  controller.user.value.allowImage != "1" ||
                          controller
                                  .appController.userData.value.packageLevel! <=
                              1
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(180),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: controller.appController.userData.value
                                          .packageLevel! <=
                                      1
                                  ? InkWell(
                                      onTap: () {
                                        Get.to(() => Packages());
                                      },
                                      child: const Text(
                                        'لطلب عرض الصورة قم بالترقية للفضية',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ))
                                  : (controller.user.value.allowImage == "0" &&
                                          controller.user.value.requestImage ==
                                              "1")
                                      ? const Text(
                                          'في إنتظار الموافقة لعرض الصورة',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        )
                                      : (controller.user.value.allowImage ==
                                                  "0" &&
                                              controller.user.value
                                                      .requestImage ==
                                                  "0")
                                          ? CustomRaisedButton(
                                              height: 23,
                                              fontSize: 9,
                                              color: Colors.black54,
                                              tittle: controller.user.value
                                                          .allowImage ==
                                                      "1"
                                                  ? "إلغاء طلب الصورة"
                                                  : "requestImage".tr,
                                              onPress: controller.loading.value
                                                  ? null
                                                  : controller.user.value
                                                              .allowImage ==
                                                          "1"
                                                      ? () {
                                                          removeInList(
                                                              context: context,
                                                              listId: 2,
                                                              toastTittle:
                                                                  "تم إلغاء طلب عرض الصورة",
                                                              valIn: () =>
                                                                  controller
                                                                      .user
                                                                      .value
                                                                      .allowImage ==
                                                                  "0",
                                                              valOut: () {});
                                                        }
                                                      : () {
                                                          requestPhoto(context);
                                                        },
                                            )
                                          : Container(),
                            ),
                          ),
                        )
                      : Container(),
                  controller.user.value.available ?? 0,
                  controller.user.value.packageLevel ?? 0,
                  controller.loading.value, () async {
                await controller.cancelRequestPhoto(userId, context);
                userDetails.allowImage = '0';
                userDetails.requestImage = '0';
              }),
              controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Text(
                          "${controller.user.value.userName}",
                          style: Get.textTheme.headline4!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: controller.appController.isMan.value == 0
                                  ? AppTheme.WHITE
                                  : Colors.black),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "تاريخ التسجيل "
                          "${DateTimeUtil.convertDate(controller.user.value.creationDate.toString())}",
                          style: Get.textTheme.caption!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: controller.appController.isMan.value == 0
                                  ? AppTheme.WHITE
                                  : Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color:
                                      controller.appController.isMan.value == 0
                                          ? AppTheme.LIGHT_GREY
                                          : Colors.black,
                                  size: 14,
                                ),
                                Text(
                                  "${controller.user.value.cityName}",
                                  style: Get.textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: controller
                                                  .appController.isMan.value ==
                                              0
                                          ? AppTheme.WHITE
                                          : Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text("|",
                                style: Get.textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        controller.appController.isMan.value ==
                                                0
                                            ? AppTheme.WHITE
                                            : Colors.black)),
                            const SizedBox(
                              width: 6,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: controller.user.value.gender == 0
                                          ? getUserData(
                                              InputData.socialStatusManList,
                                              controller.user.value
                                                      .mariageStatues ??
                                                  0,
                                              InputData.socialStatusManListId)
                                          : getUserData(
                                              InputData.socialStatusWomanList,
                                              controller.user.value
                                                      .mariageStatues ??
                                                  0,
                                              InputData
                                                  .socialStatusWomanListId)),
                                  const TextSpan(text: "/"),
                                  TextSpan(text: "age".tr),
                                  TextSpan(
                                      text: " ${controller.user.value.age}"),
                                ],
                                style: Get.textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      controller.appController.isMan.value == 0
                                          ? AppTheme.WHITE
                                          : Colors.black,
                                ),
                              ),
                              style: Get.textTheme.caption!.copyWith(
                                  color:
                                      controller.appController.isMan.value == 0
                                          ? AppTheme.WHITE
                                          : Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 12,
              ),
              buttons(context),
              const AboutMe(),
            ],
          ),
        ));
  }

  buttons(context) => SizedBox(
        height: 70,
        width: Get.mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: CustomRaisedIconButton(
                    height: 35,
                    fontSize: 10,
                    asset: "assets/images/home/tabs/favorite.svg",
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.colorScheme.secondary
                        : Get.theme.primaryColor,
                    tittle: controller.user.value.interestList == "1"
                        ? "إلغاء الإعجاب"
                        : "إعجاب",
                    onPress: controller.loading.value
                        ? null
                        : controller.appController.userData.value.premium == 0
                            ? () => showToast('يجب ترقية حسابك أولاً')
                            : controller.user.value.interestList == "1"
                                ? () {
                                    removeInList(
                                        context: context,
                                        toastTittle:
                                            "تمت الإزالة من قائمة المعجبين",
                                        listId: 1,
                                        valIn: () => controller
                                            .user.value.interestList = "0",
                                        valOut: () => controller
                                            .user.value.ignoreList = "0");
                                  }
                                : () {
                                    addToList(
                                        context: context,
                                        toastTittle:
                                            "تمت الإضافة إلى قائمة المعجبين",
                                        listId: 1,
                                        valIn: () {
                                          controller.user.value.interestList =
                                              "1";
                                        },
                                        valOut: () => controller
                                            .user.value.ignoreList = "0");
                                  },
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomRaisedIconButton(
                      height: 35,
                      fontSize: 10,
                      tittle: controller.user.value.ignoreList == "1"
                          ? "إلغاء التجاهل"
                          : "تجاهل",
                      icon: Icons.not_interested,
                      onPress: controller.loading.value
                          ? null
                          : controller.appController.userData.value.premium == 0
                              ? () => showToast('يجب ترقية حسابك أولاً')
                              : controller.user.value.ignoreList == "1"
                                  ? () {
                                      removeInList(
                                        context: context,
                                        listId: 0,
                                        toastTittle:
                                            "تمت إزالة المستخدم من قائمة المحظورين",
                                        valIn: () => controller
                                            .user.value.ignoreList = "0",
                                        valOut: () => controller
                                            .user.value.interestList = "0",
                                      );
                                    }
                                  : () {
                                      addToList(
                                          context: context,
                                          toastTittle:
                                              "تمت الإضافة لقائمة المحظورين",
                                          listId: 0,
                                          valIn: () => controller
                                              .user.value.ignoreList = "1",
                                          valOut: () => controller
                                              .user.value.interestList = "0");
                                    },
                      color: controller.appController.isMan.value == 0
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: CustomRaisedIconButton(
                    fontSize: 10,
                    height: 35,
                    icon: Icons.chat,
                    tittle: "chat".tr,
                    onPress: controller.loading.value
                        ? null
                        : inChatRoom
                            ? null
                            : () async {
                                final String? message = await controller
                                    .checkAvailabilityOfChatting(
                                        controller.user.value.id.toString());
                                if (message == null) {
                                  Get.to(() => ChatDetails(
                                      otherId: userId,
                                      isBackToChatList: false,
                                      inUserDetails: true));
                                  return;
                                }
                                showUpgradePackageDialog(
                                    controller.appController.isMan.value == 0,
                                    message);
                              },
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary,
                  )),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      );

  removeInList(
      {context,
      required Function valIn,
      required Function valOut,
      toastTittle,
      listId}) {
    controller
        .removeFromList(controller.user.value.id, listId, context)
        .then((value) {
      if (value == 1) {
        valIn();
        valOut();
        controller.loading(false);
        showToast(
          "$toastTittle",
        );
      } else {
        controller.loading(false);
        showToast(
          "يرجى التأكد من إتصالك بالإنترنت والإعادة مرة أخرى",
        );
      }
    });
  }

  addToList({context, valIn, valOut, toastTittle, listId}) {
    controller
        .addToList(controller.user.value.id, listId, context)
        .then((value) {
      if (value == 1) {
        valIn();
        valOut();
        controller.loading(false);
        showToast("$toastTittle");
      } else {
        controller.loading(false);
      }
    });
  }

  requestPhoto(context) {
    if (controller.appController.userData.value.packageLevel! <= 1) {
      showUpgradePackageDialog(controller.appController.isMan.value == 0);
      return;
    }
    controller
        .requestPhoto(controller.user.value.id.toString(), context)
        .then((value) {
      if (value == 1) {
        showToast("تم طلب عرض الصورة");
        controller.user.value.allowImage = "0";
        controller.user.value.requestImage = "1";
        controller.loading(false);
      } else {
        controller.loading(false);
      }
    });
  }

  getUserData(List list, int dataSource, List listId) {
    try {
      // print("Data Source: $dataSource");
      var index = listId.indexOf(dataSource);
      // print("Index of ListID: $index");
      var data = list.elementAt(index);
      // print("List ${list.elementAt(index)}");
      return data.toString();
    } catch (_) {}
  }
}
