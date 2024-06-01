import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

import 'auto.search.setting.controller.dart';

class AutoSearchSettingsSliders extends GetView<AutoSearchSettingController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "العمر",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.ageFrom.value,
                        tittle: "من",
                        list: InputData.ageList,
                        onChange: (val) {
                          controller.ageFrom.value = val!;
                        },
                      ),
                    ),
                    const CustomSizedBox(
                      widthNum: 0.025,
                      heightNum: 0.0,
                    ),
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.ageTo.value,
                        tittle: "إلى",
                        list: InputData.ageList,
                        onChange: (val) {
                          controller.ageTo.value = val!;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "الوزن",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.weightFrom.value,
                        tittle: "من",
                        list: InputData.widthList,
                        onChange: (val) {
                          controller.weightFrom.value = val!;
                        },
                      ),
                    ),
                    const CustomSizedBox(
                      widthNum: 0.025,
                      heightNum: 0.0,
                    ),
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.weightTo.value,
                        tittle: "إلى",
                        list: InputData.widthList,
                        onChange: (val) {
                          controller.weightTo.value = val!;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "الطول",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.heightFrom.value,
                        tittle: "من",
                        list: InputData.heightList,
                        onChange: (val) {
                          controller.heightFrom.value = val!;
                        },
                      ),
                    ),
                    const CustomSizedBox(
                      widthNum: 0.025,
                      heightNum: 0.0,
                    ),
                    Expanded(
                      child: DropdownRegister(
                        dropdownValue: controller.heightTo.value,
                        tittle: "إلى",
                        list: InputData.heightList,
                        onChange: (val) {
                          controller.heightTo.value = val!;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
