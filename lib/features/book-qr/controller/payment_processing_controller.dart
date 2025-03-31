import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/display-qr/display-qr-screen.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/repositories/book-qr/book-qr-repository.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/payment_gateway/cash_free.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class PaymentProcessingController extends GetxController {
  PaymentProcessingController({
    required this.verifyPaymentData,
    required this.requestPayload,
    required this.retryPurchase,
    this.confirmOrderData,
  });
  final CreateSposOrderModel verifyPaymentData;
  final Map<String, Object?> requestPayload;
  final PaymentConfirmModel? confirmOrderData;
  final bookQrRepository = Get.put(BookQrRepository());
  final stationController = Get.put(StationListController());
  var verifyApiCounter = 0;
  final isPaymentVerifing = false.obs;
  final hasVerifyPaymentSuccess = false.obs;
  final hasPaymentVerifyRetriesCompleted = false.obs;
  final isGenerateTicketError = false.obs;
  final cashFreePaymentController = Get.put(CashFreeController());
  final bool retryPurchase;

  @override
  void onInit() async {
    super.onInit();
    if (retryPurchase) {
      await verifyOrder();
    }
  }

  Future<void> verifyOrder() async {
    try {
      isPaymentVerifing.value = true;

      //Retry limit reached
      if (verifyApiCounter == 2) {
        isPaymentVerifing.value = false;
        hasVerifyPaymentSuccess.value = false;
        hasPaymentVerifyRetriesCompleted.value = true;
      } else {
        //calling verify payment after second
        Future.delayed(const Duration(seconds: 5), () async {
          try {
            final verifyPayment = await bookQrRepository
                .verifyPayment({"order_id": verifyPaymentData.orderId});
            if (verifyPayment.paymentStatus == 'SUCCESS') {
              isPaymentVerifing.value = false;
              hasVerifyPaymentSuccess.value = true;
              await generateTicket();
            } else {
              verifyApiCounter++;
              await verifyOrder();
            }
          } catch (e) {
            isPaymentVerifing.value = false;
            hasVerifyPaymentSuccess.value = false;
            TLoaders.errorSnackBar(title: '', message: e.toString());
          }
        });
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: '', message: e.toString());
    }
  }

  Future<void> generateTicket() async {
    try {
      final ticketData = await bookQrRepository.generateTicket(requestPayload);
      //Navigate to Dispaly QR Page
      if (ticketData.returnCode == '0' && ticketData.returnMsg == 'SUCESS') {
        Get.offAll(() => DisplayQrScreen(
              tickets: ticketData.tickets!,
              stationList: stationController.stationList,
              orderId: ticketData.orderId!,
              amountPaid: verifyPaymentData.orderAmount!.toString(),
              pgResponse: verifyPaymentData,
              confirmOrderData: confirmOrderData,
            ));
      } else {
        await verifyGenerateTicket();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: '', message: e.toString());
    }
  }

  verifyGenerateTicket() async {
    final token = await TLocalStorage().readData('token');
    final payload = {
      token: '$token',
      "merchantOrderId": verifyPaymentData.orderId,
      "merchantId": dotenv.env["TSAVAARI_MERCHANT_ID"]
    };
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        final verifyGenerateTicketResponse =
            await bookQrRepository.verifyGenerateTicket(payload);
        if (verifyGenerateTicketResponse.returnCode == "0" &&
            verifyGenerateTicketResponse.returnMsg == "SUCESS") {
          Get.offAll(() => DisplayQrScreen(
                tickets: verifyGenerateTicketResponse.tickets!,
                stationList: stationController.stationList,
                orderId: verifyGenerateTicketResponse.orderId!,
                amountPaid: verifyPaymentData.orderAmount!.toString(),
                pgResponse: verifyPaymentData,
                confirmOrderData: confirmOrderData,
              ));
        } else {
          refundOrder();
        }
      } catch (e) {
        refundOrder();
      }
    });
  }

  refundOrder() async {
    try {
      final token = await TLocalStorage().readData('token');
      final mobileNumber = TLocalStorage().readData('mobileNo');
      final refundOrderResponse =
          await cashFreePaymentController.createRefundOrder(
        verifyPaymentData.orderId!,
        verifyPaymentData.orderAmount!,
        mobileNumber,
        int.parse(requestPayload['noOfTickets'].toString()),
        '',
      );
      if (refundOrderResponse.cfPaymentId != null &&
          refundOrderResponse.cfRefundId != null) {
        final getRefundStatus = await cashFreePaymentController.getRefundStatus(
            verifyPaymentData.orderId!, refundOrderResponse.refundId!);
        if (getRefundStatus.refundStatus == 'SUCCESS') {
        } else if (getRefundStatus.refundStatus == 'PENDING') {
          final payload = {
            "token": "$token",
            "merchantOrderId": verifyPaymentData.orderId,
            "merchantId": dotenv.env["TSAVAARI_MERCHANT_SHORT_ID"],
            "ticketTypeId": requestPayload['ticketTypeId'],
            "noOfTickets": requestPayload['noOfTickets'],
            "merchantTotalFareAfterGst":
                requestPayload['merchantTotalFareAfterGst'],
            "travelDateTime": requestPayload['travelDateTime'],
            "patronPhoneNumber":
                await TLocalStorage().readData('mobileNo') ?? ''
          };
          final response =
              await bookQrRepository.paymentRefundIntimation(payload);
          if (response.returnCode == '0') {
            isGenerateTicketError.value = true;
          } else {
            throw 'Something went wrong!';
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
