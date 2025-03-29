import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class ConfigControoler extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString stationId = ''.obs;
  RxString stationName = ''.obs;
  RxString equipmentId = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString terminalId = ''.obs;
  RxString isProd = ''.obs;
  submitDetails() {
    //Form Validation
    if (!formKey.currentState!.validate()) {
      //Stop Loading
      TLoaders.customToast(message: 'Please fill all the required inputs');
      return;
    }

    TLocalStorage().saveData('sourceStationId', stationId.value);
    TLocalStorage().saveData('sourceStationName', stationName.value);
    TLocalStorage().saveData('equipmentId', equipmentId.value);
    TLocalStorage().saveData('mobileNo', mobileNumber.value);
    TLocalStorage().saveData('terminalId', terminalId.value);
    TLocalStorage().saveData('isProd', isProd.value);
    TLocalStorage()
        .saveData('userId', '${stationId.value}${mobileNumber.value}');

    Get.offAll(() => const HomeScreen());
  }
}
