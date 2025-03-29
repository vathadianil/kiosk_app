class PaymentConfirmModel {
  String orderId;
  double? orderAmount;
  String orderCurrency;
  String paymentTime;
  String bankReference;
  String paymentMethod;
  String paymentId;
  String paymentStatus;

  PaymentConfirmModel(
      {required this.orderId,
      this.orderAmount,
      required this.paymentTime,
      required this.orderCurrency,
      required this.bankReference,
      required this.paymentMethod,
      required this.paymentId,
      required this.paymentStatus});

  static PaymentConfirmModel empty() => PaymentConfirmModel(
        orderId: '',
        orderAmount: null,
        paymentTime: '',
        orderCurrency: '',
        bankReference: '',
        paymentMethod: '',
        paymentId: '',
        paymentStatus: '',
      );

  factory PaymentConfirmModel.fromJson(Map<String, dynamic>? data) {
    if (data != null) {
      return PaymentConfirmModel(
        orderId: data['order_id'] ?? '',
        orderAmount: data['order_amount'],
        paymentTime: data['payment_time'] ?? '',
        paymentId: data['payment_id'].toString(),
        orderCurrency: data['order_currency'] ?? '',
        bankReference: data['bank_reference'] ?? '',
        paymentMethod: data['payment_method'] ?? '',
        paymentStatus: data['payment_status'] ?? '',
      );
    } else {
      return PaymentConfirmModel.empty();
    }
  }
}
