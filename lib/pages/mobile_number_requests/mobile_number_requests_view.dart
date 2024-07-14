import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/mobile_number_requests/mobile_number_requests_controller.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/no-result-search-found.dart';
import 'package:zeffaf/widgets/pagination.loader.dart';
import 'package:zeffaf/widgets/user_loader.dart';

class MobileNumberRequestsView extends GetView<MobileNumberRequestsController> {
  const MobileNumberRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BaseAppHeader(
                controller: controller.scrollController,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => Get.back(),
                  )
                ],
                title: Text(
                  "طلبات أرقام الهواتف",
                  style: Get.textTheme.bodyText2!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
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
                                ),
                ],
              ),
              PaginationLoader(controller.fetch.value)
            ],
          ),
        ));
  }
}
