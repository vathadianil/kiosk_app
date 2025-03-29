import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';

import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    required this.showBackArrow,
    this.actions,
    this.leadingOnPressed,
    this.leadingIcon,
    this.showLogo = true,
    this.iconColor = TColors.black,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool showLogo;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: TColors.primary,
        ),
        automaticallyImplyLeading: false,
        leadingWidth: screenWidth * .08,
        leading: showBackArrow
            ? IconButton(
                onPressed: () {
                  Get.back();
                  TimerController.instance.resetTimer();
                },
                icon: Icon(
                  Iconsax.arrow_left,
                  color: iconColor,
                ),
              )
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() * 1.4);
}
