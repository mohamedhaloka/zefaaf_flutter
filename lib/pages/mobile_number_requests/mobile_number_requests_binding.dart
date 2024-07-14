import 'package:get/get.dart';
import 'package:zeffaf/pages/mobile_number_requests/mobile_number_requests_controller.dart';

class MobileNumberRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileNumberRequestsController>(
        () => MobileNumberRequestsController());
  }
}
