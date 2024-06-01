import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class CityLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Expanded(
      child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => drawCity(
              index.isEven
                  ? 140.0
                  : index == 5 || index == 12
                      ? 170.0
                      : index == 2 || index == 7
                          ? 70.0
                          : index == 10 || index == 1
                              ? 42.0
                              : 56.0,
              lightMode)),
    );
  }

  drawCity(wid, lightMode) {
    return Column(
      children: [
        Row(
          children: [
            const CustomSizedBox(
              widthNum: 0.02,
              heightNum: 0.0,
            ),
            SizedBox(
              width: wid,
              height: 32.0,
              child: Shimmer.fromColors(
                  baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
                  highlightColor:
                      lightMode ? Colors.grey[300]! : Colors.grey[500]!,
                  child: Container(
                    width: 50,
                    height: 20,
                    color: Get.theme.scaffoldBackgroundColor,
                  )),
            )
          ],
        ),
        const Divider(
          endIndent: 20,
          indent: 10,
          color: Colors.black,
        )
      ],
    );
  }
}
