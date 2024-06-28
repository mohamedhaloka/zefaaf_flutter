import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/pages/favorites/favorites.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';

import '../../utils/toast.dart';
import '../../utils/upgrade_package_dialog.dart';
import 'header.dart';
import 'user_details.controller.dart';

class UserDetails extends GetView<UserDetailsController> {
  UserDetails(
      {super.key,
      this.userId,
      this.listType,
      required this.isFavourite,
      this.inChatRoom = false});
  final int? userId;
  final int? listType;
  final bool inChatRoom;
  final bool isFavourite;
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());
  @override
  Widget build(context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return MixinBuilder<UserDetailsController>(
      init: UserDetailsController(),
      initState: (_) {
        controller.loading(true);
        controller.getUserDetails(userId, context);
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            isFavourite ? onWillPOP() : Get.back();
            return true;
          },
          child: Scaffold(
            primary: false,
            extendBodyBehindAppBar: true,
            body: BaseAppHeader(
              headerLength: 440,
              position:
                  statusBarHeight > 50.0 ? Get.height / 7.5 : Get.height / 10.5,
              refresh: () {
                controller.getUserDetails(userId, context);
              },
              actions: [
                controller.appController.userData.value.premium == 0
                    ? const SizedBox()
                    : controller.loadingReplyPhoto.value
                        ? const SizedBox()
                        : controller.user.value.requestMyImage == "0" &&
                                controller.user.value.viewMyImage == "0"
                            ? const SizedBox()
                            : buildIconRequestImage(
                                context: context,
                                viewMyImage: controller.user.value.viewMyImage,
                                requestMyImage:
                                    controller.user.value.requestMyImage),
                controller.appController.userData.value.premium == 0
                    ? const SizedBox()
                    : controller.loadingReplyPhoto.value
                        ? const SizedBox()
                        : controller.user.value.requestMyMobile == "0" &&
                                controller.user.value.viewMyMobile == "0"
                            ? const SizedBox()
                            : buildIconRequestMobile(
                                context: context,
                                viewMyMobile:
                                    controller.user.value.viewMyMobile,
                                requestMyMobile:
                                    controller.user.value.requestMyMobile),
                IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: isFavourite
                        ? onWillPOP
                        : () {
                            Get.back();
                          }),
              ],
              // leading: Container(
              //   margin: const EdgeInsets.all(4),
              //   child: CustomRaisedButton(
              //     color: Get.theme.errorColor,
              //     tittle: "complain".tr,
              //     padding: 0,
              //     fontSize: 14,
              //     width: 50,
              //     onPress: controller.loading.value
              //         ? null
              //         : () {
              //             Get.to(NewMessage(
              //               complaint: true,
              //               otherId: controller.user.value.id.toString(),
              //               packageId: controller.user.value.packageId.toString(),
              //             ));
              //           },
              //   ),
              // ),
              body: AccountHeader(
                  userId: userId!,
                  userDetails: controller.user.value,
                  inChatRoom: inChatRoom),
              children: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      section([
                        dataList(
                          "رقم الهاتف".tr,
                          (controller.user.value.allowMobile == "0" &&
                                  controller.user.value.requestMobile == "1")
                              ? 'بإنتظار الموافقة على عرض الرقم'
                              : controller.user.value.allowMobile != "0"
                                  ? controller.user.value.mobile ?? ''
                                  : '',
                          lightMode,
                          onTap: controller.user.value.allowMobile != "0"
                              ? () {
                                  launchUrl(Uri.parse(
                                      'tel:${controller.user.value.mobile}'));
                                }
                              : null,
                          button:
                              // controller.appController.userData.value
                              //                 .packageLevel! <=
                              //             3 ||

                              (controller.user.value.allowMobile == "0" &&
                                      controller.user.value.requestMobile ==
                                          "0")
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: controller
                                                      .appController
                                                      .isMan
                                                      .value ==
                                                  0
                                              ? Get.theme.primaryColor
                                              : Get
                                                  .theme.colorScheme.secondary),
                                      onPressed: controller.loading.value
                                          ? null
                                          :
                                          // controller.user.value.allowMobile == "1"
                                          //         ? () async {
                                          //             if (controller.appController.isMan
                                          //                         .value ==
                                          //                     0 &&
                                          //                 controller
                                          //                         .appController
                                          //                         .userData
                                          //                         .value
                                          //                         .premium ==
                                          //                     0) {
                                          //               showUpgradePackageDialog(
                                          //                   shouldUpgradeToPlatinumPackage);
                                          //               return;
                                          //             }
                                          //
                                          //             if (controller.appController.isMan
                                          //                         .value ==
                                          //                     1 &&
                                          //                 controller
                                          //                         .appController
                                          //                         .userData
                                          //                         .value
                                          //                         .premium ==
                                          //                     11) {
                                          //               showUpgradePackageDialog(
                                          //                   shouldUpgradeToFlowerPackage);
                                          //               return;
                                          //             }
                                          //
                                          //             await controller
                                          //                 .cancelRequestMobile(
                                          //                     userId, context);
                                          //             if (!context.mounted) return;
                                          //             await controller.getUserDetails(
                                          //                 userId, context);
                                          //             controller.loading(false);
                                          //           }
                                          //         :
                                          () async {
                                              final bool isMan = controller
                                                      .appController
                                                      .isMan
                                                      .value ==
                                                  0;
                                              final int currentUserPackageId =
                                                  controller
                                                          .appController
                                                          .userData
                                                          .value
                                                          .premium ??
                                                      0;
                                              final int
                                                  currentUserPackageLevel =
                                                  controller
                                                          .appController
                                                          .userData
                                                          .value
                                                          .packageLevel ??
                                                      0;
                                              if (isMan &&
                                                  currentUserPackageId == 0) {
                                                showUpgradePackageDialog(
                                                    controller.appController
                                                            .isMan.value ==
                                                        0,
                                                    shouldUpgradeToFeaturedPackage);
                                                return;
                                              }

                                              if (!isMan &&
                                                  currentUserPackageId == 11) {
                                                showUpgradePackageDialog(
                                                    controller.appController
                                                            .isMan.value ==
                                                        0,
                                                    shouldUpgradeToFlowerPackage);
                                                return;
                                              }

                                              switch (currentUserPackageLevel) {
                                                case 1:
                                                case 2:
                                                  if (controller.user.value
                                                          .mariageKind !=
                                                      5) {
                                                    thisFeatureAvailableFor(
                                                        'زوجة أولي فقط');
                                                    return;
                                                  }
                                                  break;
                                                case 3:
                                                  if (controller.user.value
                                                          .mariageKind !=
                                                      6) {
                                                    showToast('زوجة ثانية فقط');
                                                    return;
                                                  }
                                                  break;
                                                case 4:
                                                  if (controller.user.value
                                                          .mariageKind !=
                                                      184) {
                                                    showToast('زواج تعدد فقط');
                                                    return;
                                                  }
                                                  break;
                                                default:
                                                  break;
                                              }

                                              await controller.requestMobile(
                                                  userId, context);
                                              if (!context.mounted) return;
                                              await controller.getUserDetails(
                                                  userId, context);
                                              controller.loading(false);
                                            },
                                      child: Row(
                                        children: [
                                          const Text(
                                            'طلب عرض رقم الهاتف',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Image.asset(
                                            'assets/images/mobile-request-icon.png',
                                            scale: 10,
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                          action: (controller.user.value.allowMobile == "0" &&
                                  controller.user.value.requestMobile == "1")
                              ? InkWell(
                                  onTap: () async {
                                    await controller.cancelRequestMobile(
                                        userId, context);
                                    await controller.getUserDetails(
                                        userId, context);
                                    controller.loading(false);
                                  },
                                  child: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          textColor: controller.appController.isMan.value == 0
                              ? Get.theme.colorScheme.secondary
                              : Get.theme.primaryColor,
                        ),
                        //controller.user.value.allowMobile == '1'
                        //                               ? controller.user.value.mobile ?? ''
                        //                               : "${controller.user.value.nationalityCountryName}"
                        dataList(
                            "الجنسية".tr,
                            "${controller.user.value.nationalityCountryName}",
                            lightMode),
                        dataList(
                            "SelectedHome".tr,
                            "${controller.user.value.residentCountryName}",
                            lightMode),
                        dataList("المدينة".tr,
                            controller.user.value.cityName ?? '', lightMode),
                      ], "personalData".tr),
                      section([
                        dataList("age".tr, "${controller.user.value.age}",
                            lightMode),
                        dataList(
                            "socialStatus".tr,
                            controller.loading.value
                                ? ""
                                : controller.user.value.gender == 0
                                    ? getUserData(
                                        InputData.socialStatusManList,
                                        controller.user.value.mariageStatues ??
                                            0,
                                        InputData.socialStatusManListId)
                                    : getUserData(
                                        InputData.socialStatusWomanList,
                                        controller.user.value.mariageStatues ??
                                            0,
                                        InputData.socialStatusWomanListId),
                            lightMode),
                        dataList(
                            "MarriageType".tr,
                            getUserData(
                                InputData.kindOfMarriageList,
                                controller.user.value.mariageKind ?? 0,
                                InputData.kindOfMarriageListId),
                            lightMode),
                      ], "socialStatus".tr),
                      section([
                        dataList("weight".tr, "${controller.user.value.weight}",
                            lightMode),
                        dataList("length".tr, "${controller.user.value.height}",
                            lightMode),
                        dataList(
                            "SkinColor".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.skinColourList,
                                    controller.user.value.skinColor ?? 0,
                                    InputData.skinColourListId),
                            lightMode),
                        dataList(
                            "medicalStatus".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.healthStatusList,
                                    controller.user.value.helath ?? 0,
                                    InputData.healthStatusListId),
                            lightMode),
                      ], "physicalDes".tr),
                      section([
                        dataList(
                            "PrayLevel".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.prayList,
                                    controller.user.value.prayer ?? 0,
                                    InputData.prayListId),
                            lightMode),
                        dataList(
                            "veilLevel".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.barrierList,
                                    controller.user.value.veil ?? 0,
                                    InputData.barrierListId),
                            lightMode,
                            visible: controller.user.value.gender == 1
                                ? true
                                : false),
                        dataList(
                            "smoke".tr,
                            controller.user.value.smoking == 1 ? "نعم" : "لا",
                            lightMode),
                      ], "religious".tr),
                      section([
                        dataList(
                            "Collage".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.educationalQualificationList,
                                    controller.user.value.education ?? 0,
                                    InputData.educationalQualificationListId),
                            lightMode),
                        dataList(
                            "finance".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.financialStatusList,
                                    controller.user.value.financial ?? 0,
                                    InputData.financialStatusListId),
                            lightMode),
                        dataList(
                            "field".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.jobList,
                                    controller.user.value.workField ?? 0,
                                    InputData.jobListId),
                            lightMode),
                        dataList("job".tr, "${controller.user.value.job}",
                            lightMode),
                        dataList(
                            "intro".tr,
                            controller.loading.value
                                ? ""
                                : getUserData(
                                    InputData.monthlyIncomeLevelList,
                                    controller.user.value.income ?? 0,
                                    InputData.monthlyIncomeLevelListId),
                            lightMode),
                      ], "CollageAndWork".tr),
                      section([
                        dataList('', controller.user.value.aboutOther ?? '',
                            lightMode,
                            oneTitle: true),
                      ], "عن شريك الحياة")
                    ]),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  section(List<Widget> data, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              title,
              style: Get.textTheme.titleMedium!
                  .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.cardColor),
            child: Column(
              children: data,
            ),
          ),
        ],
      ),
    );
  }

  dataList(
    String title,
    String data,
    lightMode, {
    visible,
    bool oneTitle = false,
    Widget? button,
    Widget? action,
    Color? textColor,
    void Function()? onTap,
  }) {
    return Visibility(
      visible: visible ?? true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: oneTitle
            ? SizedBox(
                width: Get.width,
                child: Text(
                  data,
                  textAlign: TextAlign.right,
                  style: Get.textTheme.titleMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.titleMedium!
                        .copyWith(color: Colors.grey, fontSize: 14),
                  ),
                  controller.loading.value
                      ? SizedBox(
                          width: 80.0,
                          height: 20.0,
                          child: Shimmer.fromColors(
                            baseColor: lightMode
                                ? Colors.grey[100]!
                                : Colors.grey[700]!,
                            highlightColor: lightMode
                                ? Colors.grey[200]!
                                : Colors.grey[600]!,
                            child: Container(
                              color: lightMode
                                  ? Get.theme.scaffoldBackgroundColor
                                  : Colors.grey[900],
                            ),
                          ),
                        )
                      : button ??
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: onTap,
                                    child: Text(
                                      data,
                                      textAlign: TextAlign.left,
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: textColor ?? Colors.grey,
                                              fontSize: 14),
                                    ),
                                  ),
                                ),
                                if (action != null) ...[
                                  const SizedBox(width: 4),
                                  action,
                                ],
                              ],
                            ),
                          ),
                ],
              ),
      ),
    );
  }

  String getUserData(List list, int dataSource, List listId) {
    try {
      if (dataSource == 0) return '';
      var index = listId.indexOf(dataSource);
      var data = list.elementAt(index);
      return data.toString();
    } catch (e) {
      return '';
    }
  }

  void onWillPOP() {
    Get.find<FavoritesController>().loading(true);
    Get.back(
        result: Get.find<FavoritesController>()
            .getNetwork(listType, 0, true)
            .then((value) {
      Get.find<FavoritesController>().loading(false);
    }));
  }

  Widget buildIconRequestImage({
    Function? onPress,
    viewMyImage,
    context,
    requestMyImage,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4, top: 4),
      child: CustomRaisedButton(
        width: 120,
        color: controller.appController.isMan.value == 0
            ? Get.theme.colorScheme.secondary
            : Get.theme.primaryColor,
        tittle: viewMyImage == "1" && requestMyImage == "1"
            ? "إلغاء إظهار الصورة"
            : "أوافق على عرض الصورة",
        padding: 2,
        fontSize: 12,
        onPress: controller.loading.value
            ? null
            : viewMyImage == "1" && requestMyImage == "1"
                ? () {
                    controller
                        .replyPhoto(userId: userId, statues: "5")
                        .then((value) {
                      if (value == 1) {
                        controller.loadingReplyPhoto(false);
                        controller.user.value.viewMyImage = "0";
                        showToast("تم إلغاء عرض الصورة");
                      }
                    });
                  }
                : () {
                    controller
                        .replyPhoto(userId: userId, statues: "4")
                        .then((value) {
                      if (value == 1) {
                        controller.loadingReplyPhoto(false);
                        controller.user.value.requestMyImage = "1";
                        controller.user.value.viewMyImage = "1";
                        showToast("تمت الموافقة على عرض الصورة");
                      }
                    });
                  },
      ),
    );
  }

  Widget buildIconRequestMobile({
    Function? onPress,
    viewMyMobile,
    context,
    requestMyMobile,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4, top: 4),
      child: CustomRaisedButton(
        width: 120,
        color: controller.appController.isMan.value == 0
            ? Get.theme.colorScheme.secondary
            : Get.theme.primaryColor,
        tittle: viewMyMobile == "1" && requestMyMobile == "1"
            ? "إلغاء إظهار الهاتف"
            : "أوافق على إظهار الهاتف",
        padding: 2,
        fontSize: 12,
        onPress: controller.loading.value
            ? null
            : viewMyMobile == "1" && requestMyMobile == "1"
                ? () async {
                    await controller.replyRequestMobile(
                        userId: userId, statues: "5");
                    await controller.getUserDetails(userId, context);
                  }
                : () async {
                    await controller.replyRequestMobile(
                        userId: userId, statues: "4");
                    await controller.getUserDetails(userId, context);
                  },
      ),
    );
  }

  Widget buildRequestPhotoButtons({icon, color, onPress}) {
    return Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 10, right: 2),
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            border: Border.all(color: color), shape: BoxShape.circle),
        child: ElevatedButton(
          onPressed: () {
            Get.back();
            onPress();
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ));
  }
}
