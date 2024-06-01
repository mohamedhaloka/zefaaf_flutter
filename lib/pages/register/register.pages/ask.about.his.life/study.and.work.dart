import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/register/register.pages/ask.about.his.life/ask.about.his.life.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class WorkAndStudy extends GetView<AskAboutHisLifeController> {
  const WorkAndStudy({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          // color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "الدراسة والعمل",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              DropdownRegister(
                dropdownValue: controller.educationalQualification.value,
                tittle: "المؤهل التعليمي",
                list: InputData.educationalQualificationList,
                onChange: (val) {
                  controller.educationalQualification.value = val!;
                  var index = InputData.educationalQualificationList
                      .indexOf(controller.educationalQualification.value);
                  var educationalQualificationId =
                      InputData.educationalQualificationListId.elementAt(index);
                  controller.educationalQualificationId.value =
                      educationalQualificationId.toString();
                },
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              DropdownRegister(
                dropdownValue: controller.financialStatus.value,
                tittle: "الوضع المادي",
                list: InputData.financialStatusList,
                onChange: (val) {
                  controller.financialStatus.value = val!;
                  var index = InputData.financialStatusList
                      .indexOf(controller.financialStatus.value);
                  var financialStatusId =
                      InputData.financialStatusListId.elementAt(index);
                  controller.financialStatusId.value =
                      financialStatusId.toString();
                },
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              DropdownRegister(
                dropdownValue: controller.employment.value,
                tittle: "مجال العمل",
                list: InputData.jobList,
                onChange: (val) {
                  controller.employment.value = val!;
                  var index =
                      InputData.jobList.indexOf(controller.employment.value);
                  var employmentId = InputData.jobListId.elementAt(index);
                  controller.employmentId.value = employmentId.toString();
                },
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              CustomTextFormField(
                  controller: controller.job,
                  onSaved: (val) {
                    controller.job.text = val;
                  },
                  maxLength: 40,
                  tittle: "الوظيفة"),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              DropdownRegister(
                dropdownValue: controller.monthlyIncomeLevel.value,
                tittle: "مستوى الدخل الشهري",
                list: InputData.monthlyIncomeLevelList,
                onChange: (val) {
                  controller.monthlyIncomeLevel.value = val!;
                  var index = InputData.monthlyIncomeLevelList
                      .indexOf(controller.monthlyIncomeLevel.value);
                  var monthlyIncomeLevelId =
                      InputData.monthlyIncomeLevelListId.elementAt(index);
                  controller.monthlyIncomeLevelId.value =
                      monthlyIncomeLevelId.toString();
                },
              ),
            ],
          ),
        ));
  }
}
