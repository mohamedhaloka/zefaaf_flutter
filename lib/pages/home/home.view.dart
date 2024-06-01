import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/chat.list/view.dart';
import 'package:zeffaf/pages/search_filter/serachFilter.view.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';

import '../../widgets/app_header.dart';
import 'header.dart';
import 'home.controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final controller = Get.find<HomeController>();
  @override
  void initState() {
    controller.updateByToken(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[400]
          : Colors.grey[700],
      body: Obx(() => BaseAppHeader(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[400]
                : Colors.grey[700],
            headerLength: 350,
            position:
                statusBarHeight > 50.0 ? Get.height * 0.15 : Get.height * 0.118,
            centerTitle: true,
            title: Image.asset(
              "assets/images/log_in/logo-white.png",
              height: 60,
              width: 60,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => Get.to(() => SearchFilter()),
              )
            ],
            leading: message(controller),
            refresh: () => controller.updateByToken(false),
            body: const HomeHeader(),
            children: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المتواجدون في بلدك",
                          style: Get.textTheme.bodyText2!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        InkWell(
                          onTap: () async {
                            await Get.toNamed("/SearchResult", arguments: [
                              context,
                              0,
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              90,
                              18,
                              '',
                              '',
                              '',
                              ''
                            ]);
                          },
                          child: Text(
                            "more".tr,
                            style: Get.textTheme.bodyText2!.copyWith(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) => MutualCard(controller.users[index]),
                  childCount: controller.users.length,
                ),
              )
            ],
          )),
    );
  }

  Widget message(HomeController controller) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              Icons.message_outlined,
              color: AppTheme.WHITE,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Obx(() => controller.appController.newChats.value == 0
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Get.find<HomeController>()
                                  .appController
                                  .isMan
                                  .value ==
                              0
                          ? Get.theme.colorScheme.secondary
                          : Get.theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      controller.appController.newChats.value.toString(),
                      style: TextStyle(color: AppTheme.WHITE),
                    ),
                  )),
          ),
        ],
      ),
      onTap: () {
        Get.to(() => const ChatList());
      },
    );
  }
}
