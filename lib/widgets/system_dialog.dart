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
    required this.buttonText,
    required this.onPress,
    this.enableBack = true,
  });

  final String iconPath;
  final String title;
  final String? description;
  final String buttonText;
  final void Function() onPress;
  final bool enableBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          if ((description ?? '').isNotEmpty) ...[
            Text(
              description ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          CustomRaisedButton(
            tittle: buttonText,
            onPress: onPress,
          ),
          if (enableBack)
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancel',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            )
        ],
      ),
    );
  }
}
