import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/cards/freinds_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/user_loader.dart';

import 'favorites.controller.dart';
import 'no.items.infav.list.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      duration: InputData.animationTime,
      vsync: this,
    );
    super.initState();
  }

  bool? empty;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[400]
          : Colors.grey[700],
      // backgroundColor: Colors.grey[300],
      body: GetX(
        init: FavoritesController(),
        builder: (FavoritesController controller) {
          // setState(() {
          // });
          return BaseAppHeader(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[400]
                : Colors.grey[700],
            // backgroundColor: Colors.black,

            controller: controller.scrollController,
            headerLength: 135,
            collapsedHeight: 110,
            refresh: controller.reFreshData,
            title: Text(
              "المفضلة",
              style: Get.textTheme.bodyMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            rightPosition: Get.width * 0.05,
            body: Container(
              height: 40,
              alignment: Alignment.center,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  tabHeader(
                    "favorites".tr,
                    controller.activeTab.value == 1,
                    1,
                    controller,
                  ),
                  tabHeader(
                    "ignore".tr,
                    controller.activeTab.value == 0,
                    0,
                    controller,
                  ),
                  tabHeader(
                    "مشاهدة صورتي",
                    controller.activeTab.value == 2,
                    2,
                    controller,
                  ),
                  tabHeader(
                    "مشاهدة رقم الهاتف",
                    controller.activeTab.value == 7,
                    7,
                    controller,
                  ),
                ],
              ),
            ),
            children: [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 60),
                sliver: controller.connectWithInternet.value
                    ? const NoInternetChecker()
                    : controller.loading.value
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return UserLoader();
                              },
                              childCount: 5,
                            ),
                          )
                        : controller.list.isEmpty
                            ? NoItemsInFavList()
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => FriendCard(
                                    controller.list[index],
                                    animationController: animationController,
                                    listId: controller.activeTab.value,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / controller.list.length) *
                                                index,
                                            1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                  ),
                                  childCount: controller.list.length,
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget tabHeader(String title, bool isActive, int tabId,
          FavoritesController controller) =>
      Expanded(
        // width: Get.width / 4,
        child: InkWell(
          child: InkWell(
              onTap: () {
                setState(() {
                  empty = controller.list.isEmpty;
                });
                if (isActive != true) {
                  controller.currentPage(0);
                  controller.changeActiveTab(tabId);
                  animationController.reset();
                }
              },
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText2!.copyWith(
                    fontSize: 14,
                    fontWeight:
                        isActive == true ? FontWeight.bold : FontWeight.normal,
                    color: isActive == true
                        ? Get.find<AppController>().isMan.value == 0
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.primaryColor
                        : AppTheme.LIGHT_GREY),
              )),
        ),
      );
}
