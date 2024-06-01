import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/chat.list/chat.list.controller.dart';
import 'package:zeffaf/pages/chat.list/chats.list.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';
import 'package:zeffaf/widgets/search_form_field.dart';

import 'chat.loader.dart';

class ChatList extends GetView<ChatListController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<HomeController>().updateByToken(false);
        return true;
      },
      child: MixinBuilder<ChatListController>(
        init: ChatListController(),
        builder: (controller) => RefreshIndicator(
          backgroundColor: Get.theme.primaryColor,
          color: Colors.white,
          onRefresh: () async {
            await controller.getChatsList();
          },
          child: Container(
            decoration: AppTheme().blueBackground,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: customAppBar("الرسائل", onTap: () {
                  Get.find<HomeController>().updateByToken(false);
                }),
                floatingActionButton: controller.usersList.isEmpty
                    ? null
                    : FloatingActionButton.extended(
                        backgroundColor:
                            controller.appController.isMan.value == 0
                                ? Get.theme.primaryColor
                                : Get.theme.colorScheme.secondary,
                        label: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'حذف جميع الرسائل',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: () {
                          controller.showEnsureUserNeedToDeleteChatDialog(
                            content: 'هل تود حقاً حذف جميع محادثاتك؟',
                          );
                        },
                      ),
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[300]
                        : Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: <Widget>[
                      SearchTextField(
                        controller: controller.searchController,
                        tittle: "الاسم",
                        fillColor: controller.appController.isMan.value == 0
                            ? Get.theme.primaryColor.withOpacity(0.6)
                            : Get.theme.colorScheme.secondary.withOpacity(0.6),
                      ),
                      controller.loading.value
                          ? ChatLoader()
                          : controller.usersList.isEmpty
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/no-message.png",
                                        height: 120,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "لا يوجد محادثات حتى الآن!!",
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.bodyText1!
                                            .copyWith(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("يرجى المحاولة لاحقاً",
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.bodyText1!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Get.find<AppController>()
                                                                  .isMan
                                                                  .value ==
                                                              0
                                                          ? Get.theme
                                                              .primaryColor
                                                          : Get
                                                              .theme
                                                              .colorScheme
                                                              .secondary)),
                                    ],
                                  ),
                                )
                              : ChatsList(
                                  filter: controller.filter.value,
                                  chats: controller.usersList.value,
                                ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
