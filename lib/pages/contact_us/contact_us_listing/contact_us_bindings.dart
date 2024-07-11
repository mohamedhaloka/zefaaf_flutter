import 'package:get/get.dart';
import 'package:zeffaf/pages/contact_us/contact_us_listing/contact_us_controller.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}
