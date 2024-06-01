import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({this.imageSrc});
  String? imageSrc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Get.find<AppController>().isMan.value == 0
                ? Get.theme.primaryColor
                : Get.theme.colorScheme.secondary),
      ),
      body: Container(
          color: Colors.grey[900],
          width: Get.width,
          height: Get.height,
          child: InteractiveViewer(
            child: Image.network(
              "https://zefaafapi.com/uploadFolder/small/$imageSrc",
              fit: BoxFit.contain,
            ),
          )),
    );
  }
}
