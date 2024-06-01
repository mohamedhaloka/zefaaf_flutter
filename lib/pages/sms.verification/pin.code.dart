import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatelessWidget {
  PinCode({required this.onChange, required this.onCompleted});

  ValueChanged<String> onChange, onCompleted;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        autoFocus: true,
        enablePinAutofill: true,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 0,
          borderRadius: BorderRadius.circular(5),
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[200],
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey[200],
          selectedFillColor: Colors.blue[700],
        ),
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        onCompleted: onCompleted,
        onChanged: onChange,
      ),
    );
  }
}
