import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/advertisement/advertisement-screen.dart';
import 'package:kiosk_app/utils/constants/app_constants.dart';

class TimerController extends GetxController {
  static TimerController get instance => Get.find();
  Timer? _timer;
  var secondsElapsed = 0.obs;
  var isPaused = false.obs;
  var maxTime = AppConstants.normalAddTimer.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel(); // Ensure no duplicate timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        // 🔥 Only increment if not paused
        secondsElapsed.value++;
        if (kDebugMode) {
          print('Timer: ${secondsElapsed.value}');
        }
        if (secondsElapsed.value >= maxTime.value) {
          goToAdvertisementScreen();
        }
      }
    });
  }

  void resetTimer({maxWaitTime = 120}) {
    secondsElapsed.value = 0; // Reset timer
    maxTime.value = maxWaitTime;
  }

  /// Navigates to Advertisement Screen after timeout
  void goToAdvertisementScreen() {
    TimerController.instance.pauseTimer();
    if (Get.isRegistered<TimerController>()) {
      Get.offAll(() => const AdvertisementScreen()); // Navigate safely
    }
  }

  void pauseTimer() {
    isPaused.value = true; // 🔥 Set pause flag
  }

  void resumeTimer() {
    isPaused.value = false; // 🔥 Resume timer
  }

  @override
  void onClose() {
    super.onClose();

    _timer?.cancel();
  }
}
