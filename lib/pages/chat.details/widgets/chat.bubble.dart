import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/message.details.dart';

import '../chat.details.controller.dart';

///New special chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
class BubbleSpecialTwo extends GetView<ChatDetailsController> {
  final bool isSender;
  final Widget child;
  final Widget recordBody;
  final Widget replyWidget;
  final Widget messageDetails;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final int index;
  final String imageURL;
  final String recordTime;
  final MessageModal messageModel;
  final bool seen;
  final void Function() onMsgTrashTapped;

  const BubbleSpecialTwo({
    Key? key,
    this.isSender = true,
    required this.child,
    required this.messageModel,
    required this.recordBody,
    required this.replyWidget,
    required this.index,
    required this.imageURL,
    required this.messageDetails,
    this.color = Colors.white70,
    required this.recordTime,
    this.tail = true,
    required this.onMsgTrashTapped,
    required this.sent,
    required this.delivered,
    required this.seen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        child: Row(
          children: [
            Expanded(
              child: messageModel.type == 3
                  ? Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            CustomPaint(
                              painter: SpecialChatBubbleTwo(
                                  color: color,
                                  alignment: isSender
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  tail: tail),
                              child: Container(
                                padding: isSender
                                    ? const EdgeInsets.fromLTRB(7, 7, 17, 7)
                                    : const EdgeInsets.fromLTRB(17, 7, 7, 7),
                                margin: messageModel.owner == 0
                                    ? const EdgeInsets.only(left: 8)
                                    : const EdgeInsets.only(right: 8),
                                // width: messageModel.type == 3
                                //     ? messageModel.containerWidth.value
                                //     : null,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    children: [
                                      replyWidget,
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      recordBody,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: messageDetails,
                                ))
                          ],
                        ),
                        Padding(
                          padding: messageModel.owner == 0
                              ? const EdgeInsets.only(left: 8)
                              : const EdgeInsets.only(right: 8),
                          child: CustomPaint(
                            painter: MessageTail(
                              color: color,
                              alignment: isSender
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                            ),
                            size: const Size(6, 6),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        CustomPaint(
                          painter: SpecialChatBubbleTwo(
                              color: color,
                              alignment: isSender
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              tail: tail),
                          child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * .8,
                                ),
                                margin: isSender
                                    ? const EdgeInsets.fromLTRB(7, 7, 17, 15)
                                    : const EdgeInsets.fromLTRB(17, 7, 7, 15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: replyWidget == const SizedBox()
                                      ? messageModel.type == 1
                                          ? Image.network(
                                              "https://zefaafapi.com$imageURL",
                                              width: 80,
                                            )
                                          : child
                                      : SizedBox(
                                          width: messageModel.type == 1
                                              ? 90
                                              : null,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              replyWidget,
                                              const SizedBox(height: 6),
                                              messageModel.type == 1
                                                  ? Image.network(
                                                      "https://zefaafapi.com$imageURL",
                                                      width: 80,
                                                    )
                                                  : child,
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: messageModel.owner == 0
                                        ? const EdgeInsets.only(right: 6.0)
                                        : const EdgeInsets.only(right: 12.0),
                                    child: messageDetails,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: messageModel.owner == 0
                              ? const EdgeInsets.only(left: 8)
                              : const EdgeInsets.only(right: 8),
                          child: CustomPaint(
                            painter: MessageTail(
                              color: color,
                              alignment: isSender
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                            ),
                            size: const Size(6, 6),
                          ),
                        )
                      ],
                    ),
            ),
            if (!isSender) ...[
              InkWell(
                onTap: onMsgTrashTapped,
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleTwo extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleTwo({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 5.0;
  final double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - 8,
              size.height,
              bottomLeft: Radius.circular(_radius),
              // topRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path = Path();
        path.moveTo(size.width - _x, 4);

        path.lineTo(size.width - _x, size.height - 5);
        path.lineTo(size.width, size.height);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              size.width - _x,
              0.0,
              size.width,
              size.height,
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - 8,
              size.height,
              bottomLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              // bottomRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              8,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path = Path();
        path.moveTo(_x, 4);
        path.lineTo(0, size.height);
        path.lineTo(_x, size.height - 5);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0.0,
              _x,
              size.height,
              topRight: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              8,
              0,
              size.width,
              size.height,
              bottomRight: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
              // bottomLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MessageTail extends CustomPainter {
  MessageTail({required this.color, required this.alignment});
  Color color;
  Alignment alignment;
  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topLeft) {
      Paint paint_0 = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..strokeWidth = 1;

      Path path_0 = Path();
      path_0.moveTo(0, 0);
      path_0.lineTo(size.width, 0);
      path_0.lineTo(size.width * 0.05, size.height * 0.94);
      path_0.lineTo(size.width * 0.03, size.height * 0.94);
      path_0.lineTo(0, size.height * 0.94);
      path_0.lineTo(0, 0);
      path_0.close();

      canvas.drawPath(path_0, paint_0);
    } else {
      Paint paint_0 = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..strokeWidth = 1.0;

      Path path_0 = Path();
      path_0.moveTo(size.width * 0.9962500, size.height * 0.0020000);
      path_0.lineTo(0, size.height * 0.0020000);
      path_0.lineTo(size.width * 0.9962500, size.height * 0.9940000);
      path_0.lineTo(size.width * 0.9962500, size.height * 0.0020000);
      path_0.close();

      canvas.drawPath(path_0, paint_0);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9962500, size.height * 0.0020000);
    path_0.lineTo(0, size.height * 0.0020000);
    path_0.lineTo(size.width * 0.9962500, size.height * 0.9940000);
    path_0.lineTo(size.width * 0.9962500, size.height * 0.0020000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

buildRadius({blRadius, trRadius, tlRadius, brRadius}) => BorderRadius.only(
    bottomLeft: Radius.circular(blRadius),
    topRight: Radius.circular(trRadius),
    topLeft: Radius.circular(tlRadius),
    bottomRight: Radius.circular(brRadius));
