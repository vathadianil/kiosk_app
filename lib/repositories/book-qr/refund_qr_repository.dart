import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/create_refund_model.dart';
import 'package:kiosk_app/features/book-qr/models/refund_confirm_model.dart';
import 'package:kiosk_app/features/book-qr/models/refund_preview_model.dart';
import 'package:kiosk_app/services/qr_encryption_service.dart';
import 'package:kiosk_app/utils/constants/api_constants.dart';
import 'package:kiosk_app/utils/constants/app_constants.dart';
import 'package:kiosk_app/utils/exceptions/format_exceptions.dart';
import 'package:kiosk_app/utils/exceptions/platform_exceptions.dart';
import 'package:kiosk_app/utils/http/http_client.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class RefundQrRepository extends GetxController {
  static Map<String, Object?> getEncryptedPayload(payload) {
    final token = TLocalStorage().readData('token');
    String jsonString = json.encode(payload);
    final encryptedData = QREncryptionService.encryptData(jsonString);
    return {"token": token, 'request': encryptedData};
  }

  Future<RefundPreviewModel> refundPreview(payload) async {
    try {
      final modifiedPayload =
          AppConstants.isEnabled ? getEncryptedPayload(payload) : payload;

      var data = await THttpHelper.post(
        ApiEndPoint.refundPreview,
        modifiedPayload,
      );
      if (AppConstants.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }
      return RefundPreviewModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw e.toString();
      //throw 'Something went wrong. Please try again later!';
    }
  }

  Future<CreateRefundModel> createRefundOrder(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.createRefundOrder,
        payload,
      );

      return CreateRefundModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw e.toString();
      //throw 'Something went wrong. Please try again later!';
    }
  }

  Future<CreateRefundModel> getRefundOrderStatus(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.refundOrderStatus,
        payload,
      );

      return CreateRefundModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw e.toString();
      //throw 'Something went wrong. Please try again later!';
    }
  }

  Future<RefundConfirmModel> refundConfirm(payload) async {
    try {
      final modifiedPayload =
          AppConstants.isEnabled ? getEncryptedPayload(payload) : payload;

      var data = await THttpHelper.post(
        ApiEndPoint.refundConfirm,
        modifiedPayload,
      );

      if (AppConstants.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }

      return RefundConfirmModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw e.toString();
      //throw 'Something went wrong. Please try again later!';
    }
  }
}
