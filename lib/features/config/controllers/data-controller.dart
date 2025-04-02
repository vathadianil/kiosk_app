import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:kiosk_app/features/book-qr/models/qr_code_model.dart';
import 'package:kiosk_app/utils/db/database_helper.dart';

class DataController extends GetxController {
  final isLoading = true.obs;
  RxList<TicketsListModel> ticketData = <TicketsListModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    try {
      ticketData.clear();
      final storedData =
          await DatabaseHelperController.instance.getAllData('ticket_info');
      final data =
          storedData.map((data) => TicketsListModel.fromJson(data)).toList();
      ticketData.assignAll(data as Iterable<TicketsListModel>);
    } catch (e) {
      if (kDebugMode) {
        print('Data Retreval failed');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
