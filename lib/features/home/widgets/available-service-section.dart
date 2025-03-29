import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/neomarphism_btn_controller.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/features/book-qr/book-qr-screen.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AvailableServiceSection extends StatelessWidget {
  const AvailableServiceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = TDeviceUtils.getScreenHeight();
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final btnController = Get.put(NeomorphismBtnController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TGlassContainer(
          onPressed: () async {
            btnController.onButtonPressed('bookqr');
            Timer(const Duration(milliseconds: 100), () {
              btnController.onButtonPressed('');
            });
            TimerController.instance.resetTimer();
            Get.to(() => const BookQrScreen());
          },
          width: screenWidth * .4,
          height: screenWidth * .4,
          borderRadius: screenWidth * .05,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * .01),
                child: QrImageView(
                  data: 'https://www.ltmetro.com',
                  size: screenWidth * .15,
                  backgroundColor: TColors.accent,
                ),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              Obx(
                () => TNeomarphismBtn(
                  onPressed: () async {
                    btnController.onButtonPressed('bookqr');
                    Timer(const Duration(milliseconds: 100), () {
                      btnController.onButtonPressed('');
                    });
                    TimerController.instance.resetTimer();
                    Get.to(() => const BookQrScreen());
                  },
                  showBoxShadow: btnController.btnId.value != 'bookqr',
                  child: Text(
                    'Book Ticket',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: TColors.white),
                  ),
                ),
              )
            ],
          )),
        ),
      ],
    );
  }
}
