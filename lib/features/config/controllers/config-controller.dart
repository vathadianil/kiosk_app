import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class ConfigControoler extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final terminalController = TextEditingController();
  RxString stationName = ''.obs;
  RxString equipmentId = '0001'.obs;
  RxString useMqtt = 'Y'.obs;

  @override
  onInit() {
    super.onInit();
    initForm();
  }

  initForm() {
    stationName.value = TLocalStorage().readData('sourceStationName') ?? '';
    equipmentId.value =
        TLocalStorage().readData('displayEquipmentId') ?? '0001';
    terminalController.text = TLocalStorage().readData('terminalId') ?? '';
    mobileController.text = TLocalStorage().readData('mobileNo') ?? '';
    useMqtt.value = TLocalStorage().readData('useMqtt') ?? 'Y';
  }

  submitDetails() {
    //Form Validation
    if (!formKey.currentState!.validate()) {
      //Stop Loading
      TLoaders.customToast(message: 'Please fill all the required inputs');
      return;
    }

    final staitonShortName = THelperFunctions.getStationFromStationName(
                stationName.value, StationListController.instance.stationList)
            .shortName ??
        '';
    final stationId = THelperFunctions.getStationFromStationName(
                stationName.value, StationListController.instance.stationList)
            .stationId ??
        '';

    TLocalStorage().saveData('sourceStationId', stationId);
    TLocalStorage().saveData('sourceStationName', stationName.value);
    TLocalStorage().saveData('displayEquipmentId', equipmentId.value);
    TLocalStorage()
        .saveData('equipmentId', '${staitonShortName}KSK${equipmentId.value}');
    TLocalStorage().saveData('mobileNo', mobileController.text);
    TLocalStorage().saveData('terminalId', terminalController.text);
    TLocalStorage().saveData('useMqtt', useMqtt.value);
    TLocalStorage()
        .saveData('userId', '${staitonShortName}KSK${equipmentId.value}');

    Get.offAll(() => const HomeScreen());
  }
}
