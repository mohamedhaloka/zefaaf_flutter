import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.status.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class SocialStatue extends GetView<SocialStatusController> {
  const SocialStatue({required this.gender, super.key});
  final int gender;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "الحالة الإجتماعية",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              CustomTextFormField(
                  controller: controller.age,
                  onSaved: (val) {
                    controller.age.text = val;
                  },
                  maxLength: 2,
                  tittle: "العمر"),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: DropdownRegister(
                        dropdownValue: controller.socialStatus.value,
                        tittle: "الحالة الإجتماعية",
                        list: gender == 0
                            ? InputData.socialStatusManList
                            : InputData.socialStatusWomanList,
                        onChange: (val) {
                          controller.socialStatus.value = val!;

                          if (gender == 0) {
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
                    ),
                  ),
                  controller.socialStatus.value == "أعزب" ||
                          controller.socialStatus.value == "آنسة" ||
                          controller.socialStatus.value == ""
                      ? const SizedBox()
                      : const CustomSizedBox(heightNum: 0.0, widthNum: 0.025),
                  Visibility(
                    visible: controller.socialStatus.value == "أعزب" ||
                            controller.socialStatus.value == "آنسة" ||
                            controller.socialStatus.value == ""
                        ? false
                        : true,
                    child: Expanded(
                        child: CustomTextFormField(
                            controller: controller.numberOfKids,
                            onSaved: (val) {
                              controller.numberOfKids.text = val;
                            },
                            maxLength: 2,
                            tittle: "عدد الأطفال")),
                  )
                ],
              ),
              CustomSizedBox(
                  heightNum: gender == 0 ? 0.01 : 0.0, widthNum: 0.0),
              Visibility(
                visible: gender == 0
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
                    var kindOfMarriageId =
                        InputData.kindOfMarriageListId.elementAt(index);
                    controller.kindOfMarriageId.value =
                        kindOfMarriageId.toString();
                  },
                ),
              )
            ],
          ),
        ));
  }

  chooseSocialStatue(list, listId, value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
  }
}
