import 'package:flutter/material.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/models/message.details.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class MessageReadAndTime extends StatelessWidget {
  MessageReadAndTime(this.messageDetails);
  MessageModal messageDetails;
  @override
  Widget build(BuildContext context) {
    return messageDetails.owner == 0
        ? Row(
            children: [
              messageDetails.readed == 1
                  ? Icon(
                      Icons.done,
                      color: Colors.grey[300],
                      size: 14,
                    )
                  : const Icon(
                      Icons.done_all,
                      color: Colors.blue,
                      size: 14,
                    ),
              const CustomSizedBox(
                widthNum: 0.01,
                heightNum: 0.0,
              ),
              Text(
                "${DateTimeUtil.convertTime(messageDetails.messageTime.toString())}",
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ],
          )
        : Text(
            "${DateTimeUtil.convertTime(messageDetails.messageTime.toString())}",
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 8, color: Colors.white),
          );
  }
}
