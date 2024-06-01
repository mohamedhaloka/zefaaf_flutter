import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/onboarding/dots.with.button.dart';
import 'package:zeffaf/pages/onboarding/onboarding.controller.dart';
import 'package:zeffaf/pages/onboarding/page.view.content.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  String tittle = "التالي";
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: ExactAssetImage(
                      "assets/images/onboarding/onboarding-bg.jpg"),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.only(
                  left: 18, right: 18, bottom: 26, top: Get.height * 0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      onPageChanged: (val) {
                        controller.pageIndex.value = val;
                        if (val == 3) {
                          Get.offAllNamed('/Login');
                        }
                      },
                      itemCount: 4,
                      controller: pageController,
                      itemBuilder: (context, index) => PageViewContent(
                        index: index,
                      ),
                    ),
                  ),
                  DotsWithButton(
                    pageController: pageController,
                    index: controller.pageIndex.value,
                    onPress: () {
                      Get.offAllNamed('/Login');
                    },
                    lastPage: controller.pageIndex.value == 2,
                    tittle: "تسجيل",
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
