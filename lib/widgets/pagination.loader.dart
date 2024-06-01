import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginationLoader extends StatelessWidget {
  PaginationLoader(this.fetch);
  bool fetch;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
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
                Text("جارى تحميل المزيد"),
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
