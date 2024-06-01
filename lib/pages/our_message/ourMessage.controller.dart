import 'package:get/get.dart';
import 'package:zeffaf/pages/more/more.controller.dart';
import '../../appController.dart';

class OurMessageController extends GetxController {
  final _appController = Get.find<AppController>();

  MoreController moreController = Get.find<MoreController>();

  @override
  void onInit() {
    super.onInit();
  }
}
