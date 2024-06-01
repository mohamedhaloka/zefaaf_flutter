import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/models/reply.message.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/chat.details/widgets/record.message.dart';

import 'chat.details.controller.dart';
import 'widgets/chat.bubble.dart';
import 'widgets/mention.message.widget.dart';
import 'widgets/message.read.and.time.dart';
import 'widgets/time_view.dart';

class MessagesBody extends StatelessWidget {
  MessagesBody({
    this.messageDetails,
    this.index,
    this.controller,
    this.autoScrollCtrl,
    this.messageList,
    this.userDetails,
  });
  MessageModal? messageDetails;
  List<MessageModal>? messageList;
  AutoScrollController? autoScrollCtrl;
  int? index, selectedIndex;
  ChatDetailsController? controller;
  User? userDetails;

  @override
  Widget build(BuildContext context) {
    return messageDetails!.type == -1
        ? TimeView(messageDetails!)
        : SwipeTo(
            onRightSwipe: (v) {
              addToReplyModal(v);
            },
            child: Container(
              margin: messageDetails!.owner == 0
                  ? const EdgeInsets.only(right: 74)
                  : const EdgeInsets.only(left: 74),
              child: BubbleSpecialTwo(
                onMsgTrashTapped: () {
                  controller?.showDeleteChatMessageDialog(messageDetails!);
                },
                recordTime: messageDetails!.voiceTime ?? '',
                replyWidget: messageDetails!.parentMessage != "" &&
                        messageDetails!.parentMessage != null
                    ? MentionMessageWidget(
                        messageDetails: messageDetails!,
                        messageList: messageList!,
                        autoScrollCtrl: autoScrollCtrl!,
                      )
                    : const SizedBox(),
                recordBody: RecordMessage(
                    messageDetails: messageList![index!],
                    userDetails: userDetails!,
                    selectedIndex: selectedIndex ?? 0,
                    index: index!),
                messageModel: messageDetails!,
                messageDetails: MessageReadAndTime(messageDetails!),
                index: index!,
                imageURL: messageDetails!.message ?? '',
                isSender: messageDetails!.owner == 0 ? false : true,
                seen: messageDetails!.readed == 1 ? false : true,
                sent: messageDetails!.readed == 1 ? true : false,
                delivered: true,
                tail: false,
                color: messageDetails!.owner == 0
                    ? controller!.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary
                    : controller!.appController.isMan.value == 0
                        ? Get.theme.colorScheme.secondary
                        : Get.theme.primaryColor,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 50),
                  child: Text(
                    "${messageDetails!.message}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
  }

  void addToReplyModal(DragUpdateDetails s) {
    controller!.replyContainerOpacity(true);
    controller!.replyMessageModal(ReplyMessage(
        parentMessage: messageDetails!.message,
        parent: messageDetails!.id!,
        type: messageDetails!.type!));
  }
}
