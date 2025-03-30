import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/config/config-screen.dart';

class SettingController extends GetxController {
  static SettingController get instance => Get.find();
  final password = TextEditingController();
  final tapCount = 0.obs;
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  onLogoTapped() {
    tapCount.value++;
  }

  onSubmit() {
    if (!passwordFormKey.currentState!.validate()) {
      return;
    }
    Get.to(() => const ConfigScreen());
  }
}
