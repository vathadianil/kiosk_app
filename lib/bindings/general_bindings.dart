import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/utils/helpers/network_manager.dart';
import 'package:kiosk_app/utils/helpers/printer_controller.dart';
import 'package:kiosk_app/utils/db/database_helper.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(PrinterController());
    Get.put(TimerController());
    Get.put(DatabaseHelperController());
  }
}
