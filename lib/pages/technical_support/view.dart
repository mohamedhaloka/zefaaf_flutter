import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/appController.dart';

import '../../utils/theme.dart';

class TechnicalSupportView extends StatelessWidget {
  const TechnicalSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.find<AppController>().isMan.value == 0
            ? Get.theme.primaryColor
            : Get.theme.colorScheme.secondary,
        title: const Text(
          'الدعم التقني',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
          onPressed: Get.back,
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'للتواصل مع فريق الدعم التقني يرجى التواصل على:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/agents/mail.png',
                  color: Get.find<AppController>().isMan.value == 0
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.secondary,
                  scale: 4,
                ),
                const SizedBox(width: 6),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'البريد الإلكتروني: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Cairo',
                    ),
                    children: [
                      TextSpan(
                        text: 'Support@zefaaf.net',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // if (await canLaunchUrl(
                            //     Uri.parse('mailto:support@zefaaf.net'))) {

                            try {
                              await launchUrl(
                                  Uri.parse('mailto:support@zefaaf.net'));
                            } catch (e) {
                              print(e);
                            }

                            // }
                          },
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              endIndent: 50,
              indent: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesome.telegram,
                  color: AppTheme.telegramIconColor,
                ),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    text: 'تليجرام: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Cairo',
                    ),
                    children: [
                      TextSpan(
                        text: 'https://t.me/zefaaf',
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => launchUrls('https://telegram.me/zefaaf'),
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void launchUrls(String uri) async {
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {}
  }
}
