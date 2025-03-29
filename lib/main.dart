import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get_storage/get_storage.dart';
import 'package:kiosk_app/repositories/config/config-repository.dart';
import './app.dart';
import 'package:kiosk_app/services/log_service.dart ';

void main() async {
  await dotenv.load(fileName: '.env');
  // final WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize local storage
  await GetStorage.init();

  // Await splash until other items load
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await LogService().init();
  Get.put(ConfigRepository());
  runApp(const App());
}
