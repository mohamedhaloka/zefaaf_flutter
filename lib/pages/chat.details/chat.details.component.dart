import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/upgrade_package_dialog.dart';

import 'chat.details.controller.dart';

class ChatDetailsComponents {
  static Widget buildChatInput(formKey, ChatDetailsController controller) {
    return Expanded(
      child: Form(
        key: formKey,
        child: TextFormField(
          cursorColor: Colors.black,
          controller: controller.messageContent,
          style: const TextStyle(fontSize: 18),
          maxLines: 4,
          minLines: 1,
          onTap: () {
            controller.visibleSticker(false);
          },
          onChanged: (val) {
            if (val != "") {
              controller.recording(false);
              controller.userMessage.value = val;
            } else if (val == "") {
              controller.endTyping();
              controller.recording(true);
            }
            if (val.trim().isEmpty) {
              controller.endTyping();
              controller.recording(true);
            }
          },
          onSaved: (val) {
            if (val != "") {
              controller.messageContent.text = val!;
              controller.userMessage.value = controller.messageContent.text;
            } else {}
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(4),
              hintText: "اكتب هنا...",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none))),
        ),
      ),
    );
  }

  static Widget buildIconInputChat(
      {required Function() onTap,
      required String imageSrc,
      context,
      isActive,
      required ChatDetailsController controller}) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        "assets/images/$imageSrc",
        width: 20,
        color: Theme.of(context).brightness == Brightness.light
            ? isActive
                ? controller.appController.isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary
                : Colors.grey[700]
            : isActive
                ? controller.appController.isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary
                : Colors.grey,
      ),
    );
  }

  static Widget buildRecordButton(
      {required ChatDetailsController controller, formKey, id, context}) {
    return GestureDetector(
      onTap: controller.recording.value
          ? !(controller.isPlaying.value)
              ? () {
                  if (controller.appController.userData.value.packageLevel! <=
                      1) {
                    showUpgradePackageDialog(
                        controller.appController.isMan.value == 0,
                        shouldUpgradeToSilverPackage);
                    return;
                  }
                  controller.startRecord(controller.assetsAudioPlayer);
                }
              : () {
                  controller.stopRecord();
                  Future.delayed(const Duration(seconds: 1), () {
                    controller.alertOpacity(false);
                    controller
                        .sendAudio(
                            controller.chatId.value,
                            controller.recordFilePath.value,
                            controller.replyMessageModal.value)
                        .then((value) {
                      controller.stopRecordInSocket();
                    });
                  });
                }
          : controller.sendMessageLoading.value
              ? () {}
              : () {
                  if (controller.appController.userData.value.packageLevel! <=
                      0) {
                    showUpgradePackageDialog(
                        controller.appController.isMan.value == 0,
                        shouldUpgradeToSilverPackage);
                    return;
                  }
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    controller.alertOpacity(false);

                    controller.sendMessage(
                        controller.messageContent.text.trim(),
                        id.toString(),
                        0.toString(),
                        controller.replyMessageModal.value,
                        context);
                  }
                },
      child: CircleAvatar(
        backgroundColor: controller.appController.isMan.value == 0
            ? Get.theme.primaryColor
            : Get.theme.colorScheme.secondary,
        radius: 23,
        child: controller.sendMessageLoading.value
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Image.asset(
                controller.recording.value
                    ? controller.isPlaying.value
                        ? "assets/images/send.png"
                        : "assets/images/mic.png"
                    : "assets/images/send.png",
                width: 20,
                color: Colors.white,
              ),
      ),
    );
  }

  static Widget buildReplyMessage({required ChatDetailsController controller}) {
    return Visibility(
      visible: controller.replyContainerOpacity.value ? true : false,
      child: Stack(
        children: [
          Container(
            height: 60,
            width: Get.width,
            padding: const EdgeInsets.only(top: 6, right: 30),
            decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    width: 1,
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary)),
            child: controller.replyMessageModal.value == null
                ? const SizedBox()
                : controller.replyMessageModal.value.type == 0
                    ? SingleChildScrollView(
                        child: Text(
                            "${controller.replyMessageModal.value.parentMessage}"))
                    : controller.replyMessageModal.value.type == 1
                        ? Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://zefaafapi.com${controller.replyMessageModal.value.parentMessage}"))),
                          )
                        : const Text("تسجيل صوتي"),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: InkWell(
              onTap: () {
                controller.replyMessageModal.value.parentMessage = "";
                controller.replyMessageModal.value.parent = 0;
                controller.replyMessageModal.value.type = 0;
                controller.replyContainerOpacity(false);
              },
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.close,
                  size: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget buildCancelRecordButton(
      {required ChatDetailsController controller}) {
    return GestureDetector(
      onTap: () {
        controller.stopRecord();
      },
      child: CircleAvatar(
        backgroundColor: controller.appController.isMan.value == 0
            ? Get.theme.primaryColor
            : Get.theme.colorScheme.secondary,
        radius: 23,
        child: const Icon(
          Icons.close,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget buildSticker(
      {context, required ChatDetailsController controller, id}) {
    return Container(
      width: Get.width,
      height: 200,
      decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: controller.tabHeader
                .map((element) => buildClickableTabHeader(element.tittle, () {
                      controller.selectedTab(element.id);
                    }, controller.selectedTab.value == element.id, context,
                        controller))
                .toList(),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 1),
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  if (controller.appController.userData.value.packageId! <= 0) {
                    showUpgradePackageDialog(
                        controller.appController.isMan.value == 0,
                        shouldUpgradeToSilverPackage);
                    return;
                  }
                  controller.sendMessage(
                      controller.selectedTab.value == 0
                          ? "${controller.emojiURL.value}/${controller.emoji[index]}"
                          : "${controller.stickersURL.value}/${controller.stickers[index]}",
                      id.toString(),
                      1.toString(),
                      controller.replyMessageModal.value,
                      context);
                  controller.visibleSticker(false);
                },
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: controller.selectedTab.value == 0
                              ? NetworkImage(
                                  "https://zefaafapi.com${controller.emojiURL.value}/${controller.emoji[index]}")
                              : NetworkImage(
                                  "https://zefaafapi.com${controller.stickersURL.value}/${controller.stickers[index]}"))),
                ),
              ),
              itemCount: controller.selectedTab.value == 0
                  ? controller.emoji.length
                  : controller.stickers.length,
            ),
          )
        ],
      ),
    );
  }

  static Widget buildClickableTabHeader(
      tittle, onTap, bool isActive, context, ChatDetailsController controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 0.0),
      onPressed: onTap,
      child: Text(
        "$tittle",
        style: Get.theme.textTheme.bodyText2!.copyWith(
            color: isActive
                ? controller.appController.isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary
                : Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
