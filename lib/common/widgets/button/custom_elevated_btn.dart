import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';

class CustomElevatedBtn extends StatelessWidget {
  const CustomElevatedBtn({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = TColors.secondary,
  });
  final Function()? onPressed;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.defaultSpace,
            vertical: TSizes.defaultSpace / 2,
          ),
          side: BorderSide(width: isDark ? 1 : 2, color: TColors.accent),
        ),
        child: child);
  }
}
