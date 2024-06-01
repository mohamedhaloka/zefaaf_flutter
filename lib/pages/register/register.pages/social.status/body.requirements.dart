import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.status.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class BodyRequirements extends GetView<SocialStatusController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "المواصفات الجسدية",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                        controller: controller.width,
                        onSaved: (val) {
                          controller.width.text = val;
                        },
                        maxLength: 3,
                        tittle: "الوزن"),
                  ),
                  const CustomSizedBox(
                    widthNum: 0.025,
                    heightNum: 0.0,
                  ),
                  Expanded(
                    child: CustomTextFormField(
                        controller: controller.height,
                        onSaved: (val) {
                          controller.height.text = val;
                        },
                        maxLength: 3,
                        tittle: "الطول"),
                  ),
                ],
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              DropdownRegister(
                dropdownValue: controller.skinColour.value,
                tittle: "لون البشرة",
                list: InputData.skinColourList,
                onChange: (val) {
                  controller.skinColour.value = val!;
                  var index = InputData.skinColourList
                      .indexOf(controller.skinColour.value);
                  var skinColourId =
                      InputData.skinColourListId.elementAt(index);
                  controller.skinColourId.value = skinColourId.toString();
                },
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              DropdownRegister(
                dropdownValue: controller.healthStatus.value,
                tittle: "الحالة الصحية",
                list: InputData.healthStatusList,
                onChange: (val) {
                  controller.healthStatus.value = val!;
                  var index = InputData.healthStatusList
                      .indexOf(controller.healthStatus.value);
                  var healthStatusId =
                      InputData.healthStatusListId.elementAt(index);
                  controller.healthStatusId.value = healthStatusId.toString();
                },
              ),
            ],
          ),
        ));
  }
}
