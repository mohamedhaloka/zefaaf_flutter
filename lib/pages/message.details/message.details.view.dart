import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/newMessage.modal.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

import '../user_details/image.viewer.dart';
import 'message.details.controller.dart';

class MessageDetails extends GetView<MessageDetailsController> {
  final NewMessagesModal newMessagesModal;

  bool get fromAdmin => newMessagesModal.owner == 1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MessageDetailsController(),
        builder: (MessageDetailsController controller) => Scaffold(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              body: Obx(
                () => BaseAppHeader(
                  headerLength: 100,
                  title: Text(
                    "تفاصيل الرسالة",
                    style: Get.textTheme.bodyText2!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => Get.back())
                  ],
                  children: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  DateTimeUtil.convertTimeWithDate(
                                      newMessagesModal.messageDateTime),
                                  style: Get.textTheme.bodyText2!.copyWith(
                                      color: controller
                                                  .appController.isMan.value ==
                                              0
                                          ? Get.theme.primaryColor
                                          : Get.theme.colorScheme.secondary),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${newMessagesModal.title}",
                                        style: Get.textTheme.bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.transparent,
                                          border: Border.all(
                                              width: 1,
                                              color: Get.find<AppController>()
                                                          .isMan
                                                          .value ==
                                                      0
                                                  ? Get.theme.primaryColor
                                                  : Get.theme.colorScheme
                                                      .secondary)),
                                      child: Text(
                                        newMessagesModal.messageType,
                                        style: Get.textTheme.caption,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    fromAdmin ? adminImage() : userImage(),
                                    const SizedBox(height: 10),
                                    HtmlWidget(addTagToPhoneNumbers(
                                        newMessagesModal.message ?? '')),
                                    const SizedBox(height: 20),
                                    if (newMessagesModal.reasonId != 4) ...[
                                      const Divider(),
                                      const SizedBox(height: 20),
                                      sendReplyWidget(context),
                                      showReplyWidget(),
                                      const SizedBox(height: 20),
                                      fromAdmin ? userImage() : adminImage(),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            ));
  }

  String addTagToPhoneNumbers(String text) {
    RegExp phoneRegex = RegExp(
        r'(?<!href="http:\/\/wa\.me\/)\+?\d{1,4}?[-.\s]?(\(?\d{1,3}?\)?[-.\s]?)?(\d{1,4}[-.\s]?){1,3}\d{5,}(?![^<]*<\/a>)');

    RegExp waMeRegex = RegExp(r'href="http:\/\/wa\.me\/\d+"');
    String tempPlaceholder = 'WA_ME_PLACEHOLDER';
    List<String> waMeLinks = [];

    String tempText = text.replaceAllMapped(waMeRegex, (match) {
      waMeLinks.add(match.group(0)!);
      return tempPlaceholder;
    });

    String result = tempText.replaceAllMapped(phoneRegex, (match) {
      String phoneNumber = match.group(0)!;
      String cleanNumber = phoneNumber.replaceAll(RegExp(r'[-.\s()]'), '');
      return '<p><a style=\'color: blue; font-weight: bold; \'href=\"tel:$cleanNumber\">$phoneNumber</a></p>';
    });

    int i = 0;
    result = result.replaceAllMapped(RegExp(tempPlaceholder), (match) {
      return waMeLinks[i++];
    });

    return result;
  }

  Widget userImage() => Visibility(
      visible: newMessagesModal.image == "" ? false : true,
      child: InkWell(
        onTap: () =>
            Get.to(() => ImageViewer(imageSrc: newMessagesModal.image)),
        child: Container(
            height: 200,
            width: Get.width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://zefaafapi.com/uploadFolder/small/${newMessagesModal.image}"),
                  fit: BoxFit.cover),
            )),
      ));
  Widget adminImage() => Visibility(
      visible: newMessagesModal.adminImage == "" ? false : true,
      child: InkWell(
        onTap: () {
          Get.to(() => ImageViewer(imageSrc: newMessagesModal.adminImage));
        },
        child: Container(
            height: 200,
            width: Get.width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://zefaafapi.com/uploadFolder/small/${newMessagesModal.adminImage}"),
                  fit: BoxFit.cover),
            )),
      ));

  Widget sendReplyWidget(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Visibility(
      visible: newMessagesModal.owner == 1 && newMessagesModal.reply == null
          ? true
          : false,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إرسال رد",
              style: Get.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              tittle: "الرد",
              controller: controller.replyController,
              onSaved: (val) {
                controller.replyController.text = val;
              },
              maxLines: 5,
            ),
            Container(
              width: Get.width,
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(12)),
              child: controller.attachment.value.path == ''
                  ? chooseImageWidget(lightMode)
                  : imageViewerWidget(),
            ),
            Obx(() => CustomRaisedButton(
                  tittle: "إرسال",
                  loading: controller.loading.value,
                  onPress: () async {
                    await controller.replyMessage(
                      newMessagesModal.id.toString(),
                      controller.replyController.text,
                    );
                    newMessagesModal.reply = controller.replyController.text;
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget showReplyWidget() {
    return Visibility(
      visible: newMessagesModal.reply != null ? true : false,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الرد",
              style: Get.textTheme.bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "${newMessagesModal.reply}",
              style: Get.textTheme.bodyText2!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
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
              onPressed: () {
                controller.attachment(File(''));
              },
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

  const MessageDetails({super.key, required this.newMessagesModal});
}
