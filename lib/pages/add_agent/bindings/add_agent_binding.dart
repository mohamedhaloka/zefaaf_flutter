import 'package:get/get.dart';

import '../controllers/add_agent_controller.dart';

class AddAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAgentController>(
      () => AddAgentController(),
    );
  }
}
