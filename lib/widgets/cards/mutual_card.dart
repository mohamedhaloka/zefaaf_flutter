import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/pages/user_details/user_details.view.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/user_image.dart';

class MutualCard extends GetView<HomeController> {
  final User user;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Container(
          height: 93,
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5, top: 15, bottom: 15),
                    child: UserImage(
                      user.userImage ?? '',
                      isLive: user.available ?? 0,
                      isPremium: user.packageLevel ?? 0,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          user.userName ?? '',
                          style: Get.textTheme.headline1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: AppTheme.LIGHT_GREY,
                            size: 16,
                          ),
                          Text(
                            "${user.cityName!} / ${user.nationalityCountryName ?? ''}",
                            style: Get.textTheme.caption,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Obx(() => Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: controller
                                                  .appController.isMan.value ==
                                              1
                                          ? getUserData(
                                              InputData.socialStatusManList,
                                              user.mariageStatues ?? 0,
                                              InputData.socialStatusManListId)
                                          : getUserData(
                                              InputData.socialStatusWomanList,
                                              user.mariageStatues ?? 0,
                                              InputData
                                                  .socialStatusWomanListId)),
                                  const TextSpan(text: "/"),
                                  TextSpan(text: "age".tr),
                                  TextSpan(text: " ${user.age}"),
                                ],
                                style: Get.textTheme.caption,
                              ),
                              style: Get.textTheme.caption,
                            )),
                      ),
                    ],
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 13.0),
                child: SizedBox(
                  width: 100,
                  child: CustomRaisedButton(
                    tittle: "details".tr,
                    fontSize: 12,
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.colorScheme.secondary
                        : Get.theme.primaryColor,
                    height: 28,
                    onPress: () async {
                      await Get.to(() => UserDetails(
                            userId: user.id!,
                            isFavourite: false,
                          ));
                      controller.updateByToken(false);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  const MutualCard(this.user, {super.key});

  getUserData(List list, int dataSource, List listId) {
    try {
      // print("Data Source: $dataSource");
      var index = listId.indexOf(dataSource);
      // print("Index of ListID: $index");
      var data = list.elementAt(index);
      // print("List ${list.elementAt(index)}");
      return data.toString();
    } catch (e) {
      return '';
      // print("ERROR");
    }
  }
}
