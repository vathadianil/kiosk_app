import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/models/paytm_initiate_payment_model.dart';
import 'package:kiosk_app/common/models/paytm_verify_payment_model.dart';
import 'package:kiosk_app/utils/constants/api_constants.dart';
import 'package:kiosk_app/utils/exceptions/format_exceptions.dart';
import 'package:kiosk_app/utils/exceptions/platform_exceptions.dart';
import 'package:kiosk_app/utils/http/http_client.dart';

class PaytmPaymentGatewayRepository extends GetxController {
  static PaytmPaymentGatewayRepository get instance => Get.find();

  Future<PaytmPaymentInitiateModel> initiatePaytmPayment(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.initiatePaytmPayment,
        payload,
      );
      return PaytmPaymentInitiateModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<PaytmPaymentInitiateModel> getPaytmPaymentStatus(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.getPaytmPaymentStatus,
        payload,
      );
      return PaytmPaymentInitiateModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<void> postPaytmPaymentFailedData(payload) async {
    try {
      await THttpHelper.post(
        ApiEndPoint.paytmPaymentFailedData,
        payload,
      );
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<PaytmVefiyPaymentModel> verifyPaytmPayment(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.getPaytmPaymentStatus,
        payload,
      );
      return PaytmVefiyPaymentModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<PaytmVefiyPaymentModel> refundPaytmRechargeAmount(payload) async {
    try {
      final data = await THttpHelper.post(
        ApiEndPoint.refundPaytmPayment,
        payload,
      );
      return PaytmVefiyPaymentModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }
}
