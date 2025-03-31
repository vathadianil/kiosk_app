import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/widgets/payment_processing_screen.dart';
import 'package:kiosk_app/features/display-qr/display-qr-screen.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/repositories/book-qr/book-qr-repository.dart';
import 'package:kiosk_app/utils/constants/qr_merchant_id.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:convert';

class GenerateTicketController extends GetxController {
  static GenerateTicketController get instance => Get.find();
  RxBool isConnected = false.obs;
  GenerateTicketController({
    required this.ticketType,
    required this.destination,
    required this.createOrderData,
    required this.passengerCount,
    required this.finalFare,
    required this.fareQouteId,
  });
  final String ticketType;
  final String destination;
  final int passengerCount;
  final int finalFare;
  final String fareQouteId;
  final CreateSposOrderModel createOrderData;
  final bookQrRepository = Get.put(BookQrRepository());
  Timer? _timer;
  var isDataFound = false.obs;
  var isApiPoolingStarted = false;

  late MqttServerClient client;
  String brokerUrl = "mqtt.afc-transit.com"; // Your MQTT broker URL
  int port = 8883; // Use 8883 for secure connection (SSL/TLS)
  String clientId = TLocalStorage().readData('equipmentId');

  @override
  void onInit() {
    super.onInit();
    if (TLocalStorage().readData('useMqtt') == 'Y') {
      connectToMqtt(createOrderData.orderId ?? '');
    } else {
      startApiPolling(); // Start API polling when the controller is initialized
    }
  }

  swithToApiPolling() {
    if (TLocalStorage().readData('useMqtt') == 'Y') {
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        if (kDebugMode) {
          print("🔌 Disconnecting MQTT client...");
        }
        client.disconnect();
        isConnected.value = false;
      }
    }
    startApiPolling();
  }

  /// Connect to MQTT Broker and Subscribe to Topic
  Future<void> connectToMqtt(String orderId) async {
    client = MqttServerClient(
      brokerUrl,
      clientId,
    );
    client.secure = true;
    client.port = port;

    // Set Keep Alive Interval
    client.keepAlivePeriod = 20;

    client.onConnected = onConnected;
    // client.onDisconnected = onDisconnected;

    // Setup connection options
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          clientId,
        )
        .authenticateAs('kskuatmqtt', 'kskmqtt@312')
        .startClean() // Start with a clean session
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      if (kDebugMode) {
        print("🔌 Connecting to MQTT...");
      }
      await client.connect();
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        if (kDebugMode) {
          print("✅ Connected to MQTT broker");
        }
        isConnected.value = true;
        subscribeToTopic(orderId);
      } else {
        if (kDebugMode) {
          print(
              "❌ Failed to connect to MQTT. Status: ${client.connectionStatus}");
        }
        isConnected.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ MQTT Connection Error: $e");
      }
      isConnected.value = false;
      reconnectMqtt(); // Try to reconnect if connection fails
    }
  }

  /// Reconnect to MQTT Broker after Delay
  void reconnectMqtt() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!isConnected.value) {
        if (kDebugMode) {
          print("🔄 Attempting to reconnect...");
        }
        connectToMqtt(createOrderData.orderId ?? '');
      }
    });
  }

  /// Handle MQTT Connection Success
  void onConnected() {
    if (kDebugMode) {
      print("✅ MQTT Connection Established.");
    }
    isConnected.value = true;
  }

  void onDisconnected() {
    if (!isDataFound.value) {
      reconnectMqtt();
    }
  }

  /// Subscribe to Payment Status Topic
  void subscribeToTopic(String orderId) {
    final topic = orderId;
    client.subscribe(topic, MqttQos.atMostOnce);
    if (kDebugMode) {
      print("📡 Subscribed to topic: $topic");
    }

    // Listen for incoming messages
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage message =
          messages[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      // Process Payment Status
      final data = jsonDecode(payload);
      final confirmOrderData = PaymentConfirmModel.fromJson(data);
      if (confirmOrderData.orderId == orderId) {
        if (confirmOrderData.paymentStatus == "SUCCESS") {
          isDataFound.value = true;
          generateTicket(confirmOrderData);
        } else {
          gotoPaymentProcessingScreen(confirmOrderData: confirmOrderData);
        }
      }
    });
  }

  /// Start polling API every 5 seconds
  void startApiPolling() {
    _timer?.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isDataFound.value) {
        fetchDataFromApi(); // Call API only if data is not found
      } else {
        stopApiPolling(); // Stop timer if data is found
      }
    });
  }

  /// Stop API polling
  void stopApiPolling() {
    _timer?.cancel();
    if (kDebugMode) {
      print('✅ Polling stopped. Data found.');
    }
  }

  /// Fetch data from API
  Future<void> fetchDataFromApi() async {
    try {
      final paymentData = await bookQrRepository
          .verifyPayment({"order_id": createOrderData.orderId});
      if (paymentData.paymentStatus == 'SUCCESS') {
        isDataFound.value = true;
        generateTicket(paymentData);
      } else if (paymentData.paymentStatus == 'PENDING') {
        if (kDebugMode) {
          print('❌ No data Found');
        }
      } else if (paymentData.paymentStatus == 'FAILED' ||
          paymentData.paymentStatus == 'USER_DROPPED') {
        isDataFound.value = true;
        gotoPaymentProcessingScreen(
            confirmOrderData: paymentData, retryPurchase: false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❗ Error fetching data: $e');
      }
    }
  }

  Future<void> gotoPaymentProcessingScreen(
      {retryPurchase = false, confirmOrderData}) async {
    final requestPayload = await prepareGenerateTicketPayload();
    Get.off(() => PaymentProcessingScreen(
          generateTicketPayload: requestPayload,
          verifyPayment: createOrderData,
          retryPurchase: retryPurchase,
          confirmOrderData: confirmOrderData,
        ));
  }

  Future<void> generateTicket(PaymentConfirmModel confirmOrderData) async {
    try {
      final requestPayload = await prepareGenerateTicketPayload();
      final ticketData = await bookQrRepository.generateTicket(requestPayload);
      if (ticketData.returnCode == '0' && ticketData.returnMsg == 'SUCESS') {
        Get.off(() => DisplayQrScreen(
            tickets: ticketData.tickets ?? [],
            stationList: StationListController.instance.stationList,
            orderId: createOrderData.orderId ?? '',
            amountPaid: createOrderData.orderAmount ?? '',
            pgResponse: createOrderData,
            confirmOrderData: confirmOrderData));
      }
    } catch (e) {
      gotoPaymentProcessingScreen(
        confirmOrderData: confirmOrderData,
        retryPurchase: true,
      );
    }
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
    final equipmentId = TLocalStorage().readData('equipmentId');
    final terminalId = TLocalStorage().readData('terminalId');

    final toStationId = destination;
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

  /// Disconnect MQTT and Clean Resources
  @override
  void onClose() {
    super.onClose();

    if (TLocalStorage().readData('useMqtt') == 'Y' && !isApiPoolingStarted) {
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        if (kDebugMode) {
          print("🔌 Disconnecting MQTT client...");
        }
        client.disconnect();
        isConnected.value = false;
      }
    } else {
      stopApiPolling();
    }
  }
}
