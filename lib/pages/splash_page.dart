import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeffaf/appController.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool fromUpdate = false;
  final storage = GetStorage();

  String? apiToken;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fromUpdate = Get.arguments ?? false;
      setState(() {});
      if (fromUpdate) {
        await Future.delayed(const Duration(milliseconds: 900));
      }

      apiToken = storage.read('apiToken') ?? '';

      final doesNotHaveUserId = (apiToken ?? '').isEmpty;
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
