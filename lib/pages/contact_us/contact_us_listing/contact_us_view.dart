import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/contact_us/contact_us_listing/contact_us_controller.dart';
import 'package:zeffaf/widgets/app_header.dart';

class ContactUSView extends GetView<ContactUsController> {
  const ContactUSView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: BaseAppHeader(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Get.back(),
          )
        ],
        title: Text(
          "رسائلك",
          style: Get.textTheme.bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: [],
      ),
    );
  }
}
