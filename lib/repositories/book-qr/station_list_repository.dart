import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/business_hours_model.dart';
import 'package:kiosk_app/features/book-qr/models/station_list_model.dart';
import 'package:kiosk_app/features/book-qr/models/token_model.dart';
import 'package:kiosk_app/services/qr_encryption_service.dart';

import 'package:kiosk_app/utils/constants/api_constants.dart';
import 'package:kiosk_app/utils/exceptions/format_exceptions.dart';
import 'package:kiosk_app/utils/exceptions/platform_exceptions.dart';
import 'package:kiosk_app/utils/http/http_client.dart';

class StationListRepository extends GetxController {
  Future<TokenModel> getToken() async {
    try {
      final data = await THttpHelper.get(
        ApiEndPoint.getToken,
      );
      return TokenModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<StationDataModel> fetchStationList(String token) async {
    try {
      var data = await THttpHelper.post(
        ApiEndPoint.getStations,
        {"token": token},
      );
      if (QREncryptionService.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }
      return StationDataModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }

  Future<BusinessHoursModel> fetchBusineesHours(String token) async {
    try {
      var data = await THttpHelper.post(
        ApiEndPoint.getBusinessHours,
        {"token": token},
      );

      if (QREncryptionService.isEnabled) {
        data = QREncryptionService.decryptData(data['response']);
      }

      return BusinessHoursModel.fromJson(data);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later!';
    }
  }
}
