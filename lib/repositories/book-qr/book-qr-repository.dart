import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/create_order_model.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/models/create_terminla_transaction_model.dart';
import 'package:kiosk_app/features/book-qr/models/qr_code_model.dart';
import 'package:kiosk_app/features/book-qr/models/qr_get_fare_model.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/services/qr_encryption_service.dart';
import 'package:kiosk_app/utils/constants/api_constants.dart';
import 'package:kiosk_app/utils/exceptions/format_exceptions.dart';
import 'package:kiosk_app/utils/exceptions/platform_exceptions.dart';
import 'package:kiosk_app/utils/http/http_client.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class BookQrRepository extends GetxController {
  static BookQrRepository get instance => Get.find();

  static Map<String, Object?> getEncryptedPayload(payload) {
    final token = TLocalStorage().readData('token');
    String jsonString = json.encode(payload);
    final encryptedData = QREncryptionService.encryptData(jsonString);
    return {"token": token, 'request': encryptedData};
  }

  Future<QrGetFareModel> fetchFare(payload) async {
    try {
      final modifiedPayload = QREncryptionService.isEnabled
          ? getEncryptedPayload(payload)
          : payload;

      var data = await THttpHelper.post(
        ApiEndPoint.getFare,
        modifiedPayload,
      );
      if (QREncryptionService.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }
      return QrGetFareModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<CreateSposOrderModel> createQrPaymentOrder(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.createQrPaymentOrder,
        payload,
      );
      return CreateSposOrderModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<CreateOrderModel> createOrdser(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.createOrder,
        payload,
      );
      return CreateOrderModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<CreateTerminalTransactionModel> createTerminalTrx(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.createTerninalTrx,
        payload,
      );
      return CreateTerminalTransactionModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<PaymentConfirmModel> verifyPayment(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.verifyPayment,
        payload,
      );
      return PaymentConfirmModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<QrTicketModel> generateTicket(payload) async {
    try {
      final modifiedPayload = QREncryptionService.isEnabled
          ? getEncryptedPayload(payload)
          : payload;
      var data = await THttpHelper.post(
        ApiEndPoint.generateTicket,
        modifiedPayload,
      );
      if (QREncryptionService.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }
      return QrTicketModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<void> qrTicketPaymentFailedStatus(payload) async {
    try {
      // final data =
      await THttpHelper.post(
        ApiEndPoint.qrTicketPaymentFailed,
        payload,
      );
      // return QrTicketModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<QrTicketModel> verifyGenerateTicket(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.verifyGenerateTicket,
        payload,
      );
      return QrTicketModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<QrTicketModel> paymentRefundIntimation(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.refundPaymentIntimation,
        payload,
      );
      return QrTicketModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }
}
