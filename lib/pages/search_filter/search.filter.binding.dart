import 'package:get/get.dart';

import 'searchFilter.controller.dart';

class SearchFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterController>(
      () => SearchFilterController(),
    );
  }
}
