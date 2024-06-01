import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/no-result-search-found.dart';
import 'package:zeffaf/widgets/user_loader.dart';

import 'auto.search.controller.dart';
import 'no.auto.settings.found.dart';

class AutoSearch extends StatefulWidget {
  @override
  _AutoSearchState createState() => _AutoSearchState();
}

class _AutoSearchState extends State<AutoSearch>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  AutoSearchController controller = Get.put(AutoSearchController());

  @override
  void initState() {
    animationController =
        AnimationController(duration: InputData.animationTime, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Obx(
        () => BaseAppHeader(
          controller: controller.scrollController,
          headerLength: 90,
          refresh: () {},
          title: Text(
            "الباحث الآلي",
            style: Get.textTheme.titleMedium!.copyWith(color: AppTheme.WHITE),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.youtube_searched_for),
              tooltip: "إعدادات الباحث الآلي",
              onPressed: () {
                Get.toNamed('/auto_search_setting');
              },
            ),
            PopupMenuButton<String>(
              onSelected: controller.choiceAction,
              icon:
                  SvgPicture.asset("assets/images/home/horizontal_filter.svg"),
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
            controller.notConnectToInternet.value
                ? const NoInternetChecker()
                : controller.loading.value
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return UserLoader();
                        }, childCount: 5),
                      )
                    : controller.settingsExist.value == 0
                        ? NoAutoSettingsFound()
                        : controller.resultUserList.isEmpty
                            ? NoResultSearchFound()
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return MutualCard(
                                    controller.resultUserList[index],
                                  );
                                },
                                    childCount:
                                        controller.resultUserList.length),
                              )
          ],
        ),
      ),
    );
  }
}
