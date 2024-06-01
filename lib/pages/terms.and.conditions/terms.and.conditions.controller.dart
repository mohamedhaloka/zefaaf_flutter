import 'package:get/get.dart';
import 'package:zeffaf/pages/more/more.controller.dart';

class TermsAndConditionsController extends GetxController {
  RxBool accepted = RxBool(false);
  MoreController moreController = Get.find<MoreController>();
  @override
  void onInit() {
    super.onInit();
  }
}
