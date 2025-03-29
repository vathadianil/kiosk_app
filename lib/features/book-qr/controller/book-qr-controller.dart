import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/models/qr_get_fare_model.dart';
import 'package:kiosk_app/features/payment-qr/payment-qr.dart';
import 'package:kiosk_app/repositories/book-qr/book-qr-repository.dart';
import 'package:kiosk_app/utils/constants/api_constants.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/qr_merchant_id.dart';
import 'package:kiosk_app/utils/constants/ticket_status_codes.dart';
import 'package:kiosk_app/utils/helpers/network_manager.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/full_screen_loader.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class BookQrController extends GetxController {
  static BookQrController get instance => Get.find();

  //variables
  final loading = false.obs;
  final ticketType = '10'.obs;
  final passengerCount = 1.obs;
  final source = TLocalStorage().readData('sourceStationId');
  final destination = ''.obs;
  final deviceStorage = GetStorage();
  final bookQrRepository = Get.put(BookQrRepository());
  final stationController = StationListController.instance;
  final qrFareData = <QrGetFareModel>{}.obs;

  // Variable to track redemption status
  final loyaltyProgramKey = 0.obs;
  final isRedeemed = false.obs;
  final pointsToRedeem = 0.obs;
  final maxRedemptionAmount = 0.obs;
  final quoteId = ''.obs;
  final isRedemptionEligibile = 0.obs;
  final showSuccessMessage = false.obs;

  // Variable to track card visibility
  final showRecentTicketCard = true.obs;

  onDestinationTapped(stationId) {
    destination.value = stationId;
  }

  Future<void> getFare() async {
    try {
      final token = await TLocalStorage().readData('token');
      final fromStationId = source;

      final toStationId = destination.value;

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Stop Loading
        TLoaders.customToast(message: 'No Internet Connection');
        ticketType.value = TicketStatusCodes.ticketTypeSjtString;
        loading.value = false;
        return;
      }

      if (token == null ||
          token == '' ||
          fromStationId == '' ||
          toStationId == '') {
        return;
      }

      if (fromStationId == toStationId) {
        TLoaders.customToast(
            message: 'Origin and Desitnation station should be diffrent');
        return;
      }

      loading.value = true;

      final payload = {
        "token": "$token",
        "fromStationId": fromStationId,
        "merchant_id": QrMerchantDetails.TSAVAARI_MERCHANT_ID,
        "ticketTypeId": ticketType.value, //SJT = 10 RJT=20
        "toStationId": toStationId,
        "travelDatetime": "${DateTime.now()}",
        "zoneNumberOrStored_ValueAmount": 0 //STATIC VALUE
      };
      final fareData = await bookQrRepository.fetchFare(payload);
      if (qrFareData.isNotEmpty) {
        qrFareData.clear();
      }
      qrFareData.add(fareData);
    } catch (e) {
      TLoaders.successSnackBar(title: 'Error', message: e.toString());
    } finally {
      //Remove loader
      loading.value = false;
    }
  }

  int getOrderAmount() {
    return loyaltyProgramKey.value == 1
        ? (passengerCount.value * qrFareData.first.finalFare! -
            (isRedeemed.value ? maxRedemptionAmount.value : 0))
        : (passengerCount.value * qrFareData.first.finalFare!);
  }

  Future<void> generateTicket() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your request', TImages.trainAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Stop Loading
        TFullScreenLoader.stopLoading();
        TLoaders.customToast(message: 'No Internet Connection');
        return;
      }

      final userId = TLocalStorage().readData('userId');
      final phoneNumber = TLocalStorage().readData('mobileNo');
      final terminalId = int.tryParse(TLocalStorage().readData('terminalId'));
      final souceStationId = TLocalStorage().readData('sourceStationId');
      // final orderId =
      //     "KSKP$souceStationId${DateTime.now().millisecondsSinceEpoch}";
      final orderId =
          "UATP$souceStationId${DateTime.now().millisecondsSinceEpoch}";
      String isProd = TLocalStorage().readData('isProd');

      final payload = {
        "order_amount": getOrderAmount(),
        "order_currency": "INR",
        "customer_details": {
          "customer_id": userId,
          "customer_email": "",
          "customer_phone": phoneNumber,
          "customer_name": ""
        },
        "order_meta": {
          "return_url": "",
          "notify_url": isProd == 'Y'
              ? ApiEndPoint.cashfreeWebhookUrlProd
              : ApiEndPoint.cashfreeWebhookUrlForUat,
          "payment_methods": ""
        },
        "order_note": "Ticket Purchase",
        "order_id": orderId,
        "terminal": {"terminal_type": "SPOS", "cf_terminal_id": terminalId}
      };

      TimerController.instance.pauseTimer();

      final createOrderData =
          await bookQrRepository.createQrPaymentOrder(payload);
      if (createOrderData.cfOrderId != null) {
        final createTerminalTrxPayload = {
          "cf_order_id": createOrderData.cfOrderId,
          "payment_method": "QR_CODE",
          "cf_terminal_id": createOrderData.terminalData!.cfTerminalId,
          "terminal_phone_no": createOrderData.terminalData!.agentMobileNumber,
          "add_invoice": false
        };
        final createTerminalTrxData =
            await bookQrRepository.createTerminalTrx(createTerminalTrxPayload);
        if (createTerminalTrxData.qrcode != null) {
          TFullScreenLoader.stopLoading();
          Get.to(() => PaymentQrScreen(
                createTerminalTrxData: createTerminalTrxData,
                ticketType: ticketType.value,
                destination: destination.value,
                createOrderData: createOrderData,
                passengerCount: passengerCount.value,
                finalFare: qrFareData.first.finalFare!,
                fareQouteId: qrFareData.first.fareQuotIdforOneTicket!,
              ));
        }
      }
    } catch (e) {
      TimerController.instance.resumeTimer();
      TFullScreenLoader.stopLoading();
    }
  }
}
