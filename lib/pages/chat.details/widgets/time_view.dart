import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/pages/chat.details/widgets/time-converter.dart';

class TimeView extends StatelessWidget {
  TimeView(this.messageDetails);
  MessageModal messageDetails;
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.black54),
        child: TimeConverter(
          dateTime: messageDetails.messageDate ?? '',
          dateTime2: messageDetails.messageDate ?? '',
          dateTimeStyle: Get.textTheme.bodyText1!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
