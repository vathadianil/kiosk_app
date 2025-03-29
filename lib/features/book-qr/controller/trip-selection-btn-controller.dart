import 'package:get/get.dart';

class TripSelectionBtnController extends GetxController {
  static TripSelectionBtnController get instance => Get.find();
  final selectedBtnValue = 'single'.obs;
  onChange(String indicator) {
    selectedBtnValue.value = indicator;
  }
}
