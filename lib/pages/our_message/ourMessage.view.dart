import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

import '../../widgets/app_header.dart';
import 'ourMessage.controller.dart';

class OurMessage extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: GetBuilder<OurMessageController>(
        init: OurMessageController(),
        builder: (controller) => BaseAppHeader(
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Get.back(),
            )
          ],
          title: Text(
            "ourMessage".tr,
            style: Get.textTheme.bodyText2!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          children: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: HtmlWidget(
                      controller.moreController.aboutUs,
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
