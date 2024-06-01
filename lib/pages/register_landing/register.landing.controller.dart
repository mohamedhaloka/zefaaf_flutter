import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeffaf/appController.dart';

class RegisterLandingController extends GetxController {
  static final appController = Get.find<AppController>();
  RxBool value = false.obs;
  RxInt gender = 0.obs;
  final storage = GetStorage();
  RxString registerLicense = "".obs;

  getRegisterLicense() {
    try {
      registerLicense.value = storage.read('registerLicense');
    } catch (_) {}
  }

  RxList<String> tittle = RxList([]);

  @override
  void onInit() {
    getRegisterLicense();
    super.onInit();
  }
}
