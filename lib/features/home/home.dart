import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/home/widgets/home-carousel.dart';
import 'package:kiosk_app/features/home/widgets/logo-section.dart';
import 'package:kiosk_app/features/home/widgets/available-service-section.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StationListController());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () async {
              TimerController.instance.resetTimer();
            },
            child: TBackgroundLinearGradient(
              child: Column(
                children: [
                  SizedBox(
                    height: screenWidth * .1,
                  ),
                  const LogoSection(),
                  SizedBox(
                    height: screenWidth * .1,
                  ),
                  const AvailableServiceSection(),
                  SizedBox(
                    height: screenWidth * .2,
                  ),
                  const Hero(tag: 'img', child: HomeCarousel()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
