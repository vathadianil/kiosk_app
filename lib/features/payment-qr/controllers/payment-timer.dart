import 'dart:async';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/widgets/payment_processing_screen.dart';
import 'package:kiosk_app/features/payment-qr/controllers/generate_ticket_controller.dart';
import 'package:kiosk_app/utils/constants/qr_merchant_id.dart';
import 'package:kiosk_app/utils/constants/timer_constants.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class PaymentTimerController extends GetxController {
  PaymentTimerController({
    required this.ticketType,
    required this.destination,
    required this.createOrderData,
    required this.passengerCount,
    required this.finalFare,
    required this.fareQouteId,
  });
  static PaymentTimerController get instance => Get.find();
  Timer? _timer;

  var secondsElapsed = TimerConstants.paymentWaitTimer.obs;

  final String ticketType;
  final String destination;
  final int passengerCount;
  final int finalFare;
  final String fareQouteId;
  final CreateSposOrderModel createOrderData;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel(); // Ensure no duplicate timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsElapsed.value > 0) {
        secondsElapsed.value--;
        if (secondsElapsed.value <
                (TimerConstants.paymentWaitTimer / 2).ceil() &&
            TLocalStorage().readData('useMqtt') == 'Y' &&
            !GenerateTicketController.instance.isDataFound.value) {
          if (!GenerateTicketController.instance.isApiPoolingStarted) {
            GenerateTicketController.instance.isApiPoolingStarted = true;
            GenerateTicketController.instance.swithToApiPolling();
          }
        }
      } else {
        timer.cancel();
        gotoPaymentProcessingScreen();
      }
    });
  }

  /// Navigates to Payment Failed Screen after timeout
  Future<void> gotoPaymentProcessingScreen({retryPurchase = false}) async {
    final requestPayload = await prepareGenerateTicketPayload();
    Get.off(() => PaymentProcessingScreen(
          generateTicketPayload: requestPayload,
          verifyPayment: createOrderData,
          retryPurchase: retryPurchase,
        ));
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }

  Future<Map<String, Object?>> prepareGenerateTicketPayload({
    String failureCode = "",
    String failureReason = "",
    String qrPgOrderId = '',
  }) async {
    final token = await TLocalStorage().readData('token');
    final phoneNumber = TLocalStorage().readData('mobileNo');
    final userId = TLocalStorage().readData('userId');

    final ticketTypeId = ticketType;

    final fromStationId = TLocalStorage().readData('sourceStationId');

    final toStationId = destination;
    final equipmentId = TLocalStorage().readData('equipmentId');
    final terminalId = TLocalStorage().readData('terminalId');

    final requestPayload = {
      "token": "$token",
      "user_id": userId.toString(),
      "equipmentId": equipmentId,
      "kskTerminalId": terminalId,
      "customerMobile": phoneNumber,
      "customerName": '',
      "customerEmail": '',
      "merchantOrderId": createOrderData.orderId,
      "merchantId": QrMerchantDetails.TSAVAARI_MERCHANT_ID,
      "transType": "0",
      "fromStationId": fromStationId,
      "toStationId": toStationId,
      "ticketTypeId": ticketTypeId,
      "noOfTickets": passengerCount,
      "travelDateTime": "${DateTime.now()}",
      "merchantEachTicketFareBeforeGst": finalFare,
      "merchantEachTicketFareAfterGst": finalFare,
      "merchantTotalFareBeforeGst": (passengerCount * finalFare),
      "merchantTotalCgst": 0,
      "merchantTotalSgst": 0,
      "merchantTotalFareAfterGst": (passengerCount * finalFare),
      "ltmrhlPassId": "",
      "patronPhoneNumber": phoneNumber,
      "fareQuoteIdforOneTicket": fareQouteId,
      "failure_code": failureCode,
      "failure_reason": failureReason,
      "qrPgOrderId": qrPgOrderId,
      "amountPaid": finalFare,
      "amountRedeemed": '0',
      "pointsRedeemed": '0'
    };
    return requestPayload;
  }
}
