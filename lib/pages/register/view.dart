import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:zeffaf/pages/register/register.app.bar.dart';
import 'package:zeffaf/pages/register/register.controller.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/view.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/view.dart';
import 'package:zeffaf/pages/register/register.pages/ask.about.his.life/view.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/view.dart';

import '../../utils/toast.dart';

class RegisterView extends GetView<RegisterController> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetX<RegisterController>(
      init: RegisterController(),
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          if (controller.currentStep.value == 1) {
            return true;
          } else {
            controller.currentStep.value--;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: registerAppBar(),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Divider(
                          color: Colors.black,
                          endIndent: 25,
                          indent: 25,
                        ),
                      ),
                      StepProgressIndicator(
                        totalSteps: 4,
                        currentStep: controller.currentStep.value,
                        size: 36,
                        selectedColor: Colors.grey[900]!,
                        unselectedColor: Colors.grey[200]!,
                        customStep: (index, color, _) => color ==
                                Colors.grey[900]
                            ? Container(
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                                child: Center(
                                    child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                                child: Center(
                                    child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(color: Colors.black),
                                )),
                              ),
                      ),
                    ],
                  ),
                ),
                controller.currentStep.value == 1
                    ? AccountInformationForm(
                        onPress: () {
                          GlobalKey<FormState> accountInformationFormKey =
                              Get.find(tag: "accountInformationFormKey");
                          if (accountInformationFormKey.currentState!
                              .validate()) {
                            accountInformationFormKey.currentState!.save();
                            if (controller.accountInformationController.password
                                    .value.text ==
                                controller.accountInformationController
                                    .rePassword.value.text) {
                              var value =
                                  controller.accountInformationController;

                              if (value.countryCodeController.countryName
                                          .value !=
                                      "" &&
                                  value.cityListController.cityName.value !=
                                      "") {
                                if (controller.accountInformationController
                                        .checkUserName.value !=
                                    Icons.close) {
                                  controller.currentStep.value++;
                                  animatedToGetTheTopOFPage();
                                }
                              } else {
                                showToast("يرجى تعبئة جميع البيانات");
                              }
                            } else {}
                          }
                        },
                      )
                    : controller.currentStep.value == 2
                        ? SocialStatueForm(
                            gender: controller.gender.value,
                            onPress: () {
                              GlobalKey<FormState> socialStatueFormKey =
                                  Get.find(tag: "socialStatueFormKey");

                              if (socialStatueFormKey.currentState!
                                  .validate()) {
                                socialStatueFormKey.currentState!.save();

                                var value1 = controller.socialStatusController;

                                bool allowKindOfMarriageOfMan = controller
                                        .socialStatusController
                                        .socialStatus
                                        .value ==
                                    "أعزب";

                                if (value1.socialStatus.value != "" &&
                                    (controller.gender.value == 0
                                        ? allowKindOfMarriageOfMan
                                            ? true
                                            : value1.kindOfMarriage.value != ""
                                        : value1.kindOfMarriage.value != "") &&
                                    value1.skinColour.value != "" &&
                                    value1.healthStatus.value != "") {
                                  controller.currentStep.value++;
                                  animatedToGetTheTopOFPage();
                                } else {
                                  showToast("يرجى تعبئة جميع البيانات");
                                }
                              }
                            },
                            previousPress: () {
                              controller.currentStep.value--;
                              animatedToGetTheTopOFPage();
                            },
                          )
                        : controller.currentStep.value == 3
                            ? AskAboutHisLife(
                                gender: controller.gender.value,
                                onPress: () {
                                  GlobalKey<FormState> askAboutHisLifeFormKey =
                                      Get.find(tag: "askAboutHisLifeFormKey");

                                  if (askAboutHisLifeFormKey.currentState!
                                      .validate()) {
                                    askAboutHisLifeFormKey.currentState!.save();
                                    var value3 =
                                        controller.aboutHisLifeController;

                                    if (value3.pray.value != "" &&
                                        (controller.gender.value == 1
                                            ? value3.barrier.value != ""
                                            : true) &&
                                        value3.educationalQualification.value !=
                                            "" &&
                                        value3.financialStatus.value != "" &&
                                        value3.employment.value != "" &&
                                        value3.monthlyIncomeLevel.value != "") {
                                      controller.currentStep.value++;
                                      animatedToGetTheTopOFPage();
                                    } else {
                                      showToast("يرجى تعبئة جميع البيانات");
                                    }
                                  }
                                },
                                previousPress: () {
                                  controller.currentStep.value--;
                                  animatedToGetTheTopOFPage();
                                },
                              )
                            : AboutYouForm(
                                gender: controller.gender.value,
                                loader: controller.loading.value,
                                onPress: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  GlobalKey<FormState> aboutYouForm =
                                      Get.find(tag: "aboutYouFormKey");

                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    if (aboutYouForm.currentState!.validate()) {
                                      aboutYouForm.currentState!.save();

                                      controller
                                          .register(
                                              mobileCode:
                                                  controller.countryCode.value,
                                              mobile: controller.mobile.value,
                                              password: controller
                                                  .accountInformationController
                                                  .password
                                                  .value
                                                  .text,
                                              userName: controller
                                                  .accountInformationController
                                                  .username
                                                  .value
                                                  .text,
                                              name: controller
                                                  .accountInformationController
                                                  .fullName
                                                  .value
                                                  .text,
                                              email: '',
                                              gender:
                                                  "${controller.gender.value}",
                                              residentCountryId:
                                                  "${controller.accountInformationController.countryCodeController.countryId}",
                                              nationalityCountryId:
                                                  "${controller.accountInformationController.countryCodeController.nationalityId}",
                                              cityId:
                                                  "${controller.accountInformationController.cityListController.cityId.value}",
                                              mariageStatues: controller
                                                  .socialStatusController
                                                  .socialStatusId
                                                  .value,
                                              mariageKind:
                                                  controller.socialStatusController.kindOfMarriage.value == ""
                                                      ? "5"
                                                      : controller
                                                          .socialStatusController
                                                          .kindOfMarriageId
                                                          .value,
                                              age: controller
                                                  .socialStatusController
                                                  .age
                                                  .value
                                                  .text,
                                              kids: controller.socialStatusController.numberOfKids.value.text == "" ||
                                                      controller.socialStatusController.numberOfKids.value.text == "أعزب" ||
                                                      controller.socialStatusController.numberOfKids.value.text == "آنسة"
                                                  ? "0"
                                                  : (int.tryParse(controller.socialStatusController.numberOfKids.value.text) ?? 0).toString(),
                                              veil: controller.aboutHisLifeController.barrierId.value.toString().isEmpty ? '0' : controller.aboutHisLifeController.barrierId.value.toString(),
                                              weight: controller.socialStatusController.width.value.text.isEmpty ? '0' : controller.socialStatusController.width.value.text,
                                              height: controller.socialStatusController.height.value.text.isEmpty ? '0' : controller.socialStatusController.height.value.text,
                                              skinColor: controller.socialStatusController.skinColourId.value == '' ? '151' : controller.socialStatusController.skinColourId.value,
                                              smoking: controller.aboutHisLifeController.smoking == null
                                                  ? "0"
                                                  : (controller.aboutHisLifeController.smoking ?? false)
                                                      ? "1"
                                                      : "0",
                                              prayer: controller.aboutHisLifeController.prayId.value,
                                              education: controller.aboutHisLifeController.educationalQualificationId.value,
                                              financial: controller.aboutHisLifeController.financialStatusId.value,
                                              workField: controller.aboutHisLifeController.employmentId.value,
                                              job: controller.aboutHisLifeController.job.text,
                                              income: controller.aboutHisLifeController.monthlyIncomeLevelId.value,
                                              helath: controller.socialStatusController.healthStatusId.value == '' ? '150' : controller.socialStatusController.healthStatusId.value,
                                              aboutMe: controller.aboutYouController.talkAboutYou.text,
                                              aboutOther: controller.aboutYouController.partnerSpecifications.text,
                                              telesalesCode: controller.aboutYouController.telesalesCode.text,
                                              detectedCountry: "",
                                              deviceToken: '')
                                          .then((value) {
                                        if (value['status'] == "success") {
                                          controller.login(
                                              username: controller.mobile.value,
                                              context: context,
                                              password: controller
                                                  .accountInformationController
                                                  .password
                                                  .value
                                                  .text);
                                        }
                                        controller.loading(false);
                                      });
                                    }
                                  } else {
                                    showToast(
                                        "يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
                                  }
                                },
                                previousPress: () {
                                  controller.currentStep.value--;
                                  animatedToGetTheTopOFPage();
                                },
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  animatedToGetTheTopOFPage() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }
}
