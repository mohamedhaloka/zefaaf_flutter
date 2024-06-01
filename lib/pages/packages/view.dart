import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/packages/packages.controller.dart';
import 'package:zeffaf/pages/packages/packages.option.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/progress.dart';

class Packages extends GetView<PackagesController> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: GetX<PackagesController>(
        init: PackagesController(),
        builder: (controller) => Scaffold(
          body: BaseAppHeader(
            backgroundColor: Colors.white,
            headerLength: 100,
            title: Text(
              "الباقات",
              style: Get.textTheme.titleMedium!.copyWith(color: AppTheme.WHITE),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
            children: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const CustomSizedBox(heightNum: 0.03, widthNum: 0.0),
                    controller.fetching.value == true
                        ? Center(
                            child: circularDefaultProgress(context),
                          )
                        : PackagesOption(pageController)
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
