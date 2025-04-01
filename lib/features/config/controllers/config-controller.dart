// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
// import 'package:kiosk_app/features/home/home.dart';
// import 'package:kiosk_app/services/log_service.dart';
// import 'package:kiosk_app/utils/helpers/helper_functions.dart';
// import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
// import 'package:kiosk_app/utils/popups/loaders.dart';
// import 'package:logger/logger.dart';

// class ConfigControoler extends GetxController {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final mobileController = TextEditingController();
//   final terminalController = TextEditingController();
//   RxString stationName = ''.obs;
//   RxString equipmentId = '0001'.obs;
//   RxString useMqtt = 'Y'.obs;
//   RxString swtichToApiPolling = 'N'.obs;
//   late Logger logger;

//   @override
//   onInit() async {
//     super.onInit();
//     initForm();
//     await LogService().init();
//     logger = LogService().logger;
//   }

//   initForm() {
//     stationName.value = TLocalStorage().readData('sourceStationName') ?? '';
//     equipmentId.value =
//         TLocalStorage().readData('displayEquipmentId') ?? '0001';
//     terminalController.text = TLocalStorage().readData('terminalId') ?? '';
//     mobileController.text = TLocalStorage().readData('mobileNo') ?? '';
//     useMqtt.value = TLocalStorage().readData('useMqtt') ?? 'Y';
//     swtichToApiPolling.value =
//         TLocalStorage().readData('swtichToApiPolling') ?? 'N';
//   }

//   submitDetails() {
//     //Form Validation
//     if (!formKey.currentState!.validate()) {
//       //Stop Loading
//       TLoaders.customToast(message: 'Please fill all the required inputs');
//       return;
//     }

//     final staitonShortName = THelperFunctions.getStationFromStationName(
//                 stationName.value, StationListController.instance.stationList)
//             .shortName ??
//         '';
//     final stationId = THelperFunctions.getStationFromStationName(
//                 stationName.value, StationListController.instance.stationList)
//             .stationId ??
//         '';

//     TLocalStorage().saveData('sourceStationId', stationId);
//     TLocalStorage().saveData('sourceStationName', stationName.value);
//     TLocalStorage().saveData('displayEquipmentId', equipmentId.value);
//     TLocalStorage()
//         .saveData('equipmentId', '${staitonShortName}KSK${equipmentId.value}');
//     TLocalStorage().saveData('mobileNo', mobileController.text);
//     TLocalStorage().saveData('terminalId', terminalController.text);
//     TLocalStorage().saveData('useMqtt', useMqtt.value);
//     TLocalStorage().saveData('swtichToApiPolling',
//         useMqtt.value == 'Y' ? swtichToApiPolling.value : 'N');
//     TLocalStorage()
//         .saveData('userId', '${staitonShortName}KSK${equipmentId.value}');

//     logger.i('''
//         StationId ${TLocalStorage().readData('sourceStationId')}
//         Station Name ${TLocalStorage().readData('sourceStationName')}
//         Mobile Number ${TLocalStorage().readData('mobileNo')}
//         Terminal Id ${TLocalStorage().readData('terminalId')}
//         Equipment Id ${TLocalStorage().readData('equipmentId')}
//         Use mqtt ${TLocalStorage().readData('useMqtt')}
//         SwtichToApiPolling ${TLocalStorage().readData('swtichToApiPolling')}
//         Configuration saved.....
// ''');

//     Get.offAll(() => const HomeScreen());
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/services/log_service.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';
import 'package:logger/logger.dart';

class ConfigController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final terminalController = TextEditingController();
  RxString stationName = ''.obs;
  RxString equipmentId = '0001'.obs;
  RxString useMqtt = 'Y'.obs;
  RxString switchToApiPolling = 'N'.obs;

  final TLocalStorage _storage = TLocalStorage();
  late Logger logger;

  @override
  Future<void> onInit() async {
    super.onInit();
    initForm();
    await LogService().init();
    logger = LogService().logger;
  }

  void initForm() {
    stationName.value = _storage.readData('sourceStationName') ?? '';
    equipmentId.value = _storage.readData('displayEquipmentId') ?? '0001';
    terminalController.text = _storage.readData('terminalId') ?? '';
    mobileController.text = _storage.readData('mobileNo') ?? '';
    useMqtt.value = _storage.readData('useMqtt') ?? 'Y';
    switchToApiPolling.value = _storage.readData('switchToApiPolling') ?? 'N';
  }

  void submitDetails() {
    if (!formKey.currentState!.validate()) {
      TLoaders.customToast(message: 'Please fill all required fields');
      formKey.currentState!.save();
      return;
    }

    final stationData = THelperFunctions.getStationFromStationName(
        stationName.value, StationListController.instance.stationList);

    final stationShortName = stationData?.shortName ?? '';
    final stationId = stationData?.stationId ?? '';

    _storage.saveData('sourceStationId', stationId);
    _storage.saveData('sourceStationName', stationName.value);
    _storage.saveData('displayEquipmentId', equipmentId.value);
    _storage.saveData(
        'equipmentId', '${stationShortName}KSK${equipmentId.value}');
    _storage.saveData('mobileNo', mobileController.text);
    _storage.saveData('terminalId', terminalController.text);
    _storage.saveData('useMqtt', useMqtt.value);
    _storage.saveData('switchToApiPolling',
        useMqtt.value == 'Y' ? switchToApiPolling.value : 'N');
    _storage.saveData('userId', '${stationShortName}KSK${equipmentId.value}');

    logger.i({
      'StationId': _storage.readData('sourceStationId'),
      'Station Name': _storage.readData('sourceStationName'),
      'Mobile Number': _storage.readData('mobileNo'),
      'Terminal Id': _storage.readData('terminalId'),
      'Equipment Id': _storage.readData('equipmentId'),
      'Use Mqtt': _storage.readData('useMqtt'),
      'Switch To API Polling': _storage.readData('switchToApiPolling'),
      'Message': 'Configuration saved...'
    });

    Get.offAll(() => const HomeScreen());
  }
}
