import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

class PaymentController extends GetxController {
  //TODO: Implement PaymentController
  final appController = Get.find<AppController>();

  late InAppWebViewController webView;
  String paymentUrl = "${Request.urlBase}requestPay/";
  String apiToken = "", pageIndex = "";

  @override
  void onInit() {
    pageIndex = Get.arguments[0];
    apiToken = appController.apiToken.value;
    super.onInit();
  }

  @override
  void onClose() {}
  void requestPay() {}
}
