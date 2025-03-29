import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/features/display-qr/controllers/display-qr-controller.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class GotoHomeBtn extends StatelessWidget {
  const GotoHomeBtn({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.displayQrController,
    this.checkSubmittedStutus = true,
  });

  final double screenWidth;
  final double screenHeight;
  final PrintSubmitController displayQrController;
  final bool checkSubmittedStutus;

  @override
  Widget build(BuildContext context) {
    return TNeomarphismBtn(
      onPressed: () async {
        if (!checkSubmittedStutus ||
            displayQrController.isPrintSubmitted.value) {
          TimerController.instance.resumeTimer();
          Get.offAll(() => const HomeScreen());
        } else {
          TLoaders.customToast(
              message: 'Please print your ticket before leaving this page.');
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Iconsax.home),
          SizedBox(
            width: screenWidth * .01,
          ),
          Text(
            'Go To Home',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: TColors.white),
          ),
        ],
      ),
    );
  }
}
