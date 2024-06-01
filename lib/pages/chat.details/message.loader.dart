import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class MessageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return SizedBox(
      height: Get.height * 0.77,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
              highlightColor: lightMode ? Colors.grey[300]! : Colors.grey[500]!,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15, top: 6),
                child: Column(
                  crossAxisAlignment: index.isOdd
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: index.isOdd
                            ? EdgeInsets.only(
                                right: index == 1 ? 130 : 60, bottom: 0)
                            : EdgeInsets.only(
                                left: index == 2 ? 160 : 60, bottom: 0),
                        decoration: BoxDecoration(
                            color: index.isOdd
                                ? Colors.grey[200]
                                : Get.find<AppController>().isMan.value == 0
                                    ? Get.theme.colorScheme.secondary
                                        .withOpacity(0.8)
                                    : Get.theme.primaryColor.withOpacity(0.8),
                            borderRadius: index.isOdd
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  )),
                        child: Column(
                          children: [
                            index.isOdd
                                ? const Text("")
                                : SizedBox(
                                    width: 100,
                                    height: index == 2 ? 10 : 100,
                                  ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: index.isOdd
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.grey[600],
                                          size: 14,
                                        ),
                                        const CustomSizedBox(
                                          widthNum: 0.01,
                                          heightNum: 0.0,
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: index.isEven
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: index.isEven
                          ? CustomPaint(
                              size: const Size(16, 16),
                              painter: MessageBody(
                                  Get.find<AppController>().isMan.value == 0
                                      ? Get.theme.colorScheme.secondary
                                          .withOpacity(0.8)
                                      : Get.theme.primaryColor
                                          .withOpacity(0.8)),
                            )
                          : RotatedBox(
                              quarterTurns: 3,
                              child: CustomPaint(
                                size: const Size(16, 16),
                                painter: MessageBody(Colors.grey[200]!),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class MessageBody extends CustomPainter {
  MessageBody(this.color);
  Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
