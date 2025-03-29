import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class TBackgroundLinearGradient extends StatelessWidget {
  const TBackgroundLinearGradient({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final screenHeight = TDeviceUtils.getScreenHeight();
    return Container(
      height: screenHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TColors.primary, TColors.black],
        ),
      ),
      child: child,
    );
  }
}
