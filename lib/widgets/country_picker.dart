import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';

import 'custom_sized_box.dart';

class CountryPicker extends StatelessWidget {
  final value;
  final listCount;
  final countryCode;
  final countryImage;
  final title;
  final icon;
  final imageSource;
  final isImage;
  final Function? onTap;
  final isChooseAll;
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.LIGHT_GREY)),
          child: ElevatedButton(
            onPressed: () => onTap!(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            child: value == "" || value == int.parse("0")
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: Get.textTheme.titleMedium!.copyWith(
                                color: lightMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200]),
                          ),
                          const Icon(
                            Icons.arrow_left_outlined,
                          ),
                        ],
                      ),
                    ),
                  )
                : isChooseAll
                    ? chooseWidget(
                        tittle: "تم إختيار الكل في $title",
                        lightMode: lightMode)
                    : chooseWidget(
                        tittle: "تم إختيار $value فى $title",
                        lightMode: lightMode),
          ),
        ),
        Container(
          height: 60,
        ),
        Positioned(
          left: 0,
          top: 2,
          child: Visibility(
            visible: listCount == "0" || isChooseAll ? false : true,
            child: CircleAvatar(
              backgroundColor: Colors.deepOrange,
              radius: 8,
              child: Text(
                "$listCount",
                style: Get.textTheme.bodyText2!
                    .copyWith(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        )
      ],
    );
  }

  const CountryPicker(
      {this.value,
      this.title,
      this.isChooseAll,
      this.onTap,
      this.listCount,
      this.icon,
      this.imageSource,
      this.isImage,
      this.countryImage,
      this.countryCode});

  Widget chooseWidget({lightMode, tittle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          isImage
              ? Image.asset(
                  imageSource,
                  width: 26,
                  color: lightMode ? Colors.grey[800] : Colors.white,
                )
              : Icon(icon ?? Icons.map),
          const CustomSizedBox(
            heightNum: 0.0,
            widthNum: 0.01,
          ),
          Expanded(
            child: Text(
              "$tittle",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.subtitle2!.copyWith(
                  color: lightMode ? Colors.grey[800] : Colors.grey[200]),
            ),
          ),
        ],
      ),
    );
  }
}
