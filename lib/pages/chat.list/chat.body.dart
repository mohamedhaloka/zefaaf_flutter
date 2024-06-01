import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/user.chats.dart';
import 'package:zeffaf/pages/chat.details/view.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../appController.dart';
import '../../utils/toast.dart';
import 'chat.list.controller.dart';

class ChatBody extends GetView<ChatListController> {
  ChatBody({super.key, required this.userChats});
  UserChats userChats;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14, top: 6),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (controller.appController.userData.value.premium == 0) {
            showToast('قم بترقية حسابك حتى تستطيع بدء الدردشة');
          } else {
            Get.to(() => ChatDetails(
                  otherId: userChats.otherId!,
                  isBackToChatList: true,
                ));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(10),
          elevation: 0.0,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: controller.appController.isMan.value == 0
                  ? Get.theme.colorScheme.secondary
                  : Get.theme.primaryColor,
              backgroundImage: userChats.image == "" || userChats.image == null
                  ? AssetImage(controller.appController.isMan.value == 0
                      ? "assets/images/register_landing/female.png"
                      : "assets/images/register_landing/male.png")
                  : NetworkImage(
                          "https://zefaafapi.com/uploadFolder/small/${userChats.image}")
                      as ImageProvider,
              radius: 25,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: userChats.packageLevel == 0 ? 14 : null,
                  height: userChats.packageLevel == 0 ? 14 : null,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: userChats.available == 1
                        ? Colors.green
                        : userChats.available == 0
                            ? Colors.grey
                            : Colors.red,
                  ),
                  child: Get.find<AppController>().isMan.value == 0 &&
                          userChats.packageLevel != 0
                      ? Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            "assets/images/home/crown.png",
                            height: 14,
                            width: 14,
                          ),
                        )
                      : Get.find<AppController>().isMan.value == 1 &&
                              (userChats.packageLevel == 1 ||
                                  userChats.packageLevel == 2 ||
                                  userChats.packageLevel == 3)
                          ? const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            )
                          : Get.find<AppController>().isMan.value == 1 &&
                                  userChats.packageLevel == 4
                              ? Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    "assets/images/platinum.png",
                                    height: 13,
                                    width: 13,
                                  ),
                                )
                              : Get.find<AppController>().isMan.value == 1 &&
                                      userChats.packageLevel == 5
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
            ),
            const CustomSizedBox(
              widthNum: 0.03,
              heightNum: 0.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userChats.otherName}",
                      style: Get.theme.textTheme.headline5!.copyWith(
                          color: controller.appController.isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary),
                    ),
                    Visibility(
                      visible: userChats.newMessage == 0 ? false : true,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.appController.isMan.value == 0
                                ? Get.theme.primaryColor
                                : Get.theme.colorScheme.secondary),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    userChats.readied == 0
                        ? Icon(
                            userChats.readied == 1
                                ? Icons.done
                                : Icons.done_all,
                            color: userChats.readied == 1
                                ? Colors.grey[500]
                                : Get.theme.primaryColor,
                            size: 12,
                          )
                        : const SizedBox(),
                    userChats.lastMessageType == 1
                        ? Image.asset(
                            'assets/images/sticker-icon.png',
                            width: 12,
                          )
                        : userChats.lastMessageType == 3
                            ? Image.asset(
                                'assets/images/mic-outfill.png',
                                width: 12,
                              )
                            : const SizedBox(),
                    userChats.lastMessageType == 1 ||
                            userChats.lastMessageType == 3
                        ? const SizedBox(
                            width: 2,
                          )
                        : const SizedBox(),
                    Expanded(
                      child: Text("${userChats.lastMessage}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
                Text(
                  userChats.lastMessageTime == null
                      ? ""
                      : "${DateTimeUtil.convertTimeWithDate(userChats.lastMessageTime)}",
                  style: TextStyle(
                      color: controller.appController.isMan.value == 1
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.secondary,
                      fontSize: 12),
                ),
              ],
            )),
            InkWell(
              onTap: () {
                controller.showEnsureUserNeedToDeleteChatDialog(
                  content: 'هل تود حقاً حذف محادثتك',
                  deleteAllChats: false,
                  chatId: userChats.id.toString(),
                );
              },
              child: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
