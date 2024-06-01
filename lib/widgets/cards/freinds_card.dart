import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/favorites/favorites.controller.dart';
import 'package:zeffaf/pages/user_details/user_details.controller.dart';
import 'package:zeffaf/pages/user_details/user_details.view.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/utils/time.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/user_image.dart';

class FriendCard extends StatelessWidget {
  final User user;
  final AnimationController animationController;
  final Animation<double> animation;
  final int listId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                100 * (1.0 - animation.value),
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.cardColor),
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
                              isPremium: user.packageId ?? 0,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      "آخر ظهور  ${DateTimeUtil.convertTime(user.lastAccess.toString())} ",
                                      textAlign: TextAlign.left,
                                      style: Get.textTheme.headline4!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Get.find<AppController>()
                                                      .isMan
                                                      .value ==
                                                  0
                                              ? Get.theme.primaryColor
                                              : Get
                                                  .theme.colorScheme.secondary),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.userName ?? '',
                                style: Get.textTheme.headline1!
                                    .copyWith(fontWeight: FontWeight.bold),
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
                                    user.cityName ?? '',
                                    style: Get.textTheme.caption!
                                        .copyWith(fontSize: 9),
                                  ),
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: user.mariageStatues == 0
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
                                style: Get.textTheme.caption!
                                    .copyWith(fontSize: 9),
                              ),
                            ],
                          )),
                        ],
                      ),
                      Positioned(
                        left: 0,
                        bottom: -4,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, left: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomRaisedButton(
                                  tittle: "details".tr,
                                  fontSize: 14,
                                  color:
                                      Get.find<AppController>().isMan.value == 0
                                          ? Get.theme.colorScheme.secondary
                                          : Get.theme.primaryColor,
                                  height: 28,
                                  onPress: () {
                                    Get.to(() => UserDetails(
                                          userId: user.otherId!,
                                          listType:
                                              Get.find<FavoritesController>()
                                                  .activeTab
                                                  .value,
                                          isFavourite: true,
                                        ));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Container(
                                    width: 28,
                                    height: 28,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        shape: BoxShape.circle),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.find<FavoritesController>()
                                            .loading(true);
                                        try {
                                          Get.put(UserDetailsController());
                                        } catch (e) {
                                          print(e);
                                        }
                                        Get.find<UserDetailsController>()
                                            .removeFromList(
                                                user.otherId, listId, context)
                                            .then((value) {
                                          Get.find<FavoritesController>()
                                              .list
                                              .clear();
                                          Get.find<FavoritesController>()
                                              .currentPage(0);
                                          Get.find<FavoritesController>()
                                              .changeActiveTab(listId)
                                              .then((value) {
                                            Get.snackbar("تم حذف المستخدم",
                                                "من القائمة بنجاح",
                                                backgroundColor:
                                                    Colors.black54);
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0.0,
                                        padding: const EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  const FriendCard(this.user,
      {required this.animationController,
      required this.animation,
      required this.listId});

  getUserData(List list, int dataSource, List listId) {
    try {
      // print("Data Source: $dataSource");
      var index = listId.indexOf(dataSource);
      // print("Index of ListID: $index");
      var data = list.elementAt(index);
      // print("List ${list.elementAt(index)}");
      return data.toString();
    } catch (e) {}
  }
}
