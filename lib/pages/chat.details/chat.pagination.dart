import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginationLoadMessages extends StatelessWidget {
  PaginationLoadMessages(this.fetch);
  bool fetch;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Visibility(
          visible: fetch,
          child: Container(
            padding: const EdgeInsets.all(6),
            width: Get.width,
            color: Get.theme.scaffoldBackgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("جارى تحميل المزيد من الرسائل"),
                SizedBox(
                  width: 6,
                ),
                CircularProgressIndicator(),
              ],
            ),
          )),
    );
  }
}
