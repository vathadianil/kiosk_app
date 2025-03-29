import 'package:get/get.dart';

class NeomorphismBtnController extends GetxController {
  static NeomorphismBtnController get instance => Get.find();
  final btnId = ''.obs;
  onButtonPressed(String buttonId) {
    btnId.value = buttonId;
  }
}
