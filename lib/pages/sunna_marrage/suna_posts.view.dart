import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/post_details/postDetails.view.dart';
import 'package:zeffaf/pages/sunna_marrage/suna_posts.controller.dart';
import 'package:zeffaf/widgets/cards/posts_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/pagination.loader.dart';
import 'package:zeffaf/widgets/post_loader.dart';

import '../../widgets/app_header.dart';

class SunnaMarriage extends GetView<SunnaMarriageController> {
  const SunnaMarriage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: MixinBuilder<SunnaMarriageController>(
        init: SunnaMarriageController(),
        builder: (controller) => Stack(
          children: [
            BaseAppHeader(
              position: 120,
              headerLength: 100,
              controller: controller.scrollController,
              refresh: () {
                controller.currentPage(0);
                controller.posts.clear();
                controller.loading(true);
                controller.getSunnaPosts(
                    category: controller.category,
                    page: controller.currentPage.value,
                    val: false);
              },
              title: Text(
                "marrageOnSunna".tr,
                style: Get.textTheme.bodyText2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Get.back(),
                )
              ],
              children: [
                controller.isNotConnectedToInternet.value
                    ? NoInternetChecker()
                    : controller.loading.value
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return PostsLoader();
                            }, childCount: 3),
                          )
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return PostsCard(controller.posts[index], () {
                                this.controller.updateBlogViews(
                                    controller.posts[index].id.toString());

                                Get.to(
                                    PostDetails(post: controller.posts[index]));
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
}
