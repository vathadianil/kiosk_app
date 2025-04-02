import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/utils/helpers/printer_controller.dart';
import 'package:kiosk_app/utils/constants/app_constants.dart';

class PrintSubmitController extends GetxController {
  PrintSubmitController({
    this.ticketCount = 0,
    this.ticketKeys = const [],
    this.canPrint = false,
  });
  final int ticketCount;
  final List<GlobalKey<State<StatefulWidget>>> ticketKeys;
  final isPrintSubmitted = false.obs;
  final bool canPrint;

  @override
  void onReady() {
    super.onReady();
    if (canPrint) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        await printTicket(ticketCount, ticketKeys);
      });
    }
  }

  printTicket(ticketCount, ticketKeys) async {
    isPrintSubmitted.value = true;
    if (PrinterController.instance.isPrinting.value) {
      return;
    }

    PrinterController.instance.isPrinting.value = true;
    for (var index = 0; index < ticketCount; index++) {
      await PrinterController.instance.printTicket(ticketKeys[index]);
    }
    TimerController.instance
        .resetTimer(maxWaitTime: AppConstants.afterPrintAdTimer);
    TimerController.instance.resumeTimer();
    PrinterController.instance.isPrinting.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
