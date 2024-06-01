import 'package:flutter/material.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class ConfirmNewPasswordHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/confirm_new_password/secure.png",
          width: 80,
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.04,
        ),
        const Text(
          "تغيير كلمة المرور",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.05,
        ),
      ],
    );
  }
}
