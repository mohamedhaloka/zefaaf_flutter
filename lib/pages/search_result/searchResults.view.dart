import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/no-result-search-found.dart';
import 'package:zeffaf/widgets/pagination.loader.dart';
import 'package:zeffaf/widgets/user_loader.dart';

import 'searchResult.controller.dart';

class SearchResult extends GetView<SearchResultController> {
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Obx(
        () => Stack(
          children: [
            BaseAppHeader(
              controller: controller.scrollController,
              headerLength: 90,
              refresh: () {
                controller.result.clear();
                controller.loading(true);
                controller.currentPage(0);
                controller.preSearch().then((value) {
                  controller.loading(false);
                });
              },
              title: Text(
                "subscribers".tr,
                style:
                    Get.textTheme.titleMedium!.copyWith(color: AppTheme.WHITE),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: controller.choiceAction,
                  icon: SvgPicture.asset(
                      "assets/images/home/horizontal_filter.svg"),
                  tooltip: "ترتيب حسب",
                  itemBuilder: (BuildContext context) {
                    return controller.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
              children: [
                controller.connectToInternet.value
                    ? const NoInternetChecker()
                    : controller.loading.value
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return UserLoader();
                            }, childCount: 5),
                          )
                        : controller.result.isEmpty
                            ? NoResultSearchFound()
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return MutualCard(
                                    controller.result[index],
                                  );
                                }, childCount: controller.result.length),
                              )
              ],
            ),
            PaginationLoader(controller.fetch.value)
          ],
        ),
      ),
    );
  }
}
