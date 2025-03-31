import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/features/book-qr/book-qr-screen.dart';
import 'package:kiosk_app/features/home/home.dart';

import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';

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
    this.canPop = true,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool showLogo;
  final Color? iconColor;
  final bool canPop;

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
                  if (canPop) {
                    TimerController.instance.resumeTimer();
                    TimerController.instance.resetTimer();
                    if (Get.currentRoute == '/BookQrScreen') {
                      Get.offAll(() => const HomeScreen());
                    } else {
                      Get.back();
                    }
                  } else {
                    THelperFunctions.showPaymentCancelAlert(
                      'Cancel Payment!',
                      'Are you want cancel your payment?',
                      () {
                        Get.off(() => const BookQrScreen());
                      },
                      dismisable: true,
                    );
                  }
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
