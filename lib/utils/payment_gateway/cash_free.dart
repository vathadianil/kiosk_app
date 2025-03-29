import 'dart:io';

import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/create_refund_model.dart';
import 'package:kiosk_app/repositories/book-qr/refund_qr_repository.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class CashFreeController extends GetxController {
  final _refundQrRepository = Get.put(RefundQrRepository());

  Future<CreateRefundModel> createRefundOrder(String orderId, String amount,
      String mobileNumber, int noOfTickets, String rjtIds) async {
    try {
      //Creating refund order
      String platformCode = '';
      if (Platform.isAndroid) {
        platformCode = 'AND';
      } else if (Platform.isIOS) {
        platformCode = 'IOS';
      }

      final userId = TLocalStorage().readData('userId');

      final refundOrderPayload = {
        "user_id": userId,
        "order_id": orderId,
        "refund_amount": amount,
        "refund_id": "RFD$platformCode${DateTime.now().millisecondsSinceEpoch}",
        "refund_note": "",
        "refund_speed": "STANDARD",
        "customer_mobile": mobileNumber,
        "noOfTckts_selected": noOfTickets,
        "metro_rjt_id": rjtIds,
      };

      final refundOrderResponse =
          await _refundQrRepository.createRefundOrder(refundOrderPayload);
      return refundOrderResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateRefundModel> getRefundStatus(
      String orderId, String refundId) async {
    try {
      final refundStatus = await _refundQrRepository
          .getRefundOrderStatus({"order_id": orderId, "refund_id": refundId});
      return refundStatus;
    } catch (e) {
      rethrow;
    }
  }
}
