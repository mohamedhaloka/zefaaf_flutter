import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/marriage_details/marraige_request_model.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/toast.dart';

import '../../services/http.service.dart';

class MarriageDetailsController extends GetxController {
  final appController = Get.find<AppController>();

  TextEditingController title = TextEditingController(),
      age = TextEditingController(),
      whatsapp = TextEditingController(),
      aboutMe = TextEditingController(),
      aboutOther = TextEditingController(),
      thanksMessage = TextEditingController();

  RxString mobile = ''.obs;
  RxString mariageKind = ''.obs;
  RxString mariageKindId = ''.obs;
  RxString mariageStatues = ''.obs;
  RxString mariageStatuesId = ''.obs;

  RxBool editPhone = false.obs;

  RxBool getRequestLoading = false.obs;
  RxBool updateRequestLoading = false.obs;
  RxBool deleteRequestLoading = false.obs;
  bool get isMan => appController.isMan.value == 0;

  MarriageRequestData? requestData;
  var whatsApp = PhoneNumber(isoCode: '').obs;
  String? simCountryCode;

  @override
  void onInit() {
    _getRequestDetails();
    _getCountryCode();
    super.onInit();
  }

  void _getCountryCode() async {
    final permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) return;
    final Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placeMarks.isEmpty) return;
    Placemark place = placeMarks[0];

    simCountryCode = place.isoCountryCode ?? '';
    whatsApp.value = PhoneNumber(isoCode: simCountryCode?.toUpperCase());
  }

  void _fillData() {
    print(extractData['whatsapp']);
    title.text = extractData['title'] ?? '';
    age.text = extractData['age'] ?? '';
    aboutOther.text = extractData['aboutOther'] ?? '';
    aboutMe.text = extractData['aboutMe'] ?? '';
    mobile(extractData['whatsapp'] ?? '');
    thanksMessage.text = extractData['thanksMessage'] ?? '';
    mariageKind(extractData['marriageKind'] ?? '');

    mariageKindId(getId(
      InputData.kindOfMarriageList,
      InputData.kindOfMarriageListId,
      mariageKind.value,
    ));

    mariageStatues(extractData['marriageStatus'] ?? '');

    if (isMan) {
      mariageStatuesId(getId(
        InputData.socialStatusManList,
        InputData.socialStatusManListId,
        mariageStatues.value,
      ));
    } else {
      mariageStatuesId(getId(
        InputData.socialStatusWomanList,
        InputData.socialStatusWomanListId,
        mariageStatues.value,
      ));
    }
  }

  String getId(List<String> list, List<int> listId, String value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
  }

  Future _getRequestDetails() async {
    try {
      getRequestLoading(true);

      var response = await http.get(
        Uri.parse("${Request.urlBase}getMarriageDetails"),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == "success") {
        List marriageRequests =
            List.from((responseData['data'] ?? []).map((e) => e).toList());

        if (marriageRequests.isEmpty) return;
        requestData = MarriageRequestData.fromJson(marriageRequests.last);

        _fillData();
      } else {
        getRequestLoading(false);
        Get.snackbar(
          "خطأ!",
          json.decode(response.body)['message'],
          backgroundColor: Colors.black54,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "خطأ!",
        'حدث خطأ يرجي إعادة المحاولة لاحقاً',
        backgroundColor: Colors.black54,
      );
      getRequestLoading(false);
    }
  }

  Future updateMarriageRequest() async {
    try {
      if (title.text.isEmpty ||
          age.text.isEmpty ||
          (editPhone.value ? whatsapp.text.isEmpty : false) ||
          aboutMe.text.isEmpty ||
          aboutOther.text.isEmpty ||
          thanksMessage.text.isEmpty ||
          mariageStatuesId.value.isEmpty ||
          (mariageStatuesId.value != '1'
              ? mariageKindId.value.isEmpty
              : false)) {
        showToast('يجب ملئ جميع البيانات');
        return;
      }

      updateRequestLoading(true);
      Map registerBody = {
        'whats': editPhone.value ? whatsapp.text : mobile.value,
        'realName': title.text,
        'type': '1',
        'age': age.text,
        'mariageStatues': mariageStatuesId.value,
        'mariageKind': mariageKindId.value,
        'aboutMe': aboutMe.text,
        'aboutOther': aboutOther.text,
        'thanksMessage': thanksMessage.text,
      };

      var response = await http.post(
        Uri.parse("${Request.urlBase}updateMarriageRequest/${requestData?.id}"),
        body: registerBody,
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
      );

      if (json.decode(response.body)['status'] == "success") {
        showToast('تم التحديث طلبك بنجاح');
        Get.back();
        updateRequestLoading(false);
      } else {
        updateRequestLoading(false);
        Get.snackbar(
          "خطأ!",
          json.decode(response.body)['message'],
          backgroundColor: Colors.black54,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ!",
        'حدث خطأ يرجي إعادة المحاولة لاحقاً',
        backgroundColor: Colors.black54,
      );
      updateRequestLoading(false);
    }
  }

  Future<void> deleteRequestDialog() => Get.dialog(
        AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "هل تود حقاً حذف الطلب؟",
                style: Get.theme.textTheme.bodyText1!.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                _deleteMarriageRequest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
              ),
              child: const Text(
                "حذف",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: Get.back,
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.errorColor,
              ),
              child: const Text(
                "رجوع",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  Future _deleteMarriageRequest() async {
    try {
      deleteRequestLoading(true);

      var response = await http.post(
        Uri.parse("${Request.urlBase}deleteMarriageRequest/${requestData?.id}"),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
      );

      if (json.decode(response.body)['status'] == "success") {
        Get.back();
        showToast('تم حذف طلبك بنجاح');
      } else {
        deleteRequestLoading(false);
        Get.snackbar(
          "خطأ!",
          json.decode(response.body)['message'],
          backgroundColor: Colors.black54,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ!",
        'حدث خطأ يرجي إعادة المحاولة لاحقاً',
        backgroundColor: Colors.black54,
      );
      deleteRequestLoading(false);
    }
  }

  String extractField(String text, String fieldName) {
    final escapedFieldName = RegExp.escape(fieldName);
    final regex = RegExp(
        '$escapedFieldName:\\s*(.*?)\\n{2}|$escapedFieldName:\\s*(.*)',
        dotAll: true);
    final match = regex.firstMatch(text);
    return match?.group(1)?.trim() ?? match?.group(2)?.trim() ?? '';
  }

  Map<String, String> get extractData {
    final text = requestData?.message ?? '';

    return {
      'title': extractField(text, 'إسمي').removeAllWhitespace,
      'age': extractField(text, 'عمري').removeAllWhitespace,
      'marriageStatus': extractField(text, 'حالتي الإجتماعية').trim(),
      'marriageKind': extractField(text, 'نوع الزواج').trim(),
      'whatsapp': extractField(text, 'رقم الواتس').removeAllWhitespace,
      'aboutMe': extractField(text, 'بعض من مواصفاتي').removeAllWhitespace,
      'aboutOther':
          extractField(text, 'مواصفات شريكة (شريك) حياتي').removeAllWhitespace,
      'thanksMessage':
          extractField(text, 'كلمة شكر لفريق العمل').removeAllWhitespace,
    };
  }
}
