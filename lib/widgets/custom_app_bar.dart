import 'package:flutter/material.dart';
import 'package:get/get.dart';

customAppBar(tittle, {Color? color, Function? onTap}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 0,
      centerTitle: false,
      title: Text(
        "$tittle",
        style: Get.textTheme.bodyText2!.copyWith(
            color: color ?? Colors.white, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      leading: Container(),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: color ?? Colors.white,
          onPressed: () {
            Get.back();
            if (onTap != null) onTap();
          },
        )
      ],
    ),
  );
}
