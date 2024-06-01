import 'package:get/get.dart';
import 'package:zeffaf/models/user.dart';

import '../../appController.dart';

class FriendsController extends GetxController {
  final _appController = Get.find<AppController>();
  RxBool isAttentions = RxBool(true);
  RxList<User> attentions = <User>[].obs;
  RxList<User> neglected = <User>[].obs;
  @override
  void onInit() {
    super.onInit();
  }
}
