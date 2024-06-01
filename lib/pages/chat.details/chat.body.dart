import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:zeffaf/pages/chat.details/chat.details.component.dart';
import 'package:zeffaf/pages/chat.details/chat.details.controller.dart';
import 'package:zeffaf/pages/chat.details/message.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../utils/upgrade_package_dialog.dart';
import 'chat.pagination.dart';
import 'message.loader.dart';

class ChatBody extends StatefulWidget {
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final controller = Get.find<ChatDetailsController>();

  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    super.initState();
    controller.scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

    //To get More Message
    controller.paginationLoadMoreMessage(
        controller.chatId.value, controller.currentPage.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.only(left: 26, right: 26, top: 0),
          margin: const EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            image: const DecorationImage(
                image: ExactAssetImage("assets/images/chat-bg.png"),
                repeat: ImageRepeat.repeat),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: controller.loading.value
                      ? MessageLoader()
                      : controller.ignoreToChat.value
                          ? SizedBox(
                              width: Get.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.ignoreMessage,
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.bodyText2!.copyWith(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.77,
                                  child: ListView.builder(
                                    itemCount: controller.messages.length,
                                    controller: controller.scrollController,
                                    scrollDirection: scrollDirection,
                                    itemBuilder: (context, index) {
                                      return AutoScrollTag(
                                        index: index,
                                        key: ValueKey(index),
                                        controller: controller.scrollController,
                                        highlightColor: controller.appController
                                                    .isMan.value ==
                                                0
                                            ? Get.theme.primaryColor
                                                .withOpacity(0.3)
                                            : Get.theme.colorScheme.secondary
                                                .withOpacity(0.3),
                                        child: MessagesBody(
                                          messageDetails:
                                              controller.messages[index],
                                          autoScrollCtrl:
                                              controller.scrollController,
                                          messageList: controller.messages,
                                          index: index,
                                          controller: controller,
                                          userDetails: controller.userDetails,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                PaginationLoadMessages(controller.fetch.value),
                                buildAlertForWoman()
                              ],
                            )),
              controller.readiedAll.value ? const SizedBox() : const SizedBox(),
              const SizedBox(
                height: 6,
              ),
              controller.loading.value || controller.ignoreToChat.value
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                ChatDetailsComponents.buildReplyMessage(
                                    controller: controller),
                                Row(
                                  children: [
                                    ChatDetailsComponents.buildRecordButton(
                                        controller: controller,
                                        formKey: formKey,
                                        context: context,
                                        id: controller.chatId.value),
                                    const CustomSizedBox(
                                      widthNum: 0.01,
                                      heightNum: 0.0,
                                    ),
                                    Visibility(
                                        visible: controller.isPlaying.value
                                            ? true
                                            : false,
                                        child: ChatDetailsComponents
                                            .buildCancelRecordButton(
                                          controller: controller,
                                        )),
                                    const CustomSizedBox(
                                      widthNum: 0.02,
                                      heightNum: 0.0,
                                    ),
                                    Expanded(
                                      child: controller.isPlaying.value
                                          ? buildRecording()
                                          : buildChatInput(context),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.visibleSticker.value,
                            child: ChatDetailsComponents.buildSticker(
                                controller: controller,
                                id: controller.chatId.value,
                                context: context),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ));
  }

  buildAlertForWoman() {
    return Visibility(
      visible: controller.appController.isMan.value == 0
          ? false
          : controller.alertOpacity.value
              ? true
              : false,
      child: Positioned(
          top: 0,
          left: Get.width / 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/chat-warning.png',
                height: Get.width * 0.30,
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                    onTap: () {
                      controller.alertOpacity(false);
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.red[800],
                    )),
              )
            ],
          )),
    );
  }

  Widget buildRecording() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Get.theme.cardColor, borderRadius: BorderRadius.circular(40)),
      child: StreamBuilder<int>(
        stream: controller.stopWatchTimer.rawTime,
        initialData: controller.stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final value = snap.data;
          final displayTime = StopWatchTimer.getDisplayTime(value!,
              hours: false, milliSecond: false);
          controller.maxRecordTime(displayTime);

          if (controller.maxRecordTime.value == "02:00") {
            controller.stopRecord();
            Timer(const Duration(seconds: 1), () {
              controller.maxRecordTime("02:00");
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
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "جاري التسجيل",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      displayTime,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/voice.gif',
                      color: Colors.red,
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildChatInput(context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Get.theme.cardColor, borderRadius: BorderRadius.circular(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChatDetailsComponents.buildChatInput(formKey, controller),
          const CustomSizedBox(
            widthNum: 0.01,
            heightNum: 0.0,
          ),
          ChatDetailsComponents.buildIconInputChat(
              context: context,
              onTap: () {
                if (controller.appController.userData.value.packageId! <= 0) {
                  showUpgradePackageDialog(shouldUpgradeToSilverPackage);
                  return;
                }
                controller.visibleSticker.value =
                    !controller.visibleSticker.value;
                controller.selectedTab.value = 0;

                //Leave The keyboard focus
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              isActive: controller.visibleSticker.value,
              imageSrc: 'sticker-icon.png',
              controller: controller)
        ],
      ),
    );
  }
}
