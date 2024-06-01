import 'package:flutter/material.dart';

class FormInputText extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final String hint;
  final String labelText;
  final String validationMessage;

  const FormInputText({
    required this.textEditingController,
    required this.icon,
    required this.hint,
    required this.labelText,
    required this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hint,
        labelText: labelText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationMessage;
        } else {
          return null;
        }
      },
    );
  }
}
