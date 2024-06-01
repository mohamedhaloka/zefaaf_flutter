import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/models/post.categories.dart';
import 'package:zeffaf/pages/post_details/postDetails.view.dart';
import 'package:zeffaf/pages/posts/posts.controller.dart';
import 'package:zeffaf/widgets/cards/posts_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/pagination.loader.dart';
import 'package:zeffaf/widgets/post_loader.dart';

import '../../widgets/app_header.dart';
import 'no.posts.yet.dart';

class Posts extends GetView<PostsController> {
  @override
  final controller = Get.find<PostsController>();
  @override
  Widget build(context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode ? Colors.grey[500] : Colors.grey[900],
      body: MixinBuilder<PostsController>(
        init: PostsController(),
        builder: (controller) => Stack(
          children: [
            BaseAppHeader(
              backgroundColor: lightMode ? Colors.grey[500] : Colors.grey[900],
              controller: controller.scrollController,
              headerLength: 135,
              rightPosition: 20,
              leftPosition: 20,
              collapsedHeight: 110,
              title: Text(
                "theArticles".tr,
                style: Get.textTheme.bodyText2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Get.back(),
                )
              ],
              refresh: () {
                controller.loadingCategory(true);
                controller.posts.clear();
                controller.getCategoryPosts(controller.activeTab.value,
                    controller.currentPage.value, false);
              },
              body: controller.isNotConnectedToInternet.value
                  ? const SizedBox()
                  : controller.loadingCategoryPosts.value
                      ? Center(
                          child: Row(
                            children: [
                              tabShimmer(lightMode),
                              const SizedBox(width: 20),
                              tabShimmer(lightMode)
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 5),
                            child: ListView.builder(
                              itemBuilder: (context, index) => tabHeader(
                                  controller.categories[index],
                                  controller.activeTab.value ==
                                      controller.categories[index].id, () {
                                if (controller.activeTab.value !=
                                    controller.categories[index].id) {
                                  controller.loadingCategory(true);
                                  controller.activeTab.value =
                                      controller.categories[index].id!;
                                  controller.posts.clear();
                                  controller.currentPage(0);
                                  controller.category.value =
                                      controller.categories[index].id!;
                                  controller.getCategoryPosts(
                                      controller.categories[index].id,
                                      controller.currentPage.value,
                                      false);
                                }
                              }),
                              itemCount: controller.categories.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),
              children: [
                controller.isNotConnectedToInternet.value
                    ? NoInternetChecker()
                    : controller.loadingCategory.value
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return PostsLoader();
                            }, childCount: 3),
                          )
                        : controller.posts.isEmpty
                            ? NoPostsYet()
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return PostsCard(controller.posts[index], () {
                                    this.controller.updateBlogViews(
                                        controller.posts[index].id.toString());

                                    Get.to(PostDetails(
                                        post: controller.posts[index]));
                                  });
                                }, childCount: controller.posts.length),
                              ),
              ],
            ),
            PaginationLoader(controller.fetch.value)
          ],
        ),
      ),
    );
  }

  Widget tabHeader(
          PostsCategoriesModal category, bool isActive, Function onTab) =>
      InkWell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 6, left: 6),
          child: InkWell(
              onTap: () {
                onTab();
              },
              child: Text(
                category.title ?? '',
                style: Get.textTheme.bodyText2!.copyWith(
                    fontWeight:
                        isActive == true ? FontWeight.bold : FontWeight.normal,
                    color: isActive == true
                        ? controller.appController.isMan.value == 0
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.primaryColor
                        : Colors.black),
              )),
        ),
      );

  Widget tabShimmer(lightMode) => Shimmer.fromColors(
      baseColor: lightMode ? Colors.grey[400]! : Colors.grey[600]!,
      highlightColor: lightMode ? Colors.grey[300]! : Colors.grey[500]!,
      child: Container(
        height: 22,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Get.theme.scaffoldBackgroundColor),
      ));
}
