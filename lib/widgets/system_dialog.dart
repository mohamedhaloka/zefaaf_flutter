import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';

class SystemDialog extends StatelessWidget {
  const SystemDialog({
    super.key,
    required this.iconPath,
    required this.title,
    this.description,
    this.iconColor,
    required this.buttonText,
    required this.onPress,
    required this.isMan,
    this.showBackBtn = false,
  });

  final String iconPath;
  final String title;
  final String? description;
  final Color? iconColor;
  final String buttonText;
  final bool isMan;
  final bool showBackBtn;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        scrollable: true,
        content: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconPath,
                color: iconColor,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if ((description ?? '').isNotEmpty) ...[
                Text(
                  description ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              CustomRaisedButton(
                tittle: buttonText,
                onPress: onPress,
                color: isMan
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary,
              ),
              if (showBackBtn) ...[
                const SizedBox(height: 14),
                CustomRaisedButton(
                  tittle: 'رجوع',
                  onPress: Get.back,
                  fontColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  color: Colors.transparent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
