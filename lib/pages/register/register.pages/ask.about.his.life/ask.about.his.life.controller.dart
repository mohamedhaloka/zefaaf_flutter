import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAboutHisLifeController extends GetxController {
  RxString prayId = "".obs,
      barrierId = "".obs,
      educationalQualificationId = "".obs,
      employmentId = "".obs,
      financialStatusId = "".obs,
      monthlyIncomeLevelId = "".obs;

  RxString pray = "".obs,
      barrier = "".obs,
      educationalQualification = "".obs,
      employment = "".obs,
      financialStatus = "".obs,
      monthlyIncomeLevel = "".obs;

  TextEditingController job = TextEditingController();

  RxBool yes = false.obs;
  RxBool no = false.obs;
  bool? smoking;
}
