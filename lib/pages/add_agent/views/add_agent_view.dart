import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/pages/country.code/view.dart';
import 'package:zeffaf/pages/register/widgets/container.box.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/country.code.with.phone.number.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

import '../controllers/add_agent_controller.dart';

class AddAgentView extends GetView<AddAgentController> {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: BaseAppHeader(
        headerLength: 100,
        title: Text(
          "add_agents".tr,
          style: Get.textTheme.bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Get.back();
            },
          ),
        ],
        children: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    controller: controller.agentName, tittle: "الاسم"),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    controller: controller.agentEmail,
                    textInput: TextInputType.emailAddress,
                    tittle: "البريد الإلكتروني"),
                const SizedBox(
                  height: 20,
                ),
                CountryCodeWithPhoneNumber(
                  onInputChanged: (PhoneNumber number) {
                    controller.phoneNumber.value = number;
                  },
                  borderColor: Colors.grey[300]!,
                  initialValue: controller.phoneNumber,
                  textFieldController: controller.agentMobile,
                ),
                const SizedBox(
                  height: 20,
                ),
                CountryCodeWithPhoneNumber(
                  onInputChanged: (PhoneNumber number) {
                    controller.whatsApp.value = number;
                  },
                  borderColor: Colors.grey[300]!,
                  title: 'رقم الواتساب',
                  initialValue: controller.whatsApp,
                  textFieldController: controller.agentWhats,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => ContainerBox(
                      onPress: () {
                        Get.to(() => CountryCode(
                              visible: false,
                              visibleToSearch: false,
                              type: "nationality",
                            ));
                      },
                      countryCode: controller.countryCodeController
                                  .nationalityName.value ==
                              ""
                          ? false
                          : true,
                      imgSrc: controller
                          .countryCodeController.nationalityImage.value
                          .toLowerCase(),
                      tittle: "الجنسية",
                      countryName: controller
                          .countryCodeController.nationalityName.value,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "قم بإختيار صورة الهوية أو جواز السفر",
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Obx(() => controller.image.value.path == ''
                      ? chooseImageWidget(lightMode)
                      : imageViewerWidget()),
                ),
                const SizedBox(
                  height: 40,
                ),
                Obx(() => CustomRaisedButton(
                      loading: controller.loading.value,
                      tittle: "send".tr,
                      onPress: () {
                        controller.validateAddAgent(
                            controller.image.value.path == ''
                                ? ''
                                : controller.image.value.path,
                            context);
                      },
                      color: controller.appController.isMan.value == 0
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.secondary,
                    )),
              ]),
            ),
          )
        ],
      ),
    );
  }

  chooseImageWidget(lightMode) {
    return InkWell(
      onTap: () {
        controller.getImage();
      },
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
        Center(child: Image.file(controller.image.value)),
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
                controller.image(File(''));
                controller.pickedFile = null;
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
}
