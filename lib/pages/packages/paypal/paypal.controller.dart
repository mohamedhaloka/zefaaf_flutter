import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/owner.dart';

import 'paypal.services.dart';

class PaypalController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxString checkoutUrl = ''.obs;
  RxString executeUrl = ''.obs;
  late String accessToken;
  PaypalServices services = PaypalServices();

  Owner owner = Get.arguments[0];
  String zefaafPackageTittle = Get.arguments[1];
  int zefaafPackageCost = Get.arguments[2];
  int zefaafPackageId = Get.arguments[3];

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'zefaaf.net';
  // String returnURL = 'return.example.com';
  String cancelURL = 'zefaaf.net';
  // String cancelURL = 'cancel.example.com';

  @override
  void onInit() {
    try {} catch (_) {}
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken() ?? '';

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);

        if (res != null) {
          checkoutUrl.value = res["approvalUrl"] ?? '';
          executeUrl.value = res["executeUrl"] ?? '';
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        // scaffoldKey.currentState!.showSnackBar(snackBar);
      }
    });

    super.onInit();
  }

  // you can change default currency according to your need
  Map<dynamic, dynamic> get defaultCurrency => {
        "symbol": "USD ",
        "decimalDigits": zefaafPackageCost,
        "symbolBeforeTheNumber": true,
        "currency": "USD"
      };

  // item name, price and quantity
  String get itemName => zefaafPackageTittle;
  String get itemPrice => zefaafPackageCost.toString();
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = zefaafPackageCost.toString();
    // String subTotalAmount = zefaafPackageCost.toString();
    // String shippingCost = '0';
    // int shippingDiscountCost = 0;
    // String userName = owner.name ?? '';
    // String addressCity = 'Mansoura';
    // String addressStreet = 'Mogama El mahakem';
    // String addressZipCode = '35511';
    // String addressCountry = 'Egypt';
    // String addressState = 'Mansoura';
    // String addressPhoneNumber = owner.mobile.toString();
    // String userToken = Get.find<AppController>().apiToken.value;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "PAYPAL"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
          },
          "custom": "${owner.id}:$zefaafPackageId",
          "description": "اشتراك باقة زفاف",
          "payment_options": {"allowed_payment_method": "UNRESTRICTED"},
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }
}
