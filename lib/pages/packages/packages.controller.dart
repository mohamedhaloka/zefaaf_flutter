import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/package.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import '../../utils/toast.dart';
import '../agent/models/agent_modle.dart';
import 'store.pay/payment.service.dart';

class PackagesController extends GetxController {
  AppController appController = Get.find<AppController>();
  RxList<PackageModel> packages = RxList<PackageModel>();
  AgentModel? agent;
  RxList<String> iapPackages = RxList<String>([]);
  RxBool fetched = RxBool(false);
  RxBool fetching = RxBool(false);
  RxBool purchaseLoading = RxBool(false);
  late Request request;

  late int displayPackages = 0;
  final storage = GetStorage();

  RxString paymentValue = ''.obs, paymentId = ''.obs, packageName = ''.obs;
  // final MadPay pay = MadPay();
  void getPackages() async {
    if (fetched.value != true) {
      fetching.value = true;
      final data = await request.get("getPackages2");
      packages.clear();
      if (data is Map) {
        agent = AgentModel.fromJson(data['agent']);

        if (data["data"] != null) {
          if ((agent?.name ?? '').isNotEmpty) {
            packages.addAll(agent?.agentPackages ?? []);
          } else {
            data["data"].forEach((element) {
              packages.add(PackageModel.fromJson(element));
            });
          }

          for (var element in packages) {
            iapPackages.add(element.iapId ?? '');
          }
        }

        fetched.value = true;
        await Get.putAsync(() => PaymentService().init());
      }

      fetching.value = false;
    }
  }

  verifyPurchase(
      {packageId,
      paymentRefrence,
      paymentValue,
      productId,
      purchaseToken,
      transactionId}) async {
    String url = "${Request.urlBase}purchasePackage";

    http.Response response = await http.post(Uri.parse(url), body: {
      'packageId': packageId,
      'paymentRefrence': paymentRefrence,
      'paymentValue': paymentValue,
      'productId': productId,
      'purchaseToken': purchaseToken,
      'transactionId': transactionId,
    }, headers: {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future tryPurchase({packageId, payMethod}) async {
    purchaseLoading(true);
    String url = "${Request.urlBase}tryPurchasePackage";
    http.Response response = await http.post(Uri.parse(url), body: {
      'packageId': packageId,
      'payMethod': payMethod,
    }, headers: {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    });

    if (response.statusCode == 200) {
      showToast("جاري تحميل صفحة الدفع");

      return true;
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    request = Request(apiToken: appController.apiToken.value);
    displayPackages = storage.read('displayPackages') ?? 0;

    getPackages();
    super.onInit();
  }
}
