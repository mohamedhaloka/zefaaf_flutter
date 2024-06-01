import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AutoSearchSettingLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
            highlightColor: lightMode ? Colors.grey[300]! : Colors.grey[500]!,
            child: Icon(
              Icons.settings,
              size: 160,
              color: lightMode ? Colors.grey[800] : Colors.grey[200],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Shimmer.fromColors(
              baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
              highlightColor: lightMode ? Colors.grey[300]! : Colors.grey[500]!,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    height: 16,
                    decoration: BoxDecoration(
                        color: lightMode ? Colors.grey[100] : Colors.grey[500],
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: Get.width * 0.5,
                    height: 16,
                    decoration: BoxDecoration(
                        color: lightMode ? Colors.grey[100] : Colors.grey[500],
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
