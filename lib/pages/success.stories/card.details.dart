import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/time.dart';

class CardDetails extends StatelessWidget {
  CardDetails({required this.story, required this.storyDate});
  String story, storyDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 14, right: 14, bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${DateTimeUtil.convertTimeWithDate(storyDate)}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              story,
              style: Get.textTheme.bodyText2!.copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
