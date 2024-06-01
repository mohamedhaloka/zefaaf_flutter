import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class ContainerBox extends StatelessWidget {
  ContainerBox(
      {required this.onPress,
      required this.tittle,
      this.imgSrc,
      this.countryName,
      required this.countryCode});
  Function onPress;
  String tittle;
  String? imgSrc, countryName;
  bool countryCode;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[400]!)),
      child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: const EdgeInsets.all(12.0),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: countryCode
            ? Row(
                children: [
                  tittle == "المدينة"
                      ? Container()
                      : Container(
                          width: 36,
                          height: 26,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: ExactAssetImage(
                                      "assets/images/flags/$imgSrc.png"),
                                  fit: BoxFit.cover)),
                        ),
                  const CustomSizedBox(heightNum: 0.0, widthNum: 0.014),
                  Text(
                    "$countryName",
                    style: Get.textTheme.bodyText1!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tittle,
                    style: Get.textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : Colors.grey[400]),
                  ),
                  const Icon(
                    Icons.arrow_left_outlined,
                  )
                ],
              ),
      ),
    );
  }
}
