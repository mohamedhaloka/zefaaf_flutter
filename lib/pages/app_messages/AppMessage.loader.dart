import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AppMessageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.only(
            right: 8.0, left: 4.0, top: 15.0, bottom: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.cardColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildShimmer(26.0, 26.0, lightMode),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildShimmer(120.0, 15.0, lightMode),
                  const SizedBox(
                    height: 6,
                  ),
                  buildShimmer(50.0, 15.0, lightMode),
                  const SizedBox(
                    height: 6,
                  ),
                  buildShimmer(66.0, 15.0, lightMode)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmer(width, height, lightMode) {
    return Shimmer.fromColors(
      baseColor: lightMode ? Colors.grey[300]! : Colors.grey[700]!,
      highlightColor:
          lightMode ? Get.theme.scaffoldBackgroundColor : Colors.grey[600]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
