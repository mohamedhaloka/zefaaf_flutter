import 'package:get/get.dart';
import 'package:zeffaf/pages/contact_us/send_contact_us_message/send_contact_us_message_controller.dart';

class SendContactUSMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendContactUSMessageController>(
        () => SendContactUSMessageController());
  }
}
