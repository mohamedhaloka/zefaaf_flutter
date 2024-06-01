import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/add.story/view.dart';
import 'package:zeffaf/pages/success.stories/card.details.dart';
import 'package:zeffaf/pages/success.stories/header.of.card.dart';
import 'package:zeffaf/pages/success.stories/success.stories.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';
import 'package:zeffaf/widgets/pagination.loader.dart';

class SuccessStories extends GetView<SuccessStoriesController> {
  @override
  final controller = Get.find<SuccessStoriesController>();
  @override
  Widget build(BuildContext context) {
    return MixinBuilder<SuccessStoriesController>(
      init: SuccessStoriesController(),
      builder: (controller) => RefreshIndicator(
        backgroundColor: Colors.white,
        color: Get.theme.primaryColor,
        onRefresh: () async {
          controller.successStoriesList.value.clear();
          controller.currentPage(0);
          await controller.getSuccessStoriesData(
              page: controller.currentPage.value, val: true, fetchVal: false);
        },
        child: Container(
          decoration: AppTheme().blueBackground,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(AddStory());
              },
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/images/success_stories/edit.png",
                width: 18,
                color: controller.appController.isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary,
              ),
            ),
            backgroundColor: Colors.transparent,
            appBar: customAppBar("قصص النجاح", onTap: () {}),
            body: controller.isNotConnectedToInternet.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-internet.png",
                        width: 120,
                        height: 120,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.grey[200],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "لا يوجد إنترنت! تأكد من إتصالك وأعد المحاولة",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : controller.loading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        children: [
                          ListView.builder(
                              itemCount: controller.successStoriesList.length,
                              controller: controller.scrollController,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      children: [
                                        HeaderOfCard(
                                          wife: controller
                                              .successStoriesList[index]
                                              .wifName,
                                          hus: controller
                                              .successStoriesList[index]
                                              .husName,
                                        ),
                                        CardDetails(
                                          story: controller
                                              .successStoriesList[index].story,
                                          storyDate: controller
                                              .successStoriesList[index]
                                              .storyDate
                                              .toString(),
                                        )
                                      ],
                                    ),
                                  )),
                          PaginationLoader(controller.fetch.value)
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
