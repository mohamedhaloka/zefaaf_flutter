import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/models/reply.message.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/chat.details/chat.details.app.bar.dart';
import 'package:zeffaf/pages/chat.details/chat.details.controller.dart';
import 'package:zeffaf/pages/chat.list/chat.list.controller.dart';
import 'package:zeffaf/utils/theme.dart';

import 'chat.body.dart';

class ChatDetails extends StatefulWidget {
  ChatDetails({
    super.key,
    this.otherId,
    this.isBackToChatList,
    this.inUserDetails = false,
  });
  int? otherId;
  bool? isBackToChatList;
  bool inUserDetails;

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> with WidgetsBindingObserver {
  ChatDetailsController controller = Get.put(ChatDetailsController());

  @override
  void initState() {
    super.initState();
    controller.isBackToChatList(widget.isBackToChatList);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.otherUserName = controller.userDetails.userName!;
      controller.chatId.value = controller.chatIdForResumeApp.value;
      controller.sendConfirmReadied();
    }
    if (state == AppLifecycleState.paused) {
      controller.otherUserName = "";
      controller.chatId.value = "";
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MixinBuilder<ChatDetailsController>(
      init: ChatDetailsController(),
      initState: (_) {
        controller.otherId(widget.otherId);
        controller.loading(true);
        controller.alertOpacity(true);
        controller.messages.clear();
        controller
            .getChatDetails(widget.otherId.toString())
            .then((responseData) {
          if (responseData['status'] == 'success') {
            //Chat ID
            controller.chatId.value = responseData['chatId'];
            controller.chatIdForResumeApp.value = responseData['chatId'];
            //Put All Message Room in Message Modal
            for (var message in responseData['data']) {
              controller.messages.add(MessageModal.fromJson(message));
            }
            //To Put all Data From User in User Models
            controller.userDetails =
                User.fromJson(responseData['otherDetails'][0]);

            controller.socket
                .roomName(responseData['otherDetails'][0]['userName']);
            //Create Modal from Reply Message
            for (int i = 0; i < controller.messages.length - 1; i++) {
              controller.replyMessage.add(ReplyMessage(
                  type: controller.messages[i].parentType ?? 0,
                  parent: controller.messages[i].parent ?? 0,
                  parentMessage: controller.messages[i].parentMessage));
            }

            controller.socket.userAvailable(controller.userDetails.available);
            //Disable Loading To Show Data
            controller.loading(false);

            //Send confirm Readied To Socket
            controller.sendConfirmReadied();
          } else {
            controller.loading(false);

            final packageId =
                controller.appController.userData.value.packageLevel ?? 0;
            final otherUserMarrageId = controller.userDetails.mariageKind ?? 0;
            if (packageId <= 2 && otherUserMarrageId == 5) {
              controller.ignoreMessage = "هذه الخدمة لأصحاب الباقة الفضية";
            } else if (packageId < 3 && otherUserMarrageId == 6) {
              controller.ignoreMessage = 'هذه الخدمة لأصحاب الباقة الذهبية';
            } else if (packageId < 4 && otherUserMarrageId == 184) {
              controller.ignoreMessage = "هذه الخدمة لأصحاب الباقة البلاتينية";
            } else if (packageId < 5 &&
                (otherUserMarrageId == 185 || otherUserMarrageId == 183)) {
              controller.ignoreMessage = 'هذه الخدمة لأصحاب الباقة الماسية';
            } else if (responseData['errorCode'] == "free package") {
              controller.ignoreMessage = "هذه الخدمة لأصحاب الباقة الفضية";
            } else if (responseData['errorCode'] == 'package3') {
              controller.ignoreMessage = 'هذه الخدمة لأصحاب الباقة الذهبية';
            } else if (responseData['errorCode'] == 'package4') {
              controller.ignoreMessage = 'هذه الخدمة لأصحاب الباقة الذهبية';
            } else if (responseData['errorCode'] == 'package5') {
              controller.ignoreMessage = 'هذه الخدمة لأصحاب الباقة الماسية';
            }

            controller.ignoreToChat(true);
          }
        }).whenComplete(() {
          if (!(controller.ignoreToChat.value) &&
              controller.messages.length > 6) {
            Future.delayed(const Duration(milliseconds: 200), () {
              controller.scrollController.jumpTo(
                  controller.scrollController.position.maxScrollExtent + 1000);
            });
          }
        });
      },
      dispose: (_) {
        controller.socket.roomName("");
        controller.visibleSticker(false);
        controller.socket.userStatue('');
        controller.loading(false);
        controller.recording(true);
        controller.replyContainerOpacity(false);
        controller.ignoreToChat(false);
        controller.replyMessage(null);
        for (int i = 0; i < controller.messages.length; i++) {
          controller.messages[i].assetsAudioPlayer!.stop();
        }
      },
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          onWillPOP();
          return true;
        },
        child: Container(
          decoration: AppTheme().blueBackground,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: chatDetailsAppBar(controller.userDetails, controller,
                  onWillPOP, widget.inUserDetails),
              body: ChatBody()),
        ),
      ),
    );
  }

  void onWillPOP() {
    widget.isBackToChatList ?? false
        ? Get.back(result: Get.find<ChatListController>().getChatsList())
        : Get.back();
  }
}
