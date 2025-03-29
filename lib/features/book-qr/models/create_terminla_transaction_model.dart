class CreateTerminalTransactionModel {
  String? cfPaymentId;
  int? paymentAmount;
  String? paymentMethod;
  String? qrcode;
  int? timeout;

  CreateTerminalTransactionModel(
      {this.cfPaymentId,
      this.paymentAmount,
      this.paymentMethod,
      this.qrcode,
      this.timeout});

  CreateTerminalTransactionModel.fromJson(Map<String, dynamic> json) {
    cfPaymentId = json['cf_payment_id'];
    paymentAmount = json['payment_amount'];
    paymentMethod = json['payment_method'];
    qrcode = json['qrcode'];
    timeout = json['timeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cf_payment_id'] = cfPaymentId;
    data['payment_amount'] = paymentAmount;
    data['payment_method'] = paymentMethod;
    data['qrcode'] = qrcode;
    data['timeout'] = timeout;
    return data;
  }
}
