import 'package:flutter/material.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/app.settings.modal.dart';
import 'package:zeffaf/models/owner.dart';
import 'package:zeffaf/models/package.dart';
import 'package:zeffaf/pages/packages/packages.controller.dart';

import 'store.pay/payment.service.dart';

class BottomSheet {
  modalBottomSheetMenu(
      BuildContext context,
      AppSettingsModal appSettingsModal,
      int id,
      PaymentService paymentService,
      Owner owner,
      PackageModel packages,
      PackagesController packagesController) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
              height: 220,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      ((GetPlatform.isIOS &&
                                  packagesController.displayPackages == 0) ||
                              GetPlatform.isAndroid)
                          ? appSettingsModal.displayExternalPayments == 0
                              ? const SizedBox()
                              : paymentTypeWidget(
                                  onTap: () async {
                                    await packagesController
                                        .tryPurchase(
                                      packageId: id.toString(),
                                      payMethod: '2',
                                    )
                                        .then((v) {
                                      if (v) {
                                        packagesController
                                            .purchaseLoading(false);
                                        Get.back();
                                        Get.toNamed('/PaypalPayment',
                                            arguments: [
                                              owner,
                                              packages.title,
                                              packages.usdValue,
                                              packages.id,
                                            ]);
                                      }
                                    });
                                  },
                                  tittle: 'Pay Pal',
                                  imgName: 'payment_type/pay-pal.jpeg',
                                  subTitle: 'سيتم اضافة عمولة PayPal عند الدفع')
                          : const SizedBox(),
                      GetPlatform.isAndroid
                          ? paymentTypeWidget(
                              onTap: () async {
                                await packagesController
                                    .tryPurchase(
                                  packageId: id.toString(),
                                  payMethod: '1',
                                )
                                    .then((value) async {
                                  packagesController.purchaseLoading(false);
                                  print("buy by google ${packages.title}");
                                  print("buy by google ${packages.iapId}");

                                  packagesController
                                      .packageName(packages.title!);
                                  await paymentService
                                      .buyProduct(packages.iapId);
                                });
                              },
                              tittle: 'Google Pay',
                              imgName: 'payment_type/google-play.png',
                              subTitle: 'سيتم اضافة عمولة Google Pay عند الدفع')
                          : GetPlatform.isIOS
                              ? paymentTypeWidget(
                                  onTap: () async {
                                    await packagesController
                                        .tryPurchase(
                                      packageId: id.toString(),
                                      payMethod: '0',
                                    )
                                        .then((value) async {
                                      // await FlutterInappPurchase.instance
                                      //     .isReady();
                                      packagesController.purchaseLoading(false);
                                      packagesController
                                          .packageName(packages.title!);
                                      await paymentService
                                          .buyProduct(packages.iapId);
                                    });
                                  },
                                  tittle: 'In-App purchases',
                                  imgName: 'payment_type/apple-pay.png',
                                  subTitle: 'سيتم زيادة عمولة Apple عند الدفع',
                                )
                              : const SizedBox(),
                      if (appSettingsModal.displayExternalPayments == 0)
                        ...[]
                      else if ((packagesController.agent?.name ?? '')
                          .isNotEmpty) ...[
                        paymentTypeWidget(
                          onTap: () {
                            Get.back();
                            Get.toNamed('/Agent', arguments: true);
                          },   
                          tittle: 'وكيل بلدك',
                          imgName: 'more-menu/agents.png',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? null
                              : Colors.black,
                        )
                      ]
                    ],
                  ),
                  Obx(() => packagesController.purchaseLoading.value
                      ? Container(
                          width: Get.width,
                          height: 220,
                          color: Colors.white38,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Get.find<AppController>().isMan.value == 0
                                  ? Get.theme.primaryColor
                                  : Get.theme.colorScheme.secondary,
                            ),
                          ),
                        )
                      : const SizedBox())
                ],
              ));
        });
  }

  Widget paymentTypeWidget(
          {required Function() onTap,
          required String tittle,
          String? subTitle,
          Color? color,
          required String imgName}) =>
      ListTile(
        onTap: onTap,
        title: Text(
          tittle.tr,
          style: Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/$imgName',
            scale: 15,
            color: color,
          ),
        ),
        subtitle: Text(subTitle ?? ''),
      );
}
