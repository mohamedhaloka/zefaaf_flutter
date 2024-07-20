import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/technical_support/view.dart';
import 'package:zeffaf/utils/theme.dart';

import '../../models/newMessage.modal.dart';
import '../../services/http.service.dart';
import 'more.controller.dart';

final appSettings = Get.find<AppController>().appSetting;

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  Future getMessages() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    RxBool isConnectedToInternet = true.obs;
    final appController = Get.find<AppController>();

    isConnectedToInternet(false);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String url = "${Request.urlBase}getMessagesList";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken}'});
      if (response.statusCode == 200) {
        List<NewMessagesModal> newMessage = [];
        var data = json.decode(response.body)['data'];
        for (var message in data) {
          newMessage.add(NewMessagesModal.fromJson(message));
        }
        return newMessage;
      } else {}
    } else {
      isConnectedToInternet(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.find<AppController>().isMan.value == 0
          ? Get.theme.primaryColor
          : Get.theme.colorScheme.secondary,
      body: GetBuilder<MoreController>(
          init: MoreController(),
          builder: (MoreController controller) => ListView(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 35,
                  bottom: 60,
                ),
                children: [
                  // if (Get.find<AppController>().isMan.value == 0)
                  if ((controller.appController.appSetting.value
                              .displayExternalPayments ??
                          0) !=
                      0)
                    getUniqueTile(() {
                      Get.toNamed("/packages");
                    }, 'packages', 'packages'),
                  getTile("successStories".tr, AppTheme.WHITE, () {
                    Get.toNamed('/success_stories');
                  }, imageName: "success-stories", isTrailed: true),
                  getTile("articles".tr, AppTheme.WHITE, () {
                    Get.toNamed('/Posts');
                  }, imageName: "articles", isTrailed: true),
                  getTile("marrageOnSunna".tr, AppTheme.WHITE, () {
                    Get.toNamed('/SunnaMarriage');
                  }, imageName: "sunna-married", isTrailed: true),

                  getTile("يوتيوب زفاف".tr, null,
                      () => _launchURL('https://www.youtube.com/@zefaaf'),
                      imageName: "youtube",
                      isTrailed: true,
                      iconSize: 28,
                      upperWidget: Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/new-badge.png',
                          width: 40,
                        ),
                      )),
                  getTile("الباحث الآلي", AppTheme.WHITE, () async {
                    Get.toNamed("/auto_search");
                  }, icon: Icons.youtube_searched_for_rounded, isTrailed: true),
                  getTile("settings".tr, AppTheme.WHITE, () {
                    Get.toNamed("/Settings");
                  }, icon: Icons.settings, isTrailed: true),
                  getTile("evaluateApp".tr, AppTheme.WHITE, () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    inAppReview.openStoreListing(appStoreId: '1550582488');
                  }, imageName: "rate-app", isTrailed: true),
                  getDivider(),
                  // getTile("agents".tr, AppTheme.WHITE, () {
                  //   Get.toNamed('/Agent', arguments: false);
                  // }, imageName: "agents", isTrailed: true, iconSize: 32),
                  Obx(
                    () => getTile(
                      "contactUs".tr,
                      null,
                      () async {
                        // print(controller
                        //     .appController.checkingForPreviousRequest.value);
                        // if (controller.appController.isMan.value == 1) {
                        //   showRatingDialog();
                        //   return;
                        // } else if (controller
                        //         .appController.userData.value.packageLevel! <=
                        //     4) {
                        //   showUpgradePackageDialog(shouldUpgradeToDiamondPackage);
                        //   return;
                        // } else {
                        // controller.setCheckPreviousRequest(true);
                        await controller.appController
                            .checkIfHasPreviousRequest();
                        // print(controller
                        //     .appController.checkingForPreviousRequest.value);

                        // controller.setCheckPreviousRequest(false);
                        // controller.messages.clear();
                        // controller.loading(true);
                        // controller.getMessageList();
                        // }
                      },
                      imageName: "zefaaf-form",
                      iconSize: 35,
                      loading: controller
                          .appController.checkingForPreviousRequest.value,
                      isTrailed: true,
                      // backgroundColor: Colors.white,
                    ),
                  ),
                  //test test test testtesttest test v test test test test test
                  // getTile(
                  //   "contactUS".tr,
                  //   AppTheme.WHITE,
                  //   () => Get.toNamed('/SendContactUSMessage'),
                  //   imageName: "our-contact-us",
                  //   isTrailed: true,
                  // ),
                  getTile("ourMessage".tr, AppTheme.WHITE, () {
                    Get.toNamed("/OurMessage");
                  }, imageName: "our-message", isTrailed: true),
                  getTile(
                    "الدعم التقني",
                    null,
                    () => Get.to(() => const TechnicalSupportView()),
                    isTrailed: true,
                    imageName: 'support-icon',
                  ),
                  getTile("privacy".tr, AppTheme.WHITE, () {
                    Get.toNamed("/Privacy");
                  }, imageName: "privacy", isTrailed: true),
                  getTile("الشروط والأحكام".tr, AppTheme.WHITE, () {
                    Get.toNamed("/terms_and_conditions");
                  }, imageName: 'terms', isTrailed: true),
                  getDivider(),
                  getTile("sharingApp".tr, AppTheme.WHITE, () {
                    Share.share(controller.shareText);
                  }, icon: Icons.share, isTrailed: true),
                  getTile("logOut".tr, AppTheme.WHITE, () async {
                    controller.logOut(context);
                  }, imageName: "power", isTrailed: true),
                  appSettings.value.displayExternalPayments == 0
                      ? const SizedBox()
                      : getTile(
                          "لتفعيل الاشتراكات",
                          AppTheme.whatsappIconColor,
                          () async {
                            _launchURL(controller.whatsappLink);
                          },
                          radius: 20,
                          isTrailed: true,
                          icon: FontAwesome.whatsapp,
                          backgroundColor: Colors.white,
                        ),
                  getTile(
                    "خدمة تقارب",
                    AppTheme.telegramIconColor,
                    () async {
                      _launchURL('https://telegram.me/zefaaf');
                    },
                    radius: 20,
                    isTrailed: true,
                    icon: FontAwesome.telegram,
                    backgroundColor: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     socialButton(FontAwesome.whatsapp,
                        //         AppTheme.whatsappIconColor, () {
                        //       _launchURL(controller.whatsappLink);
                        //     }),
                        //     const SizedBox(width: 4),
                        //     const Text(
                        //       'للشكاوي',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     socialButton(FontAwesome.telegram,
                        //         AppTheme.telegramIconColor, () {
                        //       _launchURL('https://telegram.me/zefaaf');
                        //     }),
                        //     const SizedBox(width: 4),
                        //     const Text(
                        //       'للاقتراحات',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                socialButton(FontAwesome.facebook,
                                    AppTheme.facebookIconColor, () {
                                  _launchURL(controller.facebookLink);
                                }),
                                socialButton(FontAwesome.instagram,
                                    AppTheme.instagramIconColor, () {
                                  _launchURL(controller.instagramLink);
                                }),
                                socialButton(FontAwesome.twitter,
                                    AppTheme.twitterIconColor, () {
                                  _launchURL('https://twitter.com/zefaaf');
                                }),
                                socialButton(FontAwesome.patreon,
                                    AppTheme.patreonIconColor, () {
                                  _launchURL('https://patreon.com/zefaaf');
                                }),
                              ],
                            ),
                            const Text(
                              'V 8.0.0',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
    );
  }

  Widget getDivider() => Divider(color: AppTheme.WHITE);

  Widget getTile(String title, Color? iconColor, Function onTap,
      {required bool isTrailed,
      IconData icon = Icons.refresh,
      Color backgroundColor = Colors.transparent,
      Widget? upperWidget,
      String? imageName,
      bool? loading,
      double? radius,
      double? iconSize}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListTile(
            onTap: () => onTap(),
            title: Text(
              title,
              style: Get.textTheme.bodyText2!.copyWith(color: AppTheme.WHITE),
            ),
            leading: CircleAvatar(
              backgroundColor: backgroundColor,
              radius: radius,
              child: imageName != null
                  ? Image.asset(
                      'assets/images/more-menu/$imageName.png',
                      width: iconSize ?? 24,
                      color: iconColor,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
            ),
            trailing: loading == false || loading == null
                ? isTrailed == true
                    ? Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.WHITE,
                        size: 16,
                      )
                    : const SizedBox(
                        width: 1,
                      )
                : const CircularProgressIndicator()),
        if (upperWidget != null) upperWidget,
      ],
    );
  }

  Widget getUniqueTile(Function() onTap, String image, String title,
      {Color? color,
      Color? contentColor,
      Color? imageColor,
      Gradient? gradient,
      double? size}) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: color ?? AppTheme.WHITE,
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title.tr,
          style: Get.textTheme.bodyText2!
              .copyWith(color: contentColor ?? AppTheme.DARK),
        ),
        leading: Image.asset(
          "assets/images/more-menu/$image.png",
          width: size ?? 24,
          height: size,
          color: imageColor,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: contentColor ?? AppTheme.DARK,
          size: 16,
        ),
      ),
    );
  }

  Widget socialButton(IconData icon, Color color, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      final launchMode = GetPlatform.isAndroid
          ? LaunchMode.externalNonBrowserApplication
          : LaunchMode.externalApplication;
      await launchUrl(
        Uri.parse(url),
        mode: launchMode,
      );
    } else {
      throw 'Could not launch this url $url';
    }
  }
}
