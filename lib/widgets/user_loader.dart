import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UserLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Get.theme.cardColor),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 5, top: 15, bottom: 15),
                  child: Shimmer.fromColors(
                    baseColor:
                        lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                    highlightColor:
                        lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              lightMode ? Colors.grey[100] : Colors.grey[500]),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Shimmer.fromColors(
                            baseColor: lightMode
                                ? Colors.grey[100]!
                                : Colors.grey[600]!,
                            highlightColor: lightMode
                                ? Colors.grey[300]!
                                : Colors.grey[500]!,
                            child: Container(
                              width: 45,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: lightMode
                                      ? Colors.white
                                      : Colors.grey[500]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Shimmer.fromColors(
                      baseColor:
                          lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                      highlightColor:
                          lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                      child: Container(
                        width: 70,
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightMode
                                ? Colors.grey[100]
                                : Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Shimmer.fromColors(
                      baseColor:
                          lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                      highlightColor:
                          lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                      child: Container(
                        width: 50,
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightMode
                                ? Colors.grey[100]
                                : Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Shimmer.fromColors(
                      baseColor:
                          lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                      highlightColor:
                          lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                      child: Container(
                        width: 30,
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightMode
                                ? Colors.grey[100]
                                : Colors.grey[500]),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
              child: Shimmer.fromColors(
                baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                highlightColor:
                    lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                child: Container(
                  width: 100,
                  height: 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
