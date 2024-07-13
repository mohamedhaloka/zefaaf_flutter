import 'package:get/get.dart';
import 'package:zeffaf/pages/marriage_details/marriage_details_controller.dart';

class MarriageDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarriageDetailsController>(() => MarriageDetailsController());
  }
}
