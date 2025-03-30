import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk_app/features/config/config-screen.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class ConfigRepository extends GetxController {
  static ConfigRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();

  //Called from app.dart on app launch
  @override
  void onReady() {
    super.onReady();
    screenRedirect();
  }

  //Function show relevant screen
  screenRedirect() async {
    final sourceStationId = TLocalStorage().readData('sourceStationId') ?? '';
    if (sourceStationId == '') {
      Get.to(() => const ConfigScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
}
