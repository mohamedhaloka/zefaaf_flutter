import 'package:get/get.dart';
import '../../appController.dart';

class HowToUseController extends GetxController {
  final appController = Get.find<AppController>();
  RxString privacy = "how to use".obs;

  RxBool accepted = RxBool(false);
  @override
  void onInit() {
    super.onInit();
  }
}
