import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/features/book-qr/book-qr-screen.dart';
import 'package:kiosk_app/features/home/controllers/setting_controller.dart';
import 'package:kiosk_app/utils/constants/app_constants.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:lottie/lottie.dart';

class AvailableServiceSection extends StatelessWidget {
  const AvailableServiceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TGlassContainer(
          onPressed: () async {
            TimerController.instance.resetTimer();
            SettingController.instance.tapCount.value =
                0; //Resetting settings tap value
            Get.to(() => const BookQrScreen());
          },
          width:
              AppConstants.isLargeScreen ? screenWidth * .4 : screenWidth * .6,
          height:
              AppConstants.isLargeScreen ? screenWidth * .4 : screenWidth * .6,
          borderRadius: screenWidth * .5,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                TImages.ticket,
                width: AppConstants.isLargeScreen
                    ? screenWidth * .2
                    : screenWidth * .3,
              ),
              // SizedBox(
              //   height: screenWidth * .02,
              // ),
              Text(
                'Tap the button below to book your ticket',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenWidth * .03,
              ),
              TNeomorphismBtn(
                onPressed: () async {
                  TimerController.instance.resetTimer();
                  SettingController.instance.tapCount.value = 0;
                  Get.to(() => const BookQrScreen());
                },
                showBoxShadow: true,
                animateBoxShadow: true,
                child: Text(
                  'Book Ticket',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: TColors.white),
                ),
              ),

              SizedBox(
                height: screenWidth * .1,
              ),
            ],
          )),
        ),
      ],
    );
  }
}
