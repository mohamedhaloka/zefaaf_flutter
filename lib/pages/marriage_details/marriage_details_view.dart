import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/pages/marriage_details/marriage_details_controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/country.code.with.phone.number.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

class MarriageDetailsView extends GetView<MarriageDetailsController> {
  const MarriageDetailsView({super.key});
  bool get isMan => controller.appController.isMan.value == 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: Scaffold(
        body: BaseAppHeader(
          backgroundColor: Colors.white,
          headerLength: 100,
          title: Text(
            "تفاصيل طلب الزواج",
            style: Get.textTheme.titleMedium!.copyWith(color: AppTheme.WHITE),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: Get.back,
            ),
          ],
          children: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  CustomTextFormField(
                      controller: controller.title, tittle: "الاسم الحقيقي"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      controller: controller.age, tittle: "العمر"),
                  const SizedBox(height: 20),
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!controller.editPhone.value) ...[
                            CustomTextFormField(
                              controller: TextEditingController(
                                  text: controller.mobile.value),
                              tittle: "رقم الهاتف",
                              readOnly: true,
                            ),
                          ] else ...[
                            CountryCodeWithPhoneNumber(
                              onInputChanged: (PhoneNumber number) {
                                controller.whatsApp.value = number;
                              },
                              borderColor: Colors.grey[300]!,
                              title: 'رقم الواتساب',
                              initialValue: controller.whatsApp,
                              textFieldController: controller.whatsapp,
                            ),
                          ],
                          InkWell(
                            onTap: () => controller
                                .editPhone(!controller.editPhone.value),
                            child: Text(
                              controller.editPhone.value
                                  ? 'العودة لرقم الهاتف القديم'
                                  : 'تعديل رقم الهاتف',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => DropdownRegister(
                      dropdownValue: controller.mariageStatues.value,
                      tittle: "حالتك الإجتماعية",
                      list: isMan
                          ? InputData.socialStatusManList
                          : InputData.socialStatusWomanList,
                      onChange: (val) {
                        controller.mariageStatues.value = val!;
                        controller.mariageKind('');
                        controller.mariageKindId('');

                        if (isMan) {
                          controller.mariageStatuesId.value =
                              chooseSocialStatue(
                                  InputData.socialStatusManList,
                                  InputData.socialStatusManListId,
                                  controller.mariageStatues.value);
                        } else {
                          controller.mariageStatuesId.value =
                              chooseSocialStatue(
                                  InputData.socialStatusWomanList,
                                  InputData.socialStatusWomanListId,
                                  controller.mariageStatues.value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.appController.isMan.value == 0
                          ? controller.mariageStatues.value == "أعزب" ||
                                  controller.mariageStatues.value == ""
                              ? false
                              : true
                          : true,
                      child: DropdownRegister(
                        dropdownValue: controller.mariageKind.value,
                        tittle: "نوع الزواج",
                        list: InputData.kindOfMarriageList,
                        onChange: (val) {
                          controller.mariageKind.value = val!;
                          var index = InputData.kindOfMarriageList
                              .indexOf(controller.mariageKind.value);
                          var kindOfMarriageId =
                              InputData.kindOfMarriageListId.elementAt(index);
                          controller.mariageKindId.value =
                              kindOfMarriageId.toString();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: controller.aboutMe,
                    maxLines: 6,
                    maxLength: 500,
                    tittle: "مواصفاتك بإختصار",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: controller.aboutOther,
                    maxLines: 6,
                    maxLength: 500,
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
                    tittle:
                        "${controller.appController.isMan.value == 0 ? 'وجه' : 'وجهي'} كلمة شكر لفريق العمل",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Obx(() => CustomRaisedButton(
                              loading: controller.updateRequestLoading.value,
                              tittle: "تحديث طلبك",
                              onPress: controller.updateMarriageRequest,
                              color: controller.appController.isMan.value == 0
                                  ? Get.theme.primaryColor
                                  : Get.theme.colorScheme.secondary,
                            )),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Obx(() => CustomRaisedButton(
                              loading: controller.deleteRequestLoading.value,
                              tittle: "حذف طلبك",
                              fontColor: Colors.white,
                              onPress: controller.deleteRequestDialog,
                              color: Colors.red,
                            )),
                      ),
                    ],
                  )
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
}
