import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/newMessage.modal.dart';
import 'package:zeffaf/pages/app_messages/AppMessage.controller.dart';
import 'package:zeffaf/pages/message.details/message.details.view.dart';
import 'package:zeffaf/utils/time.dart';

class AppMessageCard extends StatefulWidget {
  final NewMessagesModal message;
  final AppMessageController controller;
  @override
  _AppMessageCardState createState() => _AppMessageCardState();

  const AppMessageCard(this.message, this.controller, {super.key});
}

class _AppMessageCardState extends State<AppMessageCard> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () async {
          if (widget.message.reasonId != 4) {
            widget.controller.getMessageDetails(widget.message.id);
            widget.message.readed = 1;
            setState(() {});
          }
          final result = await Get.to(
            () => MessageDetails(
              newMessagesModal: widget.message,
            ),
          );
          if (result == null) return;
          widget.controller.loading(true);
          widget.controller.getMessageList();
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.only(
                  right: 8.0, left: 4.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.grey[900],
                  border: Border.all(
                    color: widget.message.reasonId == 4
                        ? appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary
                        : Colors.transparent,
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.message.owner == 0
                        ? Icons.call_missed_outgoing_rounded
                        : Icons.call_missed_outlined,
                    color: widget.message.owner == 0
                        ? Get.theme.errorColor
                        : Get.theme.primaryColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.message.messageType,
                          style: Get.textTheme.bodyText2!
                              .copyWith(color: Get.theme.primaryColor),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            widget.message.image == null ||
                                    widget.message.image == ""
                                ? const SizedBox()
                                : Icon(
                                    Icons.photo,
                                    size: 20,
                                    color: lightMode
                                        ? Colors.grey[700]
                                        : Colors.grey[400],
                                  ),
                            Expanded(
                              child: Text(
                                "${widget.message.title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${DateTimeUtil.convertTimeWithDate(widget.message.messageDateTime)}",
                          style: Get.textTheme.bodyText2!
                              .copyWith(color: Get.theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 2,
              left: 2,
              child: Visibility(
                visible: widget.message.reply != null ? true : false,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: widget.controller.appController.isMan.value == 0
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.secondary),
                  child: Text(
                    "تم الرد",
                    style: Get.textTheme.caption!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
