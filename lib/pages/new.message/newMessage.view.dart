import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

import '../../utils/input_data.dart';
import '../../utils/toast.dart';
import '../../utils/upgrade_package_dialog.dart';
import '../../widgets/country.code.with.phone.number.dart';
import '../../widgets/drop_down_register.dart';
import 'newMessage.controller.dart';

class NewMessage extends GetView<NewMessageController> {
  NewMessage({this.complaint, this.otherId, this.packageId});
  bool? complaint;
  String? otherId;
  String? packageId;
  final double appBarHeight = 100;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    // get user
    return Scaffold(
      body: GetX<NewMessageController>(
        init: NewMessageController(),
        builder: (controller) => BaseAppHeader(
          headerLength: appBarHeight,
          title: Text(
            "طلب زواج",
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // DropdownRegister(
                        //   dropdownValue: complaint ?? false
                        //       ? "شكوى"
                        //       : controller.messageType.value,
                        //   tittle: "نوع الرسالة",
                        //   list: InputData.messageTypeSelections,
                        //   onChange: (val) {
                        //     controller.messageType.value = val!;
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // country
                        CustomTextFormField(
                            controller: controller.title.value,
                            onSaved: (text) {
                              controller.title.value.text = text;
                            },
                            tittle: "الاسم الحقيقي"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            controller: controller.age,
                            onSaved: (text) {
                              controller.age.text = text;
                            },
                            tittle: "العمر"),

                        const SizedBox(
                          height: 20,
                        ),
                        CountryCodeWithPhoneNumber(
                          onInputChanged: (PhoneNumber number) {
                            controller.whatsApp.value = number;
                            print(number.phoneNumber);
                          },
                          borderColor: Colors.grey[300]!,
                          title: 'رقم الواتساب',
                          initialValue: controller.whatsApp,
                          textFieldController: controller.whatsapp,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownRegister(
                          dropdownValue: controller.socialStatus.value,
                          tittle: "حالتك الإجتماعية",
                          list: controller.appController.isMan.value == 0
                              ? InputData.socialStatusManList
                              : InputData.socialStatusWomanList,
                          onChange: (val) {
                            controller.socialStatus.value = val!;

                            if (controller.appController.isMan.value == 0) {
                              controller.socialStatusId.value =
                                  chooseSocialStatue(
                                      InputData.socialStatusManList,
                                      InputData.socialStatusManListId,
                                      controller.socialStatus.value);
                            } else {
                              controller.socialStatusId.value =
                                  chooseSocialStatue(
                                      InputData.socialStatusWomanList,
                                      InputData.socialStatusWomanListId,
                                      controller.socialStatus.value);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: controller.appController.isMan.value == 0
                              ? controller.socialStatus.value == "أعزب" ||
                                      controller.socialStatus.value == ""
                                  ? false
                                  : true
                              : true,
                          child: DropdownRegister(
                            dropdownValue: controller.kindOfMarriage.value,
                            tittle: "نوع الزواج",
                            list: InputData.kindOfMarriageList,
                            onChange: (val) {
                              controller.kindOfMarriage.value = val!;
                              var index = InputData.kindOfMarriageList
                                  .indexOf(controller.kindOfMarriage.value);
                              var kindOfMarriageId = InputData
                                  .kindOfMarriageListId
                                  .elementAt(index);
                              controller.kindOfMarriageId.value =
                                  kindOfMarriageId.toString();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          controller: controller.aboutMe.value,
                          maxLines: 6,
                          maxLength: 500,
                          onSaved: (text) {
                            controller.aboutMe.value.text = text;
                          },
                          tittle: "مواصفاتك بإختصار",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          controller: controller.aboutOther,
                          maxLines: 6,
                          maxLength: 500,
                          onSaved: (text) {
                            controller.aboutOther.text = text;
                          },
                          tittle:
                              "مواصفات ${controller.appController.isMan.value == 0 ? 'زوجتي ' : 'زوجي '}على زفاف ",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          controller: controller.thanksMessage,
                          maxLines: 6,
                          maxLength: 500,
                          //مصر
                          //مدغشقر
                          onSaved: (text) {
                            controller.thanksMessage.text = text;
                          },
                          tittle:
                              "${controller.appController.isMan.value == 0 ? 'وجه' : 'وجهي'} كلمة شكر لفريق العمل",
                        ),
                        // Container(
                        //   width: 150,
                        //   height: 150,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(width: 1),
                        //       borderRadius: BorderRadius.circular(12)),
                        //   child: controller.image.value.path == ''
                        //       ? chooseImageWidget(lightMode)
                        //       : imageViewerWidget(),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // const Text(
                        //   "إختيار صورة غير إجباري*",
                        //   style: TextStyle(color: Colors.red),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomRaisedButton(
                    loading: controller.loading.value,
                    tittle: "إرسال طلبك",
                    onPress: () {
                      if (controller
                              .appController.userData.value.packageLevel! ==
                          11) {
                        showUpgradePackageDialog(
                            controller.appController.isMan.value == 0,
                            shouldUpgradeToPlatinumPackage);
                        return;
                      }
                      if (formKey.currentState!.validate() &&
                          controller.socialStatusId.isNotEmpty &&
                          // controller.kindOfMarriageId.isNotEmpty &&
                          controller.thanksMessage.text.isNotEmpty &&
                          controller.aboutOther.text.isNotEmpty &&
                          controller.whatsapp.text.isNotEmpty &&
                          controller.age.text.isNotEmpty) {
                        formKey.currentState!.save();
                        controller.sendMessages();
                        // if (complaint ?? false) {

                        Get.back();

                        // }
                      } else {
                        showToast("يجب ملئ جميع تفاصيل الرسالة");
                      }
                    },
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  chooseSocialStatue(list, listId, value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
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
