import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/toast.dart';
import 'package:zeffaf/utils/upgrade_package_dialog.dart';

class MobileRequestNumberProgressWidget extends StatelessWidget {
  const MobileRequestNumberProgressWidget({
    super.key,
    required this.isMan,
    required this.mobileRequest,
    required this.packageLevel,
  });
  final bool isMan;
  final int packageLevel;
  final int mobileRequest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (packageLevel == 0) {
          showUpgradePackageDialog(
              isMan, shouldUpgradeToGetPhoneNumberFeatured);
          return;
        }
        if (packageLevel == 6) {
          showUpgradePackageDialog(
              isMan, shouldUpgradeToFlowerToGet60NumberPackage);
          return;
        }

        showToast(
            'متبقي لك $mobileRequest طلب لرقم الهاتف من $packageMaxPhoneRequests خلال هذا الشهر');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: 60,
              height: 80,
              child: _GradientCircularProgressIndicator(
                strokeWidth: 3,
                gradientColors: const [
                  Color(0xff9ed45c),
                  Color(0xff3ecd91),
                  Color(0xff87d269),
                  Color(0xfff4db29),
                ],
                radius: 30,
                progress: packageMaxPhoneRequests == 0
                    ? 0
                    : mobileRequest / packageMaxPhoneRequests,
              ),
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xffdedfe1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'متبقي',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  mobileRequest.toString(),
                  style: TextStyle(
                    color: isMan
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'من $packageMaxPhoneRequests رقم',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int get packageMaxPhoneRequests {
    switch (packageLevel) {
      case 5:
      case 7:
        return 60;
      case 4:
      case 3:
      case 2:
        return 30;
      case 1:
        return 7;
      default:
        return 0;
    }
  }
}

class _GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double progress; // Progress as a fraction from 0.0 to 1.0

  const _GradientCircularProgressIndicator({
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 10.0,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: _GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
        sweepAngle: 2 * pi * progress,
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double sweepAngle;

  _GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sweepAngle <= 0)
      return; // Prevent drawing if sweepAngle is zero or negative

    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    paint.shader = SweepGradient(
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: sweepAngle,
    ).createShader(rect);
    canvas.drawArc(rect, 0.0, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
