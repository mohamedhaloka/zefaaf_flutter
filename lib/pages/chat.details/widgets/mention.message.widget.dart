import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zeffaf/models/message.details.dart';

import '../chat.details.controller.dart';

class MentionMessageWidget extends StatelessWidget {
  MentionMessageWidget(
      {required this.messageList,
      required this.messageDetails,
      required this.autoScrollCtrl,
      super.key});
  final List<MessageModal> messageList;
  final MessageModal messageDetails;
  final AutoScrollController autoScrollCtrl;

  final controller = Get.find<ChatDetailsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 180,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final int index = messageList
                .indexWhere((element) => element.id == messageDetails.parent);

            await autoScrollCtrl.scrollToIndex(index,
                preferPosition: AutoScrollPosition.begin);
            autoScrollCtrl.highlight(index);
          } catch (e) {}
        },
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
        ),
        child: SingleChildScrollView(
          child: messageDetails.parentType == 0
              ? Text("${messageDetails.parentMessage}")
              : messageDetails.parentType == 1
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://zefaafapi.com${messageDetails.parentMessage}"))),
                    )
                  : const Text("تسجيل صوتي"),
        ),
      ),
    );
  }
}
