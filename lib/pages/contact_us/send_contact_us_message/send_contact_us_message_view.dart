import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/contact_us/send_contact_us_message/send_contact_us_message_controller.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class SendContactUSMessageView extends GetView<SendContactUSMessageController> {
  const SendContactUSMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
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
          "رسالة",
          style: Get.textTheme.bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Obx(() => DropdownRegister(
                      dropdownValue: controller.reasonID.value,
                      tittle: "نوع الرسالة",
                      list: MessageType.values.map((e) => e.name).toList(),
                      onChange: (val) => controller.reasonID(val),
                    )),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "عنوان الرسالة",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
                CustomTextFormField(
                  controller: controller.title,
                  onSaved: (val) => controller.title.text = val,
                  tittle: 'اكتب هنا',
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "الرسالة",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
                CustomTextFormField(
                  controller: controller.message,
                  onSaved: (val) => controller.message.text = val,
                  tittle: 'اكتب هنا',
                  maxLines: 9,
                ),
                const SizedBox(height: 18),
                Obx(() => Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: controller.attachment.value.path == ''
                          ? chooseImageWidget(lightMode)
                          : imageViewerWidget(),
                    )),
                const SizedBox(height: 10),
                const Text(
                  "إختيار صورة غير إجباري*",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 35),
                Obx(
                  () => CustomRaisedButton(
                    loading: controller.sendMessageLoading.value,
                    tittle: "إرسال طلبك",
                    onPress: controller.sendMessage,
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary,
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget chooseImageWidget(lightMode) {
    return InkWell(
      onTap: controller.getImage,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: lightMode ? Colors.black38 : Colors.white38),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo,
              color: lightMode ? Colors.white : Colors.grey[900],
            ),
            Text(
              "إختر الصورة",
              style:
                  TextStyle(color: lightMode ? Colors.white : Colors.grey[900]),
            )
          ],
        ),
      ),
    );
  }

  Widget imageViewerWidget() {
    return Stack(
      children: [
        Center(child: Image.file(controller.attachment.value)),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: 20,
            height: 20,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () => controller.attachment(File('')),
              child: const Icon(
                Icons.close,
                size: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
