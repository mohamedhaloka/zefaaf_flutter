import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SocialStatusController extends GetxController {
  RxString socialStatusId = "".obs;
  RxString kindOfMarriageId = "".obs;
  RxString skinColourId = "".obs;
  RxString healthStatusId = "".obs;

  RxString socialStatus = "".obs;
  RxString kindOfMarriage = "".obs;
  RxString skinColour = "".obs;
  RxString healthStatus = "".obs;

  TextEditingController age = TextEditingController();
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController numberOfKids = TextEditingController();
}
