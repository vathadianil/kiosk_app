import 'package:get/get.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class PrinterController extends GetxController {
  static PrinterController get instance => Get.find();
  var defaultPrinterType = PrinterType.usb;
  var printerManager = PrinterManager.instance;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  USBStatus currentStatus = USBStatus.none;
  List<int>? pendingTask;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  var _isBle = false;
  var isConnected = false;
  BluetoothPrinter? selectedPrinter;
  final isPrinting = false.obs;
  @override
  void onInit() {
    super.onInit();
    _scan();
    //  PrinterManager.instance.stateUSB is only supports on Android

    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');

      currentStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            PrinterManager.instance
                .send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionUsbStatus?.cancel();
    super.dispose();
  }

  void _scan() {
    devices.clear();
    _subscription = printerManager
        .discovery(type: defaultPrinterType, isBle: _isBle)
        .listen((device) {
      //For USb printer

      print(device.vendorId);

      // device.vendorId == '4070'
      // device.vendorId == '1305'

      if (device.vendorId == '4070' || device.vendorId == '1305') {
        devices.add(BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: _isBle,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: defaultPrinterType,
        ));
        selectedPrinter = devices[0];
        if (!isConnected) {
          _connectDevice();
        }
      } else {
        print('Printer not Available');
      }
    });
  }

  _connectDevice() async {
    if (selectedPrinter == null) return;

    try {
      await printerManager.connect(
        type: selectedPrinter!.typePrinter,
        model: UsbPrinterInput(
          name: selectedPrinter!.deviceName,
          productId: selectedPrinter!.productId,
          vendorId: selectedPrinter!.vendorId,
        ),
      );
      isConnected = true;
    } catch (e) {
      log('----------------------------$e-------------------------');
    }
  }

  // Future<void> getPrinterStatus() async {
  //   var bluetoothPrinter = selectedPrinter!;

  //   final result =
  //       await printerManager.getStatus(type: bluetoothPrinter.typePrinter);

  //   log('----------------------Printer status-------------------------');
  //   log('---------------{$result}-----------------------------');
  // }

  Future<void> printTicket(GlobalKey<State<StatefulWidget>> keyRefrence) async {
    List<int> bytes = [];
    if (keyRefrence is PrinterDevice) {
      return;
    }
    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load();

    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.setGlobalCodeTable('CP1252');

    if (keyRefrence is String) {
      return;
    }

    final image = await captureWidgetToImage(keyRefrence);
    bytes += generator.image(image);
    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;
    bytes += generator.cut(mode: PosCutMode.partial);

    if (TDeviceUtils.getOsVersion() == '11') {
      switch (bluetoothPrinter.typePrinter) {
        case PrinterType.usb:
          // bytes += generator.feed(2);

          await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
              name: bluetoothPrinter.deviceName,
              productId: bluetoothPrinter.productId,
              vendorId: bluetoothPrinter.vendorId,
            ),
          );
          pendingTask = null;
          break;
        default:
      }
    }

    await printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
  }

  Future<img.Image> captureWidgetToImage(GlobalKey key) async {
    // await Future.delayed(const Duration(milliseconds: 200)); // Ensure rendering

    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception("RenderBoundary is null. Widget might not be built yet.");
    }

    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to convert image to ByteData.");
    }

    Uint8List pngBytes = byteData.buffer.asUint8List();
    if (pngBytes.isEmpty) {
      throw Exception("Image bytes are empty.");
    }

    img.Image? decodedImage = img.decodeImage(pngBytes);
    if (decodedImage == null) {
      throw Exception("Failed to decode image.");
    }

    return decodedImage;
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName,
      this.address,
      this.port,
      this.state,
      this.vendorId,
      this.productId,
      this.typePrinter = PrinterType.bluetooth,
      this.isBle = false});
}
