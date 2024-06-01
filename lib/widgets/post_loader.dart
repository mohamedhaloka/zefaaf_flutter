import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class PostsLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.mediaQuery.size.width,
              height: 200,
              child: Shimmer.fromColors(
                  baseColor: lightMode ? Colors.grey[400]! : Colors.grey[600]!,
                  highlightColor:
                      lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: lightMode ? Colors.grey[100] : Colors.grey[500],
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                      baseColor:
                          lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                      highlightColor:
                          lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                      child: Container(
                        width: 130,
                        height: 14,
                        decoration: BoxDecoration(
                            color:
                                lightMode ? Colors.grey[100] : Colors.grey[500],
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                      baseColor:
                          lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                      highlightColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[300]!
                              : Colors.grey[500]!,
                      child: Container(
                        width: 80,
                        height: 14,
                        decoration: BoxDecoration(
                            color:
                                lightMode ? Colors.grey[100] : Colors.grey[500],
                            borderRadius: BorderRadius.circular(20)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
