import 'dart:async';

import 'package:get/get.dart';
import 'package:zeffaf/services/fAuth.dart';

import '../../appController.dart';

class SMSVerificationController extends GetxController {
  final appController = Get.find<AppController>();

  late String currentText, mobile;
  RxBool enabled = false.obs;
  RxBool visible = false.obs;
  RxBool loading = false.obs;
  RxString inputCode = "".obs;
  Timer? time;
  RxInt num = 60.obs;

  FAuthController auth = Get.find<FAuthController>();

  @override
  void onInit() {
    mobile = getArgs(0);
    resendCode();
    super.onInit();
  }

  String getArgs(int index) {
    if (Get.arguments == null) return '';
    if ((Get.arguments as List).isEmpty) return '';
    return Get.arguments[index] ?? '';
  }

  @override
  void onClose() {
    try {
      if (time == null) return;
      if (time!.isActive) time!.cancel();
    } catch (_) {}
    super.onClose();
  }

  void resendCode() {
    try {
      if (time!.isActive) time!.cancel();
    } catch (_) {}
    time = Timer.periodic(const Duration(seconds: 1), (_) {
      if (num.value > 0) {
        num.value--;
      } else if (num.value == 0) {}
    });
  }

  void sendOTPAgain() {
    auth.sendVerification();
  }

  Future<void> verifyOtp(String code) async {
    loading(true);
    await auth.verifyOtp(code);
    loading(false);
  }
}
