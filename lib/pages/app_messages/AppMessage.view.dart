import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/cards/message_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/no.messages.dart';

import '../../utils/upgrade_package_dialog.dart';
import '../../widgets/app_header.dart';
import 'AppMessage.controller.dart';
import 'AppMessage.loader.dart';
import 'app.message.header.dart';

class AppMessageView extends GetView<AppMessageController> {
  const AppMessageView({super.key});

  @override
  Widget build(context) {
    // final appController = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey[700],
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          // shadowColor: Colors.black,
          backgroundColor: controller.appController.isMan.value == 0
              ? Get.theme.primaryColor
              : Get.theme.colorScheme.secondary,
        ),
        onPressed: () async {
          final isMan = controller.appController.isMan.value == 0;
          final packageLevel =
              controller.appController.userData.value.packageLevel ?? 0;

          if (!isMan) {
            if (packageLevel == 6) {
              showUpgradePackageDialog(isMan, shouldUpgradeToFlowerPackage);
              return;
            }

            showRatingDialog(isMan);
            return;
          } else if (packageLevel <= 4) {
            showUpgradePackageDialog(isMan, shouldUpgradeToDiamondPackage);
            return;
          } else {
            showRatingDialog(isMan);
            // controller.setCheckPreviousRequest(true);
            // await controller.appController.checkIfHasPreviousRequest();
            // controller.setCheckPreviousRequest(false);
            // controller.messages.clear();
            // controller.loading(true);
            // controller.getMessageList();
          }
        },
        child: Obx(
          () => controller.appController.checkingForPreviousRequest.value
              ? const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(),
                )
              : Text(
                  controller.appController.isMan.value == 1
                      ? "أرسلي طلب زواج 💌"
                      : 'أرسل طلب زواج 💌',
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // padding: const EdgeInsets.symmetric(horizontal: 20),
      // backgroundColor: controller.appController.isMan.value == 0
      //     ? Get.theme.primaryColor
      //     : Get.theme.colorScheme.secondary,
      //   label: Obx(
      //     () => controller.appController.checkingForPreviousRequest.value
      //         ? const CircularProgressIndicator()
      //         : const Text(
      //             'أرسل طلب زواج 💌',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //   ),
      //   onPressed: () async {
      //     if (controller.appController.isMan.value == 1) {
      //       showRatingDialog();
      //       return;
      //     } else if (controller.appController.userData.value.packageLevel! <=
      //         4) {
      //       showUpgradePackageDialog(shouldUpgradeToDiamondPackage);
      //       return;
      //     } else {
      //       // controller.setCheckPreviousRequest(true);
      //       await controller.appController.checkIfHasPreviousRequest();
      //       // controller.setCheckPreviousRequest(false);
      //       // controller.messages.clear();
      //       // controller.loading(true);
      //       // controller.getMessageList();
      //     }
      //     // }

      //     // Get.to(() => NewMessage(complaint: false));
      //   },
      // ),
      body: Obx(() => BaseAppHeader(
            headerLength: 200,
            collapsedHeight: 50,
            rightPosition: 20,
            leftPosition: 20,
            toolbarHeight: 40,
            body: AppMessageHeader(),
            refresh: () {
              controller.messages.clear();
              controller.loading(true);
              controller.getMessageList();
            },
            actions: [
              IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Get.back())
            ],
            children: [
              controller.isConnectedToInternet.value
                  ? const NoInternetChecker()
                  : controller.loading.value
                      ? SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          sliver: SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return AppMessageLoader();
                            }, childCount: 5),
                          ),
                        )
                      : controller.messages.isEmpty
                          ? NoMessage()
                          : SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return AppMessageCard(
                                    controller.messages[index],
                                    controller,
                                  );
                                }, childCount: controller.messages.length),
                              ),
                            )
            ],
          )),
    );
  }
}
