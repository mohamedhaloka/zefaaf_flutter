import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:zeffaf/pages/packages/packages.controller.dart';

class PaymentService extends GetxService {
  final packagesController = Get.find<PackagesController>();

  Future<PaymentService> init() async {
    initConnection();
    return this;
  }

  // static final PaymentService instance = PaymentService._internal();

  /// To listen the status of connection between app and the billing server
  late StreamSubscription<ConnectionResult> _connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  late StreamSubscription<PurchasedItem?> _purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  late StreamSubscription<PurchaseResult?> _purchaseErrorSubscription;

  /// List of product ids you want to fetch
  List<String> get _productIds => packagesController.iapPackages;

  /// All available products will be store in this list
  List<IAPItem>? _products;
  final List<ProductDetails> _storeProducts = [];

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  final ObserverList<Function> _proStatusChangedListeners =
      ObserverList<Function>();

  /// view of the app will subscribe to this to get errors of the purchase
  final ObserverList<Function(String)> _errorListeners =
      ObserverList<Function(String)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUser => _isProUser;

  /// view can subscribe to _proStatusChangedListeners using this method
  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

  /// view can subscribe to _errorListeners using this method
  addToErrorListeners(ValueChanged<String> callback) {
    _errorListeners.add(callback);
  }

  /// view can cancel to _errorListeners using this method
  removeFromErrorListeners(ValueChanged<String> callback) {
    _errorListeners.remove(callback);
  }

  /// Call this method to notify all the subsctibers of _proStatusChangedListeners
  void _callProStatusChangedListeners() {
    for (var callback in _proStatusChangedListeners) {
      callback();
    }
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String error) {
    for (var callback in _errorListeners) {
      callback(error);
    }
  }

  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initialize();
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {});

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

    _getItems();
  }

  /// call when user close the app
  void dispose() {
    _connectionSubscription.cancel();
    _purchaseErrorSubscription.cancel();
    _purchaseUpdatedSubscription.cancel();
    FlutterInappPurchase.instance.finalize();
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    _callErrorListeners(purchaseError?.message ?? '');
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    Get.dialog(Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Image.asset(
          'assets/images/payment_processing.png',
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fill,
        ),
      ),
    ));
    await Future.delayed(const Duration(seconds: 1));
    if (Platform.isAndroid) {
      await _handlePurchaseUpdateAndroid(productItem!);
    } else {
      await _handlePurchaseUpdateIOS(productItem!);
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
        // FlutterInAppPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem, 'applepay');
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
  /// 0 : UNSPECIFIED_STATE
  /// 1 : PURCHASED
  /// 2 : PENDING
  Future<void> _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {
    switch (purchasedItem.purchaseStateAndroid!.index) {
      case 1:
        if (!purchasedItem.isAcknowledgedAndroid!) {
          await _verifyAndFinishTransaction(purchasedItem, 'googlepay');
        }
        break;
      case 2:
        break;
      case 0:
        break;
      default:
        _callErrorListeners("Something went wrong");
    }
  }

  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(
      PurchasedItem purchasedItem, String paymentRefrence) async {
    bool isValid = false;
    try {
      // Call API
      var productId = '';
      var transactionId = '';
      var purchaseToken = '';

      productId = purchasedItem.productId!;
      transactionId = purchasedItem.transactionId!;

      if (Platform.isAndroid) {
        purchaseToken = purchasedItem.purchaseToken!;
      } else {
        purchaseToken = purchasedItem.transactionReceipt!;
      }

      isValid = await packagesController.verifyPurchase(
          packageId: packagesController.paymentId.value,
          paymentRefrence: paymentRefrence,
          paymentValue: packagesController.paymentValue.value,
          productId: productId,
          purchaseToken: purchaseToken,
          transactionId: transactionId);
      // Validate validateReceipt
      if (Platform.isIOS) {
        var receiptBody = {'receipt-data': purchaseToken};
        await FlutterInappPurchase.instance
            .validateReceiptIos(receiptBody: receiptBody, isTest: false);
      }
    } catch (e) {
      _callErrorListeners("No Internet");
      return;
    }

    if (isValid) {
      //FlutterInappPurchase.instance.consumePurchaseAndroid(purchasedItem);

      FlutterInappPurchase.instance
          .finishTransaction(purchasedItem, isConsumable: true);
      _isProUser = true;
      dispose();
      Get.offAllNamed(
        '/PurchaseSuccess',
        arguments: packagesController.packageName.value,
      );
      // save in sharedPreference here
      _callProStatusChangedListeners();
    } else {
      _callErrorListeners("Verification failed");
    }
  }

  Future<List<IAPItem>> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products ?? [];
  }

  Future<void> _getItems() async {
    List<IAPItem> items;
    items =
        await FlutterInappPurchase.instance.getProducts(_productIds); //product
    // await FlutterInappPurchase.instance.getSubscriptions(_productIds);//subscription

    _products = [];
    for (var item in items) {
      (_products ?? []).add(item);
    }
    await InAppPurchase.instance.isAvailable();

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productIds.toSet());

    _storeProducts.clear();
    for (var element in response.productDetails) {
      _storeProducts.add(element);
    }
  }

  Future<void> buyProduct(packageId) async {
    ProductDetails? productDetails;
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productIds.toSet());

    for (var element in response.productDetails) {
      if (element.id == packageId) {
        productDetails = element;
      }
    }
    if (productDetails == null) return;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Widget getDialog(title, content) => AlertDialog(
        title: title,
        content: content,
        actions: [
          ElevatedButton(
            onPressed: Get.back,
            child: const Text('حسناً'),
          )
        ],
      );
}
