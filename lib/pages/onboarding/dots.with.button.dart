import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DotsWithButton extends StatelessWidget {
  DotsWithButton(
      {required this.pageController,
      required this.onPress,
      required this.lastPage,
      required this.index,
      required this.tittle});
  PageController pageController;
  Function onPress;
  String tittle;
  bool lastPage;
  int index;

  @override
  Widget build(BuildContext context) {
    return index == 3
        ? const SizedBox()
        : lastPage
            ? SizedBox(
                // width: 100,
                // height: 40,
                child: ElevatedButton(
                  onPressed: () => onPress(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0.0,
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: Text(
                    tittle,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            : SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Get.theme.primaryColor,
                  expansionFactor: 2.5,
                  strokeWidth: 6,
                  dotWidth: 8,
                  dotHeight: 8,
                  // activeDotColor:
                ),
              );
  }
}
