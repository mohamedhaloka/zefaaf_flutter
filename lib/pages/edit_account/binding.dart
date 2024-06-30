import 'package:get/get.dart';
import 'package:zeffaf/pages/edit_account/controller.dart';

class EditAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAccountController>(() => EditAccountController());
  }
}
