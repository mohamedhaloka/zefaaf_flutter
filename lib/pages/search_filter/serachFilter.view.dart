import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/pages/search_filter/searchFilter.controller.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/search_form_field.dart';

import 'searchFilter.result.dart';

class SearchFilter extends StatelessWidget {
  @override
  Widget build(context) {
    return GetX<SearchFilterController>(
      init: SearchFilterController(),
      builder: (controller) => Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: controller.searchByUserOnly.value,
          color: Colors.black87,
          child: BaseAppHeader(
            toolbarHeight: 70,
            controller: controller.scrollController,
            headerLength: 100,
            title: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SearchTextField(
                controller: controller.searchController,
                tittle: "اسم المستخدم",
                onPress: () async {
                  await Get.toNamed("/SearchResult", arguments: [
                    context,
                    0,
                    controller.searchController.text,
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
                  // controller.emptyValues();
                },
                searchIconColor: controller.appController.isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary,
                fillColor: Colors.white,
                border: Colors.grey[600],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Get.back();
                  Get.find<HomeController>().updateByToken(false);
                },
              ),
            ],
            children: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([SearchResultList()]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
