import 'package:get/get.dart';
import 'package:zeffaf/pages/more/more.controller.dart';

import '../../appController.dart';

class PrivacyController extends GetxController {
  final _appController = Get.find<AppController>();
  RxString privacy = "privacy policy".obs;
  RxBool accepted = RxBool(false);
  MoreController moreController = Get.find<MoreController>();
  @override
  void onInit() {
    super.onInit();
  }
}
