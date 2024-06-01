import 'package:flutter/material.dart';

class AppMessageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Image.asset('assets/images/banner.png'));
  }

  //Column(
  //         children: [
  //           Text(
  //             "للاقتراحات والمشاكل الفنية الخاصة بالتطبيق يرجى التواصل: ",
  //             textAlign: TextAlign.center,
  //             style: Get.theme.textTheme.caption!
  //                 .copyWith(color: Colors.white, fontSize: 13),
  //           ),
  //           const SizedBox(
  //             height: 4,
  //           ),
  //           InkWell(
  //             onTap: () {
  //               _sendMail();
  //             },
  //             child: Text(
  //               "Support@zefaaf.net",
  //               style: Get.theme.textTheme.bodyText2!.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   decoration: TextDecoration.underline),
  //             ),
  //           ),
  //         ],
  //       )

}
