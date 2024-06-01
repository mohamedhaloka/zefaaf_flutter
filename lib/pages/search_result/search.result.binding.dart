import 'package:get/get.dart';

import 'searchResult.controller.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResultController>(
      () => SearchResultController(),
    );
  }
}
