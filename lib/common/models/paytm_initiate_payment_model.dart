class PaytmPaymentInitiateModel {
  Head? head;
  Body? body;

  PaytmPaymentInitiateModel({this.head, this.body});

  PaytmPaymentInitiateModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? Head.fromJson(json['head']) : null;
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (head != null) {
      data['head'] = head!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Head {
  String? responseTimestamp;
  String? version;
  String? signature;

  Head({this.responseTimestamp, this.version, this.signature});

  Head.fromJson(Map<String, dynamic> json) {
    responseTimestamp = json['responseTimestamp'];
    version = json['version'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseTimestamp'] = responseTimestamp;
    data['version'] = version;
    data['signature'] = signature;
    return data;
  }
}

class Body {
  ResultInfo? resultInfo;
  String? txnToken;
  bool? isPromoCodeValid;
  bool? authenticated;

  Body(
      {this.resultInfo,
      this.txnToken,
      this.isPromoCodeValid,
      this.authenticated});

  Body.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? ResultInfo.fromJson(json['resultInfo'])
        : null;
    txnToken = json['txnToken'];
    isPromoCodeValid = json['isPromoCodeValid'];
    authenticated = json['authenticated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resultInfo != null) {
      data['resultInfo'] = resultInfo!.toJson();
    }
    data['txnToken'] = txnToken;
    data['isPromoCodeValid'] = isPromoCodeValid;
    data['authenticated'] = authenticated;
    return data;
  }
}

class ResultInfo {
  String? resultStatus;
  String? resultCode;
  String? resultMsg;

  ResultInfo({this.resultStatus, this.resultCode, this.resultMsg});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    resultStatus = json['resultStatus'];
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultStatus'] = resultStatus;
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    return data;
  }
}
