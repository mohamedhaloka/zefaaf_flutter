import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/ask.about.his.life/ask.about.his.life.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class ReligiousCommitment extends GetView<AskAboutHisLifeController> {
  ReligiousCommitment(this.gender, {super.key});
  int gender;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text(
                  "الصلاة",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              DropdownRegister(
                dropdownValue: controller.pray.value,
                tittle: "الصلاة",
                list: InputData.prayList,
                onChange: (val) {
                  controller.pray.value = val!;
                  var index = InputData.prayList.indexOf(controller.pray.value);
                  var prayId = InputData.prayListId.elementAt(index);
                  controller.prayId.value = prayId.toString();
                },
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              Visibility(
                visible: gender == 0 ? false : true,
                child: DropdownRegister(
                  dropdownValue: controller.barrier.value,
                  tittle: "الحجاب",
                  list: InputData.barrierList,
                  onChange: (val) {
                    controller.barrier.value = val!;
                    var index =
                        InputData.barrierList.indexOf(controller.barrier.value);
                    var barrierId = InputData.barrierListId.elementAt(index);
                    controller.barrierId.value = barrierId.toString();
                  },
                ),
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "التدخين",
                    style: TextStyle(color: Colors.black),
                  ),
                  Row(
                    children: [
                      checkboxOptions(
                          tittle: "نعم",
                          onChange: (val) {
                            if (val) {
                              controller.yes(val);
                              controller.no(!val);
                              controller.smoking = val;
                            } else {
                              controller.yes(!val);
                              controller.no(val);
                              controller.smoking = !val;
                            }
                          },
                          value: controller.yes.value),
                      const CustomSizedBox(heightNum: 0.0, widthNum: 0.01),
                      checkboxOptions(
                          tittle: "لا",
                          onChange: (val) {
                            if (val) {
                              controller.yes(!val);
                              controller.no(val);
                              controller.smoking = !val;
                            } else {
                              controller.yes(val);
                              controller.no(!val);
                              controller.smoking = val;
                            }
                          },
                          value: controller.no.value),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  checkboxOptions({tittle, onChange, value}) {
    return Row(
      children: [
        Text(
          "$tittle",
          style: const TextStyle(color: Colors.black),
        ),
        Checkbox(
          onChanged: onChange,
          value: value,
        )
      ],
    );
  }
}
