import 'package:flutter/material.dart';
import 'package:zeffaf/utils/toast.dart';

class MobileRequestNumberProgressWidget extends StatelessWidget {
  const MobileRequestNumberProgressWidget({
    super.key,
    required this.mobileRequest,
    required this.packageLevel,
  });
  final int packageLevel;
  final int mobileRequest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showToast(
          'متبقي لك $mobileRequest طلب لرقم الهاتف من $packageMaxPhoneRequests خلال هذا الشهر'),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: packageMaxPhoneRequests == 0
                    ? 0
                    : mobileRequest / packageMaxPhoneRequests,
              ),
            ),
          ),
          Text(
            '$mobileRequest/ $packageMaxPhoneRequests',
            style: const TextStyle(
              color: Colors.white,
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
