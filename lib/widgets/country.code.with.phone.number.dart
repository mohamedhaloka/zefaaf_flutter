import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/login/login.controller.dart';

class CountryCodeWithPhoneNumber extends GetView<LoginController> {
  const CountryCodeWithPhoneNumber(
      {this.onSaved,
      required this.initialValue,
      this.onInputChanged,
      this.title,
      this.borderColor,
      this.onInputValidated,
      required this.textFieldController,
      this.validator,
      super.key});
  final String Function(String?)? validator;
  final ValueChanged<PhoneNumber>? onSaved, onInputChanged;
  final ValueChanged<bool>? onInputValidated;
  final TextEditingController textFieldController;
  final Rx<PhoneNumber> initialValue;
  final String? title;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Directionality(
          textDirection: TextDirection.ltr,
          child: InternationalPhoneNumberInput(
            inputDecoration: InputDecoration(
                hintText: title ?? "رقم الموبايل",
                hintStyle: const TextStyle(fontSize: 14),
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!))),
            onInputChanged: onInputChanged,
            onInputValidated: onInputValidated,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            locale: 'ar',
            cursorColor: Colors.black,
            countries: Get.find<AppController>().countriesCode.isEmpty
                ? ['AG']
                : Get.find<AppController>().countriesCode,
            validator: validator,
            textAlign: TextAlign.left,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle:
                const TextStyle(color: Colors.black, fontSize: 14),
            hintText: title ?? "رقم الموبايل",
            initialValue: initialValue.value,
            textFieldController: textFieldController,
            formatInput: false,
            textStyle: const TextStyle(fontSize: 14),
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            onSaved: onSaved,
          ),
        ));
  }
}
