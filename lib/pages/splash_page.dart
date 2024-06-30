import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool fromUpdate = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fromUpdate = Get.arguments ?? false;
      setState(() {});
      if (fromUpdate) {
        await Future.delayed(const Duration(milliseconds: 900));
      }

      final doesNotHaveUserId = Get.find<AppController>().getUserData().id == 0;
      if (doesNotHaveUserId) {
        Get.offAllNamed('/on_boarding');
        return;
      }
      Get.offAllNamed('/BottomTabsHome');
    });
    super.initState();
  }

  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !fromUpdate
          ? const SizedBox()
          : Center(
              child: Text(
                'جاري تحديث البيانات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appController.isMan.value == 0
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.secondary,
                ),
              ),
            ),
    );
  }
}
