import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../widgets/country.code.with.phone.number.dart';
import 'request.change.password.controller.dart';

class RequestChangePasswordForm
    extends GetView<RequestChangePasswordController> {
  RequestChangePasswordForm({super.key});
  @override
  Widget build(BuildContext context) {
    return MixinBuilder<RequestChangePasswordController>(
      init: RequestChangePasswordController(),
      builder: (RequestChangePasswordController controller) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "نسيت كلمة المرور .. لا داعي للقلق",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        const CustomSizedBox(heightNum: 0.018, widthNum: 0.0),
        CountryCodeWithPhoneNumber(
          onInputChanged: (PhoneNumber number) {
            controller.mobilePhone.selection = TextSelection.collapsed(
                offset: controller.mobilePhone.text.length);

            controller.number.value = number;
            controller.mobile.value = number.phoneNumber!;
            controller.countryNetworkCode.value = number.dialCode!;
          },
          onInputValidated: (bool value) {
            controller.rightFormat(value);
          },
          validator: (val) {
            if (val != null) {
              if (val.isEmpty) {
                return "حقل رقم الموبايل مطلوب*";
              }
            }
            return '';
          },
          initialValue: controller.number,
          textFieldController: controller.mobilePhone,
          onSaved: (PhoneNumber number) {},
        ),
        const CustomSizedBox(heightNum: 0.16, widthNum: 0.0),
        CustomRaisedButton(
            loading: controller.loading.value,
            tittle: "تأكيد",
            onPress: () {
              controller.checkPhoneNumber();
            })
      ]),
    );
  }
}
