import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/confirm.new.password/view.dart';

class FAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdSent = '';
  late String fullMobileNumber, key, phoneNumber;

  @override
  void onInit() {
    fullMobileNumber = getArgs(0);
    key = getArgs(1);
    phoneNumber = getArgs(2);

    sendVerification();

    super.onInit();
  }

  String getArgs(int index) {
    if (Get.arguments == null) return '';
    if ((Get.arguments as List).isEmpty) return '';
    return Get.arguments[index] ?? '';
  }

  //Call this Function when the sim in the same phone include this app
  void callSuccess() {
    log(phoneNumber, name: 'PHONE NUMBER');
    if (key == 'register-landing') {
      Get.offAllNamed('/RegisterLandingView');
      return;
    }
    Get.offAll(() => ConfirmNewPasswordView(
          changePassword: 2,
          phone: phoneNumber,
        ));
  }

  //when phone number not right or otp wrong
  callError(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      Get.snackbar("خطأ!", "يرجى التأكد من رقم الهاتف وإعادة المحاولة",
          backgroundColor: Colors.black54);
      return;
    }
    if (e.code == 'invalid-verification-code') {
      Get.snackbar("خطأ!", "رمز التحقق خطأ يرجى إعادة المحاولة",
          backgroundColor: Colors.black54);
      return;
    }
    if (e.code == 'missing-client-identifier') {
      Get.snackbar("خطأ!", e.message ?? '', backgroundColor: Colors.black54);
      return;
    }
  }

  //it is init to send code automatically
  sendVerification() => requestVerify(fullMobileNumber);

  //this is the main function to send code and other call backs
  requestVerify(String mobile) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (_) {
          print('mmmmmmmsksslslslslls');
          // callSuccess();
        },
        verificationFailed: (FirebaseAuthException e) {
          callError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationIdSent = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationIdSent = verificationId;
        },
      );
    } catch (_) {}
  }

  //call it when user pressed button
  Future verifyOtp(String smsCode) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationIdSent, smsCode: smsCode);
      await auth.signInWithCredential(phoneAuthCredential);
      callSuccess();
    } on FirebaseAuthException catch (e) {
      callError(e);
    }
  }
}
