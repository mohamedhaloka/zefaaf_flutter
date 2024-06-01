import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import 'chat.list.controller.dart';

class ChatLoader extends GetView<ChatListController> {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return Expanded(
      child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 14, top: 6),
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor:
                            lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                        highlightColor:
                            lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                        child: CircleAvatar(
                          backgroundColor: Get.theme.scaffoldBackgroundColor,
                          radius: 25,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor:
                                  Get.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      const CustomSizedBox(
                        widthNum: 0.03,
                        heightNum: 0.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: lightMode
                                  ? Colors.grey[100]!
                                  : Colors.grey[600]!,
                              highlightColor: lightMode
                                  ? Colors.grey[300]!
                                  : Colors.grey[500]!,
                              child: Container(
                                width: 50,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: lightMode
                                        ? Colors.white
                                        : Colors.grey[500]),
                              ),
                            ),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: lightMode
                                      ? Colors.grey[100]!
                                      : Colors.grey[600]!,
                                  highlightColor: lightMode
                                      ? Colors.grey[300]!
                                      : Colors.grey[500]!,
                                  child: Icon(
                                    Icons.done,
                                    color: Get.theme.primaryColor,
                                    size: 16,
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: lightMode
                                      ? Colors.grey[100]!
                                      : Colors.grey[600]!,
                                  highlightColor: lightMode
                                      ? Colors.grey[300]!
                                      : Colors.grey[500]!,
                                  child: Container(
                                    width: 100,
                                    height: 6,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: lightMode
                                            ? Colors.white
                                            : Colors.grey[500]),
                                  ),
                                ),
                              ],
                            ),
                            Shimmer.fromColors(
                              baseColor: lightMode
                                  ? Colors.grey[100]!
                                  : Colors.grey[600]!,
                              highlightColor: lightMode
                                  ? Colors.grey[300]!
                                  : Colors.grey[500]!,
                              child: Container(
                                width: 44,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: lightMode
                                        ? Colors.white
                                        : Colors.grey[500]),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
