import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/city.list/view.dart';
import 'package:zeffaf/pages/edit_account/controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

import '../register/widgets/container.box.dart';

class EditAccountView extends GetView<EditAccountController> {
  const EditAccountView({super.key});

  bool get isMan => controller.appController.isMan.value == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الحساب'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Obx(
            () => ContainerBox(
              onPress: () {
                Get.to(() => CityListView(
                      visibleToSearch: false,
                      cityList: controller.cityListController.cityDataList,
                    ));
              },
              tittle: "المدينة",
              countryName: controller.cityListController.cityName.value,
              imgSrc: "none",
              countryCode: controller.cityListController.cityName.value == ""
                  ? false
                  : true,
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => DropdownRegister(
              dropdownValue: controller.mariageStatues.value,
              tittle: "الحالة الإجتماعية",
              list: isMan
                  ? InputData.socialStatusManList
                  : InputData.socialStatusWomanList,
              onChange: (val) {
                controller.mariageStatues.value = val!;

                if (isMan) {
                  controller.mariageStatuesId.value = chooseSocialStatue(
                      InputData.socialStatusManList,
                      InputData.socialStatusManListId,
                      controller.mariageStatues.value);
                } else {
                  controller.mariageStatuesId.value = chooseSocialStatue(
                      InputData.socialStatusWomanList,
                      InputData.socialStatusWomanListId,
                      controller.mariageStatues.value);
                }
              },
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => DropdownRegister(
              dropdownValue: controller.mariageKind.value,
              tittle: "نوع الزواج",
              list: InputData.kindOfMarriageList,
              onChange: (val) {
                controller.mariageKind.value = val!;
                var index = InputData.kindOfMarriageList
                    .indexOf(controller.mariageKind.value);
                var kindOfMarriageId =
                    InputData.kindOfMarriageListId.elementAt(index);
                controller.mariageKindId.value = kindOfMarriageId.toString();
              },
            ),
          ),
          const SizedBox(height: 18),
          Obx(() => DropdownRegister(
                dropdownValue: controller.workField.value,
                tittle: "مجال العمل",
                list: InputData.jobList,
                onChange: (val) {
                  controller.workField.value = val!;
                  var index =
                      InputData.jobList.indexOf(controller.workField.value);
                  var employmentId = InputData.jobListId.elementAt(index);
                  controller.workFieldId.value = employmentId.toString();
                },
              )),
          const SizedBox(height: 18),
          CustomTextFormField(
            controller: controller.jobController,
            onSaved: (val) => controller.jobController.text = val,
            maxLength: 40,
            tittle: "الوظيفة",
          ),
          const SizedBox(height: 18),
          Obx(
            () => DropdownRegister(
              dropdownValue: controller.income.value,
              tittle: "مستوى الدخل الشهري",
              list: InputData.monthlyIncomeLevelList,
              onChange: (val) {
                controller.income(val);
                var index = InputData.monthlyIncomeLevelList
                    .indexOf(controller.income.value);
                var monthlyIncomeLevelId =
                    InputData.monthlyIncomeLevelListId.elementAt(index);
                controller.incomeId.value = monthlyIncomeLevelId.toString();
              },
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "مواصفات شريك حياتك",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          CustomTextFormField(
            controller: controller.aboutOtherController,
            onSaved: (val) => controller.aboutOtherController.text = val,
            tittle:
                "يرجى اختيار كلمات تليق ${isMan ? 'بزوجتك المستقبلية' : 'بزوجك المستقبلي'}",
            maxLines: 9,
            maxLength: 200,
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "تحدث عن نفسك",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          CustomTextFormField(
            controller: controller.aboutMeController,
            onSaved: (val) => controller.aboutMeController.text = val,
            tittle:
                "يرجى اختيار كلمات تليق بأخلاقك ${isMan ? 'كمسلم' : 'كمسلمة'}",
            maxLines: 9,
            maxLength: 200,
          ),
          const SizedBox(height: 25),
          Obx(() => CustomRaisedButton(
                tittle: "تحديث البيانات",
                loading: controller.loading.value,
                onPress: controller.updateProfile,
              )),
        ],
      ),
    );
  }

  chooseSocialStatue(list, listId, value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
  }
}
