import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/features/advertisement/controllers/advertisement-controller.dart';
import 'package:kiosk_app/features/config/config-screen.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:video_player/video_player.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adController = Get.put(AdController());
    final screenHeight = TDeviceUtils.getScreenHeight();
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    return GestureDetector(
      onTap: () async {
        TimerController.instance.resumeTimer();
        TimerController.instance.resetTimer();
        final sourceStationId =
            TLocalStorage().readData('sourceStationId') ?? '';
        Get.offAll(() =>
            sourceStationId != '' ? const HomeScreen() : const ConfigScreen());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: screenWidth,
          height: screenHeight * .9,
          child: Center(
            child: Obx(() {
              if (adController.isVideoInitialized.value) {
                return AspectRatio(
                  aspectRatio: adController.videoController!.value.aspectRatio,
                  child: VideoPlayer(adController.videoController!),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Show loader while switching videos
              }
            }),
          ),
        ),
      ),
    );
  }
}
