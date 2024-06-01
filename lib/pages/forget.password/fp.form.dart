import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/pages/forget.password/forget.password.controller.dart';
import 'package:zeffaf/widgets/country.code.with.phone.number.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../utils/toast.dart';

class ForgetPasswordForm extends GetView<ForgetPasswordController> {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MixinBuilder<ForgetPasswordController>(
      init: ForgetPasswordController(),
      builder: (controller) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const CustomSizedBox(heightNum: 0.018, widthNum: 0.0),
        CountryCodeWithPhoneNumber(
          
          // borderColor: Colors.grey[300],
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
              goToSMSVerification(context);
            }),
      ]),
    );
  }

  goToSMSVerification(context) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (controller.rightFormat.value) {
          controller.writeMobileNumber(controller.mobilePhone.text);
          controller.writeCountryCode(controller.countryNetworkCode.value);

          if (controller.number.value.isoCode == "YE") {
            Get.offAllNamed('/RegisterLandingView');
            return;
          }
          controller.checkNumber(
            context,
            controller.number.value.parseNumber(),
          );
        } else {
          showToast("تأكد من رقم الهاتف وأعد المحاولة");
        }
      } else {
        showToast("يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
      }
    } catch (e) {}
  }
}
