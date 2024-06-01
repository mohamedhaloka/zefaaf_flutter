import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/add.story/add.story.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

class AddStory extends GetView<AddStoryController> {
  const AddStory({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: GetX<AddStoryController>(
        init: AddStoryController(),
        builder: (controller) => BaseAppHeader(
          
          headerLength: 100.0,
          title: Text(
            "أضف قصتك",
            style: Get.textTheme.titleMedium!
                .copyWith(color: AppTheme.WHITE, fontSize: 22),
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
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                            tittle: controller.appController.isMan.value == 0
                                ? "اسم زوجتك"
                                : "اسم زوجك",
                            controller: controller.otherUserName.value,
                            onSaved: (val) {
                              controller.otherUserName.value.text = val;
                            }),
                        const CustomSizedBox(
                          heightNum: 0.02,
                          widthNum: 0.0,
                        ),
                        CustomTextFormField(
                          tittle: "قصتكم",
                          controller: controller.story.value,
                          onSaved: (val) {
                            controller.story.value.text = val;
                          },
                          maxLines: 6,
                        ),
                        const CustomSizedBox(
                          heightNum: 0.15,
                          widthNum: 0.0,
                        ),
                        CustomRaisedButton(
                          tittle: "إرسال",
                          loading: controller.loading.value,
                          onPress: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.formKey.currentState!.save();
                              if (controller
                                      .appController.userData.value.userName!
                                      .trim() ==
                                  controller.otherUserName.value.text.trim()) {
                                Get.snackbar("خطأ", "لا يمكنك إضافة قصتك",
                                    backgroundColor:
                                        Get.theme.colorScheme.secondary);
                                return;
                              } else {
                                controller.addSuccessStories(
                                    otherUserName: controller
                                        .otherUserName.value.text
                                        .trim(),
                                    context: context,
                                    story: controller.story.value.text);
                              }
                              //   controller.addSuccessStories(
                              //       otherUserName: controller
                              //           .otherUserName.value.text
                              //           .trim(),
                              //       context: context,
                              //       story: controller.story.value.text);
                            }
                          },
                          color: controller.appController.isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary,
                        )
                      ],
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
